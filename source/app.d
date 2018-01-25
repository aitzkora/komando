import gtk.MainWindow;
import gtk.Button;
import gtk.Main;

import gdk.Event;
import gtk.Widget;
void main(string[] args)
{
    Main.init(args);
    MainWindow win = new MainWindow("Egun on");
    win.add(new QuitButton("Egun on"));
    win.showAll();
    Main.run();
}

class QuitButton : Button
{
    this(in string text)
    {
        super(text);
        modifyFont("Arial", 14);
        addOnButtonRelease(&quit);
    }

    private bool quit(Event event, Widget widget)
    {
        Main.quit();
        return true;
    }
}

