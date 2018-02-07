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
        content = text.dup;
        cursorPosition = cast(uint)text.length;
        commandMode = true;
        this.debugFile = debugFile;
        isDebugOn = debugFile.isOpen();
    }

    string getContent()
    {
        if (content.length >= 1)
        { 
        return content.idup;
        }
        else  // to avoid to return 0x0!!!
        { 
            return "";
        }
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
            if (cursorPosition < content.length && cursorPosition > 0)
            {
                content.length--;
                cursorPosition--;
            }
            else
            {
               content.length--;
               cursorPosition--;
            }
            if (isDebugOn)
            {
                debugFile.writeln("remove char in ", cursorPosition, " -position : content → ", content);
            }
        }
        else
        {
            if (isDebugOn)
            {
                debugFile.writeln("WARNING : cannot remove any character, the string is empty");
            }

        }

        return getContent();
    }

    string insertCharacter(in string character)
    {
       content.insertInPlace(cursorPosition, character);
       cursorPosition++;
       return getContent();
    }

    void goLeft()
    {
        if (cursorPosition > 0)
            cursorPosition--; 
    }

    void goRight()
    {
        if (cursorPosition < content.length )
            cursorPosition++;
    }

    void goEndOfLine()
    {
        cursorPosition = cast(uint)(content.length);
    }

    void goStartOfLine()
    {
        cursorPosition = 0;
    }
}


debug (featureTest)
{
    import feature_test;
    unittest
    {
        File neant;
        feature("removing three characters from 3-characters string", (f)
                {
                f.scenario("removing does not work",
                        {
                        History his = new History("123", neant);
                        his.removeCharacter();
                        his.removeCharacter();
                        his.removeCharacter();
                        his.getContent.shouldEqual("", "string value");
                        });
                }, "remove");
        feature("removing character from a zero length string ", (f)
                {
                f.scenario("removing does not work",
                        {
                        History his = new History("", neant);
                        his.removeCharacter();
                        his.getContent.shouldEqual("", "string value");
                        });
                }, "remove");
        feature("inserting two characters", (f)
                {
                f.scenario("insertion is broken",
                        {
                        History his = new History("", neant);
                        his.insertCharacter("a");
                        his.insertCharacter("b");
                        his.getContent.shouldEqual("ab", "string value");
                        });
                }, "insert");
}
}

