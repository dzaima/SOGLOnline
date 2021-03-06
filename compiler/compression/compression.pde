import java.math.BigDecimal;
import java.util.Comparator;
import java.util.Collections;
import java.math.BigInteger;
boolean logDecompressInfo = true;
String compressChars = "⁰¹²³⁴⁵⁶⁷⁸\t⁹±∑«»æÆø‽§°¦‚‛⁄¡¤№℮½ !#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~←↑↓≠≤≥∞√═║─│≡∙∫○׀′¬⁽⁾⅟‰÷╤╥ƨƧαΒβΓγΔδΕεΖζΗηΘθΙιΚκΛλΜμΝνΞξΟοΠπΡρΣσΤτΥυΦφΧχΨψΩωāčēģīķļņōŗšūž¼¾⅓⅔⅛⅜⅝⅞↔↕∆≈┌┐└┘╬┼╔╗╚╝░▒▓█▲►▼◄■□¶‼⌠⌡→";
String compressableChars = "ZQJKVBPYGFWMUCLDRHSNIATEXOzqjkvbpygfwmucldrhsniatexo~!$%&=?@^()<>[]{};:9876543210#*\"'`.,+\\/_|-\nŗ ";
int[] presetNums = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 16, 18, 20, 25, 36, 50, 64, 75, 99, 100, 101, 128, 196, 200, 255, 256, 257};
String[] presets = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "L", "LI", "6«", "7«", "8«", "9«", "L«", "M¼", "6²", "M»", "N¼", "M¾", "MH", "M", "MI", "N»", "N¾", "M«", "NH", "N", "NI"};
char[] alphabet = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};
String[] dict;
/*ADDP5
void println (Object... os) {
  print(os);
  logsv+= "\n";
}
void print (Object... os) {
  int i = 0;
  String res = "";
  for (Object o : os) {
    if (i==0) res+= " ";
    res+= os[i];
    i++;
  }
  logsv+= res;
  //console.log(res);
}
class StringList {
  ArrayList<String> sl = new ArrayList<String>();
  void add(String s) {
    sl.add(s);
  }
  void append(String s) {
    sl.add(s);
  }
  String get(int pos) {
    return sl.get(pos);
  }
  String join(String sep) {
    String res = "";
    for (String s : sl) {
      res+= s;
      if (s != sl.get(sl.size()-1))
        res+= sep;
    }
  }
  int size() {
    return sl.size();
  }
}
/*/
void setup() {
  compressString(new String[]{"aaaaaaaaaaaaaaaaaabcdefghijklmnopqrstuvwxyaaaaaaaaaaaaaaaaaabcdefghijklmnopqrstuvwxyaaaaaaaaaaaaaaaaaabcdefghijklmnopqrstuvwxyaaaaaaaaaaaaaaaaaabcdefghijklmnopqrstuvwxy"});
}
//*/
String[] getDict(){return dict;}
String loadString(String name) {
  String out = null;
//insert
  return out;
}
/*ADDP5
String[] loadStrings(String name) {
  return split(loadString(name), "\n");
}
//*/
String compressNumber(String number) {
  String out = compressNum(BI(number));
  println("compressed: "+out);
  println("decompressed: "+ decompressNum(out));
  println("length:"+ out.length());
  return out;
}
String compressString(String[] arr) {
  ArrayList<int[]> bits = new ArrayList<int[]>();
  String raw = "";
  for (String s : arr) {
    for (int[] i : compressSmart(s)) {
      int[] temp = new int[2];
      temp[0] = i[0];
      temp[1] = i[1];
      bits.add(temp);
    }
    raw+=s;
  }
  //for (Object a : bits.toArray()) println(((int[])a)[0],((int[])a)[1]);
  println("\n||----------------------------------------------------------------------||");
  println(toNum(bits));
  println(toNum(bits).toString().length());
  String comp = toCmd(bits);
  println("total: \""+decompress(comp)+"\"");
  println("||----------------------------------------------------------------------||");
  println(comp.length() + " bytes, original was "+raw.length()+" bytes. "+ round(comp.length()*1000f/raw.length())/10 + "% of original length");
  println("More precisely, " + Math.log(toNum(bits).doubleValue())/Math.log(compressChars.length()) + " bytes");//.multiply(new BigDecimal(2/log(256))));
  return "\""+comp+"‘";
}
BigInteger fromBase (int base, byte[] num) {
  BigInteger o = BI(0);
  for (byte b : num) {
    o = o.multiply(BI(base)).add(BI(b&0xFF));
  }
  return o;
}
BigInteger SfromBase (int base, String num) {
  BigInteger o = BI(0);
  for (int i = 0; i < num.length(); i++) {
    o = o.multiply(BI(base)).add(BI(num.charAt(i)+""));
  }
  return o;
}
BigInteger decompressable;
int[] readArr (int base, int count) {
  int[] o = new int[count];
  for (int i = 0; i < count; i++) {
    BigInteger[] temp = decompressable.divideAndRemainder(BI(base));
    o[i] = temp[1].intValue();
    decompressable = temp[0];
  }
  return o;
}
int read (int base) {
  //if (logDecompressInfo) print("\nREADING " + base);
  BigInteger orig = decompressable;
  int o;
  BigInteger[] temp = decompressable.divideAndRemainder(BI(base));
  o = temp[1].intValue();
  //if (logDecompressInfo) println(", GOT " + o + " FROM "+orig);
  decompressable = temp[0];
  return o;
}
String getb (int base, int count) {
  String o = "";
  for (int i = 0; i < count; i++) {
    BigInteger[] temp = decompressable.divideAndRemainder(BI(base));
    o+= temp[1].intValue();
    decompressable = temp[0];
  }
  return o;
}
byte[] toBase (int base, BigInteger b) {
  ArrayList<Byte> o = new ArrayList<Byte>();
  while (!b.equals(BigInteger.ZERO)) {
    BigInteger[] t = b.divideAndRemainder(BI(base));
    o.add(t[1].byteValue());
    b = t[0];
  }
  byte[] O = new byte[o.size()];
  for (int i = 0; i<o.size(); i++) {
    O[i]=o.get(o.size()-i-1);
  }
  return O;
}
byte[] toArray (String s) {
  byte[] o = new byte[s.length()];
  for (int i=0; i<s.length(); i++)o[i]=(byte)int(s.charAt(i)+"");
  return o;
}
byte[] toArrayG (String s, int group) {
  byte[] o = new byte[s.length()/group];
  for (int i=0; i<s.length(); i+=group)o[i/group]=(byte)int(s.substring(i, i+group));
  return o;
}
BigInteger BI (Object a) {
  return new BigInteger(a.toString());
}
String pre (String s, int amo, String p) {
  while (s.length()<amo) s=p+s;
  return s;
}
BigDecimal[] toBaseBD (BigDecimal base, BigDecimal b) {
  ArrayList<BigDecimal> o = new ArrayList<BigDecimal>();
  while (!b.equals(BigDecimal.ZERO)) {
    BigDecimal[] t = b.divideAndRemainder(base);
    o.add(t[1]);
    b = t[0];
  }
  BigDecimal[] O = new BigDecimal[o.size()];
  for (int i = 0; i<o.size(); i++) {
    O[i]=o.get(o.size()-i-1);
  }
  return O;
}