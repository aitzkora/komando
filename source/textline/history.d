module textline.history;

import std.algorithm;
import std.array;
import std.stdio;

class History 
{
    private char[] content;
    private uint cursorPosition;
    private bool commandMode;
    File debugFile;
    bool isDebugOn;

    this(in string text, ref File debugFile)
    {
        content = text.dup ~ "_";
        cursorPosition = cast(uint)text.length;
        commandMode = true;
        this.debugFile = debugFile;
        isDebugOn = debugFile.isOpen();
    }

    string getContent()
    {
        return content.idup;
    }

    int getCursorPosition()
    {
        return cursorPosition;
    }

    bool getCommandMode()
    {
        return commandMode;
    }

    void setCommandMode(bool mode)
    {
        commandMode = mode;
        if (isDebugOn)
        {
            debugFile.writeln("commande mode = ", commandMode);
        }
    }

    void execCommandMode()
    {
        if (isDebugOn)
        {
            debugFile.writeln("ERROR : exec commande No yet implemented");
        }

    }


    string removeCharacter()
    {
        if (content.length >= 1)
        {
            if (cursorPosition >= 1)
            {
                content[cursorPosition .. $ - 1] = content[cursorPosition + 1 .. $].dup;
                content.length--;
                cursorPosition--;
            }
            else
            {
                content[cursorPosition .. $-1] = content[cursorPosition + 1 .. $].dup;
                content.length--;
            }
            if (isDebugOn)
            {
                debugFile.writef("remove char in %d-position content → %s\n", content);
            }
        }
        else
        {
            if (isDebugOn)
            {
                debugFile.writef("WARNING : cannot remove any character, the string is empty");
            }

        }

        return content.idup;
    }

    string insertCharacter(in string character)
    {
       content.insertInPlace(cursorPosition, character);
       cursorPosition++;
       return content[0 .. $-1].idup;
    }

    void goLeft()
    {
        if (cursorPosition > 0)
            cursorPosition--; 
    }

    void goRight()
    {
        if (cursorPosition < content.length -1)
            cursorPosition++;
    }

    void goEndOfLine()
    {
        cursorPosition = cast(uint)(content.length - 1);
    }
    void goStartOfLine()
    {
        cursorPosition = 0;
    }
}
