module textline.history;

import std.algorithm;
import std.array;


class History 
{
    private char[] content;
    private uint cursorPosition;
    private bool commandMode;

    this(in string text)
    {
        content = text.dup ~ "_";
        cursorPosition = cast(uint)text.length;
        commandMode = true;
    }

    string getContent()
    {
        return content[0 .. $-1].idup;
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
    }
     
    string removeCharacter()
    {
        if (cursorPosition < content.length)
        {
            if (cursorPosition > 1) 
            {
                content[cursorPosition-1 .. $-1] = content[cursorPosition .. $].dup;
                content.length--;
                cursorPosition--;
            }
            else 
            {
                content[cursorPosition .. $-1] = content[cursorPosition + 1 .. $].dup;
                content.length--;
            }
        } 
       return content[0 .. $-1].idup; 
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
