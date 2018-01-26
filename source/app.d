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
import textline;

void main(string[] args)
{
    Main.init(args);
    MainWindow win = new MainWindow("Komandoa : ");
    win.add(new TextLine("une chaine d'exemple"));
    win.showAll();
    Main.run();
}
