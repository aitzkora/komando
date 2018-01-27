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

  this(in string text)
    {
        super(text);
        hist = new History(text);
        // modify aspect 
        modifyFont("Arial", 14);
        modifyFg(StateType.NORMAL, new Color(0xFF,00,0xFF));
        modifyBg(StateType.NORMAL, new Color(0x00,00,0x00));
        // add callbacks
        addOnKeyPress(&keysAnalyze);
    }
   
  private bool keysAnalyze(GdkEventKey * even, Widget widget)
   {
     if (hist.getCommandMode()) 
     {
         switch(even.keyval) 
         {
            case GdkKeysyms.GDK_i: hist.setCommandMode(false);
                                    break;
             case GdkKeysyms.GDK_x: setText(hist.removeCharacter());
                                    break;
             case GdkKeysyms.GDK_l: hist.goRight();
                                    break;
             case GdkKeysyms.GDK_h: hist.goLeft();
                                    break;
             case GdkKeysyms.GDK_dollar: hist.goEndOfLine();
                                         break;
             case GdkKeysyms.GDK_caret: hist.goStartOfLine();
                                         break;

             default:break;
         }
     }
     else // we are in insert mode
     { 
         switch(even.keyval) {
             case GdkKeysyms.GDK_Escape: hist.setCommandMode(true);
                                         break; 
             default: setText(hist.insertCharacter(keyToString(even.keyval)));
                      break;
         }
     }
     return true;
   }

    string keyToString(uint keyval)
    {
        switch(keyval)
        {
            case GdkKeysyms.GDK_space: return " ";
            case GdkKeysyms.GDK_BackSpace : return "";
            default:return Keymap.keyvalName(keyval);
        }
    }

  }
