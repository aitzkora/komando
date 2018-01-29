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

import std.getopt;

void main(string[] args)
{
    bool debugFlag; 
    auto optArgs = getopt(args, "debug", &debugFlag);
    
    Main.init(args);
    MainWindow win = new MainWindow("Komandoa : ");
      
    win.add(new TextLine("une chaine d'exemple", debugFlag));
    win.showAll();
    Main.run();
}
