import gtk.MainWindow;
import gtk.Button;
import gtk.Main;

import gdk.Event;
import gtk.Widget;
import gtk.Entry;
import gtk.Box;
import gdk.Color;
import gtk.Label;
import gtk.c.types;

void main(string[] args)
{
    Main.init(args);
    MainWindow win = new MainWindow("Komandoa : ");
    win.add(new TextLine("one sample text"));
    win.showAll();
    Main.run();
}

class TextLine : Entry
{
    this(in string text)
    {
        super(text);
        modifyFont("Arial", 14);
        modifyFg(StateType.NORMAL, new Color(0xFF,00,0xFF));
        modifyBg(StateType.NORMAL, new Color(0x00,00,0x00));
    }
}
