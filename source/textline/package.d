module textline;

import gtk.Entry;
import gtk.c.types;
import gdk.Color;
import gdk.Event;
import gtk.Widget;
import std.stdio;
import gdk.Keysyms;
import std.algorithm;
import std.array;
import gdk.Keymap;

class TextLine : Entry
{
  char[] content;
  uint cursorPosition;
  bool commandMode;

  this(in string text)
    {
        super(text);
        content = text.dup;
        cursorPosition = cast(uint)text.length-1;
        commandMode = true;
        // modify aspect 
        modifyFont("Arial", 14);
        modifyFg(StateType.NORMAL, new Color(0xFF,00,0xFF));
        modifyBg(StateType.NORMAL, new Color(0x00,00,0x00));
        //setHalign(0.);
        // add callbacks
        addOnKeyPress(&keysAnalyze);
    }
   private bool keysAnalyze(GdkEventKey * even, Widget widget)
   {
      //GdkEventKey *ev = even.key;
     if (commandMode) 
     {
         switch(even.keyval) 
         {
             case GdkKeysyms.GDK_i: commandMode = false;
                                    break;
             case GdkKeysyms.GDK_x: assert(cursorPosition < content.length);
                                    if (cursorPosition > 0) 
                                    {
                                        content[cursorPosition .. $-1] = content[cursorPosition+1 .. $].dup;
                                        content.length--;
                                        setText(content.idup);
                                        cursorPosition--;
                                    }
                                    break;
             case GdkKeysyms.GDK_l: if (cursorPosition < content.length -1)
                                        cursorPosition++; 
                                    break;
             case GdkKeysyms.GDK_h: if (cursorPosition > 0)
                                        cursorPosition--; 
                                    break;
             case GdkKeysyms.GDK_dollar: cursorPosition = cast(uint)(content.length - 1);
                                         break;
             case GdkKeysyms.GDK_caret: cursorPosition = 0;
                                         break;

             default:break;
         }
     }
     else // we are in insert mode
     { 
         switch(even.keyval) {
             case GdkKeysyms.GDK_Escape: commandMode = true;
                                         break; 
             default: content.insertInPlace(cursorPosition, keyToString(even.keyval));
                      cursorPosition++;
                      setText(content.idup);
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
