import java.util.Arrays; //<>//
String ALLCHARS = "⁰¹²³⁴⁵⁶⁷⁸\t\n⁹±∑«»æÆø‽§°¦‚‛⁄¡¤№℮½← !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~↑↓≠≤≥∞√═║─│≡∙∫○׀′¬⁽⁾⅟‰÷╤╥ƨƧαΒβΓγΔδΕεΖζΗηΘθΙιΚκΛλΜμΝνΞξΟοΠπΡρΣσΤτΥυΦφΧχΨψΩωāčēģīķļņōŗšūž¼¾⅓⅔⅛⅜⅝⅞↔↕∆≈┌┐└┘╬┼╔╗╚╝░▒▓█▲►▼◄■□…‼⌠⌡¶→“”‘’"; //<>//
//numbers         │xxxxxxx  | |x xxxxxxxx  x   x   xxxx|xxxx x  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx x xx /x xx|xxx  xxxxxx   xxx  xxxx xx xx xx x   xxx x  x   x        x xxx     xx  xx    /x xxx  xx  x   x  xxxx     xx  x   xxxxxx x xx      xxx xxxx  x   /  x        xx  xxxx│
//strings         │xxxxxxx  | |x xxxxxxxx     xx   xxxx|xxx  x  xxxxxxxxxxxxxxxxxx x xxxxxxxxx xxxxxxxx x xx /x xx| x   xxxxxx   xxx xxxxx xx  x x  x   x          x    xx    xxx   Dxx   xx xxx x          x    x          //  xx  xxxxxx xx        xxx xxxxxxx   /  x         x   xxx│
//arrays          │x  xxxx  | |x     xxxx      x     x/|xxx      xxxxxxxxxxxxxxxx     xxxxxxxx   xxxxxx   x   x xx| x x xxxxxx     x  xxx  x   x x  x           x /x           xx         x      x                              x/  xxxxxx xx        xxx xxxxxxx   /  x x x   x     x x│
//^^ are the currently supported functions
String printableAscii =  " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
String ASCII = "";
//0,28,30,31,30,28,33, 29,26'25, 24
final int NONE = 0;
final int STRING = 2;
final int BIGDECIMAL = 3;
final int ARRAY = 4;
final int INS = 5;//input string
final int INN = 6;//input number
final int JSONOBJ = 7;
final int JSONARR = 8;
final BigDecimal ZERO = BigDecimal.ZERO;
boolean saveDebugToFile;
boolean saveOutputToFile;
boolean logDecompressInfo;
boolean oldInputSystem;
boolean getDebugInfo;
boolean printDebugInfo;
boolean readFromArg;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.math.RoundingMode;
import java.math.MathContext;
import java.nio.file.Paths;
import java.nio.file.Files;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
StringList savedOut = new StringList();
StringList log = new StringList();
Executable currentPrinter = null;
int precision = 200;
Poppable PZERO = new Poppable(ZERO);
//--ENDINIT--
void setup() {
  try {
    if (args == null)
      args = new String[]{"p.sogl"};
    saveDebugToFile = false;
    saveOutputToFile = false;
    logDecompressInfo = false;
    oldInputSystem = false;
    getDebugInfo = true;
    printDebugInfo = true;
    readFromArg = false;
    for (int i=0; i<256; i++) ASCII+=char(i)+"";
    String lines[];
    if (oldInputSystem) {
      lines = loadStrings("p.sogl");
    } else {
      lines = args;
      if (!readFromArg)
        lines[0] = readFile(dataPath(args[0]), StandardCharsets.UTF_8);
    }
    String program = lines[0];
    String[] inputs = new String[lines.length-1];
    for (int i = 1; i < lines.length; i++) {
      inputs[i-1]=lines[i];
    }
    //z’¤{«╥q;}x[p     { =4b*I*:O =Ob\"   =”*o        ]I³r3w;3\\+
    //currentPrinter = new Executable("", null);
    Executable main = new Executable(program, inputs);
    currentPrinter = main;
    /*IP5 await IP5*/main.execute();
    
    if (saveOutputToFile) {
      String j =savedOut.join("");
      if (j.charAt(0)=='\n') j=j.substring(1);
      if (j.length() > 0 && j.charAt(j.length()-1)=='\n') j=j.substring(0, j.length()-1);
      String[]o={j};
      saveStrings("output.txt", o);
    }
    if (saveDebugToFile) {
      String[]o2={log.join("")};
      saveStrings("log.txt", o2);
    }
  } catch (Exception e) {
      String[]o2={log.join("")};
      saveStrings("log.txt", o2);
    e.printStackTrace();
  }
  System.exit(0);
}
void draw() {
  
}
//small fix so this would work properly on APDE
/*int afix;
void draw() {
  afix++;
  if (afix>10) exit();
}*/


