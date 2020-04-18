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
import std.stdio;
void main(string[] args)
{
    bool debugFlag;
    auto optArgs = getopt(args, "debug", &debugFlag);

    File debugFile;
    if (debugFlag)
    {
        debugFile.open("/tmp/komandoLog.txt", "w");
    }

    Main.init(args);
    MainWindow win = new MainWindow("Komandoa : ");

    win.add(new TextLine("ls /home/", debugFile));
    win.showAll();
    Main.run();
}
