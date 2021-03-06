import java.util.Comparator;
import java.util.Collections;
import java.math.BigInteger;
String compressChars = "⁰¹²³⁴⁵⁶⁷⁸\t⁹±∑«»æÆø‽§°¦‚‛⁄¡¤№℮½ !#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~←↑↓≠≤≥∞√═║─│≡∙∫○׀′¬⁽⁾⅟‰÷╤╥ƨƧαΒβΓγΔδΕεΖζΗηΘθΙιΚκΛλΜμΝνΞξΟοΠπΡρΣσΤτΥυΦφΧχΨψΩωāčēģīķļņōŗšūž¼¾⅓⅔⅛⅜⅝⅞↔↕∆≈┌┐└┘╬┼╔╗╚╝░▒▓█▲►▼◄■□¶‼⌠⌡→";
String compressableChars = "ZQJKVBPYGFWMUCLDRHSNIATEXOzqjkvbpygfwmucldrhsniatexo~!$%&=?@^()<>[]{};:9876543210#*\"'`.,+\\/_|-\nŗ ";
int[] presetNums = {0,1,2,3,4,5,6,7,8,9,10,11,12,14,16,18,20,25,36,50,64,75,99,100,101,128,196,200,255,256,257};
String[] presets = {"0","1","2","3","4","5","6","7","8","9","L","LI","6«","7«","8«","9«","L«","M¼","6²","M»","N¼","M¾","MH","M","MI","N»","N¾","M«","NH","N","NI"};
char[] alphabet = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
String[] dict;
String compressNumber(String number) {
  String out = compressNum(BI(number));
  currentPrinter.eprint("\ncompressed: "+out);
  currentPrinter.eprint("\ndecompressed: "+ decompressNum(out));
  currentPrinter.eprint("\nlength:"+ out.length());
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
  currentPrinter.eprintln("\n||----------------------------------------------------------------------||");
  currentPrinter.eprintln(toNum(bits)+"");
  currentPrinter.eprintln(toNum(bits).toString().length()+"");
  String comp = toCmd(bits);
  currentPrinter.eprintln("total: \""+decompress(comp)+"\"");
  currentPrinter.eprintln("||----------------------------------------------------------------------||");
  currentPrinter.eprintln(comp.length() + " bytes, original was "+raw.length()+" bytes. "+ round(comp.length()*1000f/raw.length())/10 + "% of original length");
  currentPrinter.eprintln("More precisely, " + Math.log(toNum(bits).doubleValue())/Math.log(compressChars.length()) + " bytes");//.multiply(new BigDecimal(2/log(256))));
  return "\""+comp+"‘";
}
/*RMP5*/
BigInteger fromBase (int base, byte[] num) {
  BigInteger o = BI(0);
  for (byte b : num) {
    o = o.multiply(BI(base)).add(BI(b&0xFF));
  }
  return o;
}
BigInteger fromBase (int base, String num) {
  BigInteger o = BI(0);
  for (int i = 0; i < num.length(); i++) {
    o = o.multiply(BI(base)).add(BI(num.charAt(i)+""));
  }
  return o;
}
//*/
//P5JSfromPase
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
byte read (int base) {
  if (logDecompressInfo) System.err.print("\nREADING " + base);
  byte o;
  BigInteger[] temp = decompressable.divideAndRemainder(BI(base));
  o = temp[1].byteValue();
  if (logDecompressInfo) System.err.println(", GOT " + o);
  decompressable = temp[0];
  return o;
}
//void addToDecomp (BigInteger num, BigInteger base) {
//  decompressable = decompressable.multiply(base).add(num);
//}
int readInt (int base) {
  int o;
  BigInteger[] temp = decompressable.divideAndRemainder(BI(base));
  o = temp[1].intValue();
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
byte[] toByteArr (String s) {
  byte[] o = new byte[s.length()];
  for (int i=0; i<s.length(); i++)o[i]=(byte)int(s.charAt(i)+"");
  return o;
}
byte[] groupToArray (String s, int group) {
  byte[] o = new byte[s.length()/group];
  for (int i=0; i<s.length(); i+=group)o[i/group]=(byte)int(s.substring(i, i+group));
  return o;
}
/*RMP5*/
BigInteger BI (String a) {
  try {
    return new BigInteger(a);
  }
  catch (Exception e) { 
    //oprintln(e);
    return BI("0");
  }
}
BigInteger BI (long a) {
  try {
    return BigInteger.valueOf(a);
  }
  catch (Exception e) { 
    //oprintln(e);
    return BI("0");
  }
}
BigInteger BI (byte a) {
  try {
    return BigInteger.valueOf(a);
  }
  catch (Exception e) { 
    //oprintln(e);
    return BI("0");
  }
}
//*/
String toString(byte[] b) {
  String o = "";
  for (byte c : b) o+=c;
  return o;
}
String pre (String s, int amo, String p) {
  while (s.length()<amo) s=p+s;
  return s;
}
String post (String s, int amo, String p) {
  while (s.length()<amo) s+=p;
  return s;
}
String BAtoString(byte[] b) {
  String o = "";
  for (byte c : b) o+=c;
  return o;
}
BigDecimal[] toBase (BigDecimal base, BigDecimal b) {
  ArrayList<BigDecimal> o = new ArrayList<BigDecimal>();
  while (!b.equals(BigDecimal.ZERO)) {
    BigDecimal[] t = b.divideAndRemainder(base);
    o.add(t[1]);
    b = t[0];
    //println(b);
  }
  BigDecimal[] O = new BigDecimal[o.size()];
  for (int i = 0; i<o.size(); i++) {
    O[i]=o.get(o.size()-i-1);
  }
  return O;
}