/*RMP5*/
BigDecimal B (float a) {
  try {
    return new BigDecimal(a);
  }
  catch (Exception e) { 
    currentPrinter.eprintln("error on B-float: \""+a+"\" - "+e.toString());
    return B(0);
  }
}
BigDecimal B (double a) {
  try {
    return new BigDecimal(a);
  }
  catch (Exception e) { 
    currentPrinter.eprintln("error on B-double: \""+a+"\" - "+e.toString());
    return B(0);
  }
}
//*/
BigDecimal B (String a) {
  try {
    return new BigDecimal(a);
  }
  catch (Exception e) { 
    currentPrinter.eprintln("*-*B-string error from \""+a+"\": "+e.toString()+"*-*");
    return B(0);
  }
}
boolean truthy (Poppable p) {
  if (p.type==BIGDECIMAL) 
    return !p.bd.equals(B(0));
  else if (p.type==STRING)
    return p.s!="";
  else if (p.type==NONE)
    return false;
  return p.a.size()!=0;
}
boolean falsy (Poppable p) {
  if (p.type==BIGDECIMAL) 
    return p.bd.equals(B(0));
  else if (p.type==STRING)
    return p.s.equals("");
  else if (p.type==NONE)
    return true;
  return p.a.size()==0;
}



String up0 (int num, int a) {
  String res = str(num);
  while (res.length()<a) {
    res = "0"+res;
  }
  return res;
}
Poppable toArray (Poppable p) {
  if (p.type==STRING || p.type==BIGDECIMAL) {
    return SA2PA(p.s.split("\n"));
  }
  return p;
}
Poppable SA2PA (String[] arr) {//string array to poppable array
  ArrayList<Poppable> o = new ArrayList<Poppable>();
  for (String s : arr)
    o.add(tp(s));
  return new Poppable(o);
}
String[] PA2SA (Poppable arr) {//poppable array to string array
  String[] sa = new String[arr.a.size()];
  int i = 0;
  for (Poppable c : arr.a) {
    sa[i] = c.toString();
    i++;
  }
  return sa;
}
Poppable array2D (String[][] arr) {
  ArrayList<Poppable> o = new ArrayList<Poppable>();
  for (String[] a1 : arr) {
    o.add(tp(new ArrayList<Poppable>()));
    for (String a2 : a1) {
      o.get(o.size()-1).a.add(tp(a2));
    }
  }
  return new Poppable(o);
}
/*string[] stringArr(JSONArray j) {
  String[] s = new String[j.size()];
  for (int i = 0; i < s.length; i++) {
    s[i] = j.getString(i);
  }
  return s;
}*/
ArrayList<Poppable> ea() {
  return new ArrayList<Poppable>();
}
Poppable tp(String s) {//to poppable
  return new Poppable(s);
}
Poppable tp(BigDecimal bd) {
  return new Poppable(bd);
}
Poppable tp(ArrayList<Poppable> bd) {
  return new Poppable(bd);
}

BigDecimal roundForDisplay(BigDecimal bd) {
  return bd.setScale(precision-5, BigDecimal.ROUND_HALF_UP);
}
BigDecimal StrToBD(String s, BigDecimal fail) {
  try {
    return new BigDecimal(s);
  } catch (Exception e) {
    return fail;
  }
}

