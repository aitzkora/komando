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
        if (isDebugOn) 
        {
            debugFile.writeln("val = ", even.keyval);
            debugFile.flush();
        }
        if (hist.getCommandMode())
        {

            switch(even.keyval)
            {
                case GdkKeysyms.GDK_i: hist.setCommandMode(false);
                                       break;
                case GdkKeysyms.GDK_x: setText(hist.removeCharacter());
                                       setPosition(hist.getCursorPosition());
                                       break;
                case GdkKeysyms.GDK_l: hist.goRight();
                                       setPosition(hist.getCursorPosition());
                                       break;
                case GdkKeysyms.GDK_h: hist.goLeft();
                                       setPosition(hist.getCursorPosition());
                                       break;
                case GdkKeysyms.GDK_dollar: setPosition(hist.goEndOfLine()-1);
                                            break;
                case GdkKeysyms.GDK_asciicircum: hist.goStartOfLine();
                                       setPosition(0);
                                                 break;
                case GdkKeysyms.GDK_A: setPosition(hist.goEndOfLine()-1);
                                       hist.setCommandMode(false);
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
                                            break;
                case GdkKeysyms.GDK_Return: hist.execCommandMode();
                                            break;
                case GdkKeysyms.GDK_Tab: if ( hist.complete() )
                                             modifyFg(StateType.NORMAL, new Color(0x00,0xFF,00));
                                         else
                                             modifyFg(StateType.NORMAL, new Color(0xFF,0x00,00));
                                         break;
                default: setText(hist.insertCharacter(keyToString(even.keyval)));
                         break;
            }
        }
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
            case GdkKeysyms.GDK_A:..case GdkKeysyms.GDK_Z: 
            case GdkKeysyms.GDK_a:..case GdkKeysyms.GDK_z: return Keymap.keyvalName(keyval);

            default: return "";
        }
    }



}
