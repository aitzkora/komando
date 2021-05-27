module textline;

public import textline.history;

import gtk.Entry;
import gtk.c.types;
import gdk.Color;
import gdk.Event;
import gtk.Widget;
import std.stdio;
import gdk.Keysyms;
import gdk.Keymap;

class TextLine : Entry
{
  History hist;
  File debugFile;
  bool isDebugOn;
  this(in string text, ref File debugFile)
  {
    super(text);
    this.debugFile = debugFile;
    isDebugOn = debugFile.isOpen();
    hist = new History(text, debugFile);
    // modify aspect 
    modifyFont("Times", 18);
    modifyFg(StateType.NORMAL, new Color(0xFF,00,0xFF));
    modifyBg(StateType.NORMAL, new Color(0x00,00,0x00));
    // add callbacks
    addOnKeyPress(&keysAnalyze);
    //addOnActivate(&entryActived);
  }

  private bool entryActived()
  {
    this.setPosition(-1);
    return true;
  }


  private bool keysAnalyze(GdkEventKey * even, Widget widget)
  {
    bool controlIsPressed =(( even.state & GdkModifierType.CONTROL_MASK)  != 0);
    if (isDebugOn) 
    {
      debugFile.writeln("val = ", even.keyval);
      debugFile.writeln("Control = ", controlIsPressed);
      debugFile.flush();
    }
    if (hist.getCommandMode())
    {
      switch(even.keyval)
      {
        case GdkKeysyms.GDK_i: hist.setCommandMode(false);
                               hist.storeLastInsertion();
                               break;
        case GdkKeysyms.GDK_x: setText(hist.removeCharacter());
                               break;
        case GdkKeysyms.GDK_l: hist.goRight();
                               break;
        case GdkKeysyms.GDK_h: hist.goLeft();
                               break;
        case GdkKeysyms.GDK_dollar: hist.goEndOfLine();
                                    break;
        case GdkKeysyms.GDK_asciicircum: hist.goStartOfLine();
                                         break;
        case GdkKeysyms.GDK_A: hist.goEndOfLine();
                               hist.setCommandMode(false);
                               hist.storeLastInsertion();
                               break;
        case GdkKeysyms.GDK_k : setText(hist.loadPreviousContent());
                                break;
        case GdkKeysyms.GDK_j : setText(hist.loadNextContent());
                                break;
        case GdkKeysyms.GDK_Return: hist.execCommandMode();
                                    break;
        default:break;
      }
    }
    else // we are in insert mode
    {
      switch(even.keyval) {
        case GdkKeysyms.GDK_Escape: hist.setCommandMode(true);
                                    hist.goLeft();
                                    break;
        case GdkKeysyms.GDK_Return: hist.execCommandMode();
                                    break;
        case GdkKeysyms.GDK_Tab: if ( hist.complete() )
                                   modifyFg(StateType.NORMAL, new Color(0x00,0xFF,00));
                                 else
                                   modifyFg(StateType.NORMAL, new Color(0xFF,0x00,00));
                                 break;
        case GdkKeysyms.GDK_w : if (controlIsPressed)
                                  setText(hist.deleteLastInsertion());
                                else
                                  setText(hist.insertCharacter(keyToString(even.keyval)));
                                break;
        default: setText(hist.insertCharacter(keyToString(even.keyval)));
                 break;
      }
    }
    if (isDebugOn)
      debugFile.writeln("content = ", hist.getContent());
    setPosition(hist.getCursorPosition());
    return true;
  }

  string keyToString(uint keyval)
  {
    if (isDebugOn)
    {
      debugFile.writeln("keyName = ", Keymap.keyvalName(keyval));
    }
    switch(keyval)
    {
      case GdkKeysyms.GDK_space: return " ";
      case GdkKeysyms.GDK_minus: return "-";
      case GdkKeysyms.GDK_slash: return "/";
      case GdkKeysyms.GDK_underscore : return "_";
      case GdkKeysyms.GDK_asterisk : return "*";
      case GdkKeysyms.GDK_period : return ".";
      case GdkKeysyms.GDK_A:..case GdkKeysyms.GDK_Z: 
      case GdkKeysyms.GDK_a:..case GdkKeysyms.GDK_z: return Keymap.keyvalName(keyval);
      case GdkKeysyms.GDK_0:..case GdkKeysyms.GDK_9: return Keymap.keyvalName(keyval);

      default: return "";
    }
  }



}