/*RMP5*/
String readFile(String path, Charset encoding) {
  try {
    byte[] encoded = Files.readAllBytes(Paths.get(path));
    return new String(encoded, encoding);
  } catch (IOException e) {
    e.printStackTrace();
    return null;
  }
}
//*/
ArrayList<Poppable> chop (Poppable p) {
  ArrayList<Poppable> o = new ArrayList<Poppable>();
  for (int i = 0; i < p.s.length(); i++)
    o.add(new Poppable(p.s.charAt(i)+""));
  return o;
}
int getLongestXFrom (Poppable inp) {
  int hlen = 0;
  for (Poppable p : inp.a) {
    if (p.type == STRING) if (p.s.length() > hlen) hlen = p.s.length();
    if (p.type == ARRAY) if (p.a.size() > hlen) hlen = p.a.size();
  }
  return hlen;
}
ArrayList<Poppable> item0 (Poppable p) {
  ArrayList<Poppable> out = new ArrayList<Poppable>();
  out.add(p);
  return out;
}
ArrayList<Poppable> to2DMLSA (ArrayList<Poppable> inp45) {//to 2D multiline string array
  if (inp45.get(0).type==ARRAY) return inp45;
  else {
    ArrayList<Poppable> out = new ArrayList<Poppable>();
    for (Poppable p : inp45) {
      out.add(tp(item0(p)));
    }
    return out;
  }
}
ArrayList<Poppable> to1DMLSA (ArrayList<Poppable> in132) {//to 1D multiline string array
  if (in132.size() > 0 && in132.get(0).type==ARRAY) {
    ArrayList<Poppable> out = new ArrayList<Poppable>();
    for (Poppable p : in132) {
      String current = "";
      for (Poppable p2 : p.a) {
        current+= p2.s;
      }
      out.add(tp(current));
    }
    return out;
  } else return in132;
}
String[] emptySA(int xs, int ys) {
  String[] out = new String[ys];
  for (int y = 0; y < ys; y++) {
    out[y] = "";
    for (int x = 0; x < xs; x++) {
      out[y]+= " ";
    }
  }
  return out;
}
String[] write(String[] a, int xp, int yp, Poppable b) {
  if ((b.type==ARRAY? b.a.size() : b.s.length()) > 0) {
    a = SAspacesquared(a);
    if (b.type != ARRAY) {
      b = toArray(b);
    }
    b.a = spacesquared(to1DMLSA(b.a));
    if (xp < 1) {
      String ps = "";
      for (int i = 0; i < 1-xp; i++) {
        ps+= " ";
      }
      for (int i = 0; i < a.length; i++) {
        a[i] = ps+a[i];
      }
      xp=1;
    }
    if (yp < 1) {
      //console.log(a.length);
      if (a.length > 0) {
        String[] na = new String[a.length+(1-yp)];
        for (int i = 0; i < na.length; i++) {
          if (i < 1-yp) na[i] = "";
          else na[i] = a[i-(1-yp)];
        }
        a = na;
      }
      yp=1;
    }
    a = SAspacesquared(a);
    if (a.length==0) a = new String[]{""};
    //println(getLongestXFrom(b)+"#"+b.a.get(0).s+"#"+xp+"#"+a[0].length());
    if (getLongestXFrom(b)+xp-1 > a[0].length()) {
      int gotoLen = (getLongestXFrom(b)+xp)-a[0].length()-1;
      for (int i = 0; i < gotoLen; i++)
        a[0]+=" ";
      a = SAspacesquared(a);
    }
    if (b.a.size()+yp > a.length+1) {
      String[] na = new String[(b.a.size()+yp)-1];
      for (int i = 0; i < na.length; i++) {
        na[i] = i < a.length? a[i] : "";
      }
      a = na;
      a = SAspacesquared(a);
    }
    for (int x = 0; x < getLongestXFrom(b); x++) {
      for (int y = 0; y < b.a.size(); y++) {
        a[y+yp-1] = a[y+yp-1].substring(0, x+xp-1) + b.a.get(y).s.charAt(x) + a[y+yp-1].substring(x+xp);
      }
    }
  }
  return a;
}

String[] writeExc (String[] a, int xp, int yp, Poppable b, char excludable) {
  if ((b.type==ARRAY? b.a.size() : b.s.length()) > 0) {
    a = SAspacesquared(a);
    if (b.type != ARRAY) {
      b = toArray(b);
    }
    b.a = spacesquared(to1DMLSA(b.a));
    if (xp < 1) {
      String ps = "";
      for (int i = 0; i < 1-xp; i++) {
        ps+= " ";
      }
      for (int i = 0; i < a.length; i++) {
        a[i] = ps+a[i];
      }
      xp=1;
    }
    if (yp < 1) {
      //console.log(a.length);
      if (a.length > 0) {
        String[] na = new String[a.length+(1-yp)];
        for (int i = 0; i < na.length; i++) {
          if (i < 1-yp) na[i] = "";
          else na[i] = a[i-(1-yp)];
        }
        a = na;
      }
      yp=1;
    }
    a = SAspacesquared(a);
    if (a.length==0) a = new String[]{""};
    //println(getLongestXFrom(b)+"#"+b.a.get(0).s+"#"+xp+"#"+a[0].length());
    if (getLongestXFrom(b)+xp-1 > a[0].length()) {
      int gotoLen = (getLongestXFrom(b)+xp)-a[0].length()-1;
      for (int i = 0; i < gotoLen; i++)
        a[0]+=" ";
      a = SAspacesquared(a);
    }
    if (b.a.size()+yp > a.length+1) {
      String[] na = new String[(b.a.size()+yp)-1];
      for (int i = 0; i < na.length; i++) {
        na[i] = i < a.length? a[i] : "";
      }
      a = na;
      a = SAspacesquared(a);
    }
    for (int x = 0; x < getLongestXFrom(b); x++) {
      for (int y = 0; y < b.a.size(); y++) {
        if (b.a.get(y).s.charAt(x) != excludable)
          a[y+yp-1] = a[y+yp-1].substring(0, x+xp-1) + b.a.get(y).s.charAt(x) + a[y+yp-1].substring(x+xp);
      }
    }
  }
  return a;
}

void clearOutput() { 
  //I don't know how to clear stdout, nor does the internet give anything that works
  /*ADDP5
  soglOS = "";
  //*/
  savedOut = new StringList(); 
}
int divCeil (int a, int b) {
  /*ADDP5
  return ceil(a/b);
  //*/
  return (a+b-1)/b;
}