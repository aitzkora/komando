module textline.history;

import std.algorithm;
import std.array;
import std.stdio;
import std.process;
import std.file;
import core.stdc.stdlib;

class History 
{
  private immutable int maxHistoryLength = 100;
  private char[][maxHistoryLength] history;
  private int historyLength;
  private int historyPos;
  private char[] content;
  private char[] contentBeforeLastInsertion;
  private uint cursorPosition;
  private bool commandMode;
  File debugFile;
  File historyFile;
  bool isDebugOn;

  this(in string text, ref File debugFile)
  {
    content = text.dup;
    cursorPosition = cast(uint)text.length-1;
    commandMode = false;
    this.debugFile = debugFile;
    isDebugOn = debugFile.isOpen();
    loadHistoryFile();
    historyPos = 0;
    contentBeforeLastInsertion = content;
  }


  void loadHistoryFile()
  {
    auto fname =  environment.get("HOME") ~ "/.komando_hist";
    historyLength = 1;
    history[0] = content;
    if (!fname.exists) 
    {
      historyFile = File( fname, "w");
      if (isDebugOn) 
        debugFile.writeln("history file does not exists");
    }
    else
    {
      historyFile = File (fname, "r+"); 
     if (isDebugOn) debugFile.writeln("content of the history file");
      foreach(line ; historyFile.byLine)
      {
        if (historyLength > maxHistoryLength-1) break;
        history[historyLength++] = line[];
          if (isDebugOn) debugFile.writeln(history[historyLength-1]);
      }
    }
  }

  void closeHistoryFile()
  {
    historyFile.writeln(content);
    historyFile.close();
  }


  string loadPreviousContent()
  {
    if (historyPos < historyLength - 1)
    {
      historyPos++;
      content = history[historyPos];
      goStartOfLine();
    }
    if (isDebugOn) debugFile.writeln("loadPreviousContent ", content);
    return content.idup;
  }
  string loadNextContent()
  {
    if (historyPos > 0)
    {
      historyPos--;
      content = history[historyPos];
      goStartOfLine();
    }
    if (isDebugOn) debugFile.writeln("loadNextContent ", content);
    return content.idup;
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
      debugFile.writeln("commande mode = ", commandMode);
  }

  void execCommandMode()
  {
    if (isDebugOn)
      debugFile.writeln("executing commande : ", content.idup());

    auto pid = spawnProcess(content.idup().split());
    scope(success){
      if (isDebugOn)
        debugFile.writeln("success");
      closeHistoryFile();
      exit(0); 
    }
    scope(failure){
      if (isDebugOn)
        debugFile.writeln("failed");
      exit(-1); 
    }
  }

  void storeLastInsertion()
  {
    contentBeforeLastInsertion = content.dup;
  }

  string removeCharacter()
  {
    if (content.length > 0)
    {
      content = remove(content, cursorPosition);
      if (cursorPosition > 0)
        cursorPosition--;
      if (isDebugOn)
        debugFile.writeln("d" , cursorPosition, ", content → ", content);
    }
    else
    {
      if (isDebugOn)
        debugFile.writeln("WARNING : cannot remove any character, the string is empty");
    }

    return getContent();
  }

  string insertCharacter(in string character)
  {
    if (character.length >=1)
    { 
      content.insertInPlace(++cursorPosition, character);
      //++cursorPosition;
    }
    return getContent();
  }


  string deleteLastInsertion()
  {
    if (isDebugOn) 
      debugFile.writeln("try to delete last insertion");
    content = contentBeforeLastInsertion;
    if (content.length > 0)
      cursorPosition = cast(uint)(content.length - 1);
    else
      cursorPosition = 0;
    return getContent();
  }
  void goLeft()
  {
    if (isDebugOn) 
      debugFile.writeln("go to Left if possible");
    if (cursorPosition > 0)
      cursorPosition--; 
  }

  void goRight()
  {
    if (content.length > 0) 
    {
      if (isDebugOn) 
        debugFile.writeln("go to Right if possible");
      if (cursorPosition < (content.length - 1))
        cursorPosition++;
    }
  }
    uint goEndOfLine()
    {
      if (isDebugOn) 
        debugFile.writeln("go to the end of the line ");
      cursorPosition = cast(uint)(content.length);
      return cursorPosition;
    }

    void goStartOfLine()
    {
      if (isDebugOn) 
        debugFile.writeln("go to the beginning of the line ");
      cursorPosition = 0;
    }

    bool complete()
    {
      // for now do nothing
      //auto first = content.split("  ");
      //foreach(s; environment["PATH"].split(":"))
      //{
      //  auto z = dirEntries(s, SpanMode.shallow).
      //    filter!(a => baseName(a.name)==str);
      //  if (!z.empty) return true;
      //} 
      return true;
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
              History his = new History("123".dup, neant);
              his.removeCharacter();
              his.removeCharacter();
              his.removeCharacter();
              his.getContent.shouldEqual("", "string value");
              });
          }, "remove", "entire");
      feature("removing character from a zero length string ", (f)
          {
          f.scenario("removing from empty does nothing",
              {
              History his = new History("", neant);
              his.removeCharacter();
              his.getContent.shouldEqual("", "string value");
              });
          }, "remove", "empty");
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

