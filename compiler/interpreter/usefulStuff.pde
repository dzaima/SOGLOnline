char iTC (int c) {
  /*ADDP5
    return String.fromCharCode(c);
  //*/
  return (char)c;
}
String iTS (int c) {
  /*ADDP5
    return String.fromCharCode(c);
  //*/
  return ""+(char)c;
}
int charAtI(String s, int index) {
  /*ADDP5
    return s.charCodeAt(index);
  //*/
  return s.charAt(index);
}
Poppable spaceup (Poppable p, int l) {
  if (p.type == ARRAY) {
    while (p.a.size()<l)
      p.a.add(tp(" "));
  } else {
    while (p.s.length()<l)
      p.s+=" ";
    p.type = STRING;
  }
  return p;
}
String spaceupStr (String s, int l) {
  while (s.length()<l)
    s+=" ";
  return s;
}
String repeat (String tor, BigDecimal count) {
  String res = "";
  for (int i = 0; i < count.intValue(); i++) {
    res += tor;
  }
  return res;
}
String repeat (String tor, int count) {
  String res = "";
  for (int i = 0; i < count; i++) {
    res += tor;
  }
  return res;
}
ArrayList<Poppable> spacesquared(ArrayList<Poppable> arr) {
  ArrayList<Poppable> res = new ArrayList<Poppable>();
  int l = 0;
  for (Poppable b : arr) {
    if (b.type==ARRAY) {
      if (b.a.size() > l)
        l = b.a.size();
    } else {
      if (b.s.length() > l)
        l = b.s.length();
    }
    
  }
  for (Poppable b : arr) {
    res.add(spaceup(b, l));
  }
  return res;
}
String[] SAspacesquared(String[] arr) {
  String[] res = new String[arr.length];
  int l = 0;
  for (String b : arr) {
    if (b.length() > l)
      l = b.length();
  }
  int i = 0;
  for (String b : arr) {
    res[i] = spaceupStr(b, l);
    i++;
  }
  return res;
}
Poppable swapChars (Poppable p, char a, char b) {
  if (p.type==STRING) {
    String o = "";
    for (char s : p.s.toCharArray()) {
      if (s==a) o+= b; else
      if (s==b) o+= a; else
      o+=s;
    }
    return tp(o);
  }
  if (p.type==BIGDECIMAL) return p;
  ArrayList<Poppable> out = ea();
  for (Poppable c : p.a) {
    out.add(swapChars(c, a, b));
  }
  return tp(out);
}

Poppable replaceChars (Poppable p, char a, char b) {
  if (p.type==STRING) {
    return tp(p.s.replace(a, b));
  }
  if (p.type==BIGDECIMAL) return p;
  //else if array
  ArrayList<Poppable> out = ea();
  for (Poppable c : p.a) {
    out.add(replaceChars(c, a, b));
  }
  return tp(out);
}

BigDecimal divide (BigDecimal a, BigDecimal b) {
  try {
    return a.divide(b);
  } catch (Exception e) {
    return a.divide(b, precision, RoundingMode.HALF_UP);
  }
}

Poppable horizMirror (Poppable inp) {
  inp = swapChars(inp, '\\', '/');
  inp = swapChars(inp, '<', '>');
  inp = swapChars(inp, '(', ')');
  inp = swapChars(inp, '{', '}');
  inp = swapChars(inp, '[', ']');
  inp = swapChars(inp, '┌', '┐');
  inp = swapChars(inp, '└', '┘');
  inp = swapChars(inp, '├', '┤');
  inp = swapChars(inp, '╒', '╕');
  inp = swapChars(inp, '╓', '╖');
  inp = swapChars(inp, '╔', '╗');
  inp = swapChars(inp, '╙', '╜');
  inp = swapChars(inp, '╚', '╝');
  inp = swapChars(inp, '╘', '╛');
  inp = swapChars(inp, '╞', '╡');
  inp = swapChars(inp, '╟', '╢');
  inp = swapChars(inp, '╠', '╣');
  return inp;
}
Poppable vertMirror (Poppable inp) {
  inp = swapChars(inp, '\\', '/');
  inp = replaceChars(inp, 'V', 'v');
  inp = swapChars(inp, '^', 'v');
  inp = swapChars(inp, '\'', '.');
  inp = swapChars(inp, '`', ',');
  inp = swapChars(inp, '└', '┌');
  inp = swapChars(inp, '┘', '┐');
  inp = swapChars(inp, '┴', '┬');
  inp = swapChars(inp, '╘', '╒');
  inp = swapChars(inp, '╙', '╓');
  inp = swapChars(inp, '╚', '╔');
  inp = swapChars(inp, '╝', '╗');
  inp = swapChars(inp, '╛', '╕');
  inp = swapChars(inp, '╜', '╖');
  inp = swapChars(inp, '╩', '╦');
  inp = swapChars(inp, '╨', '╥');
  inp = swapChars(inp, '╧', '╤');
  if (inp.type==STRING) {
    String[] ss = split(inp.s, '\n');
    ss = SAspacesquared(ss);
    for (int i = 0; i < ss.length; i++) {
      for (int j = 0; j < ss[i].length(); j++) {
        if (ss[i].charAt(j)=='_') {
          if (i > 0 && (".,'` ".indexOf(ss[i-1].charAt(j))>=0))
            ss[i-1] = ss[i-1].substring(0,j)+'_'+ss[i-1].substring(j+1);
          ss[i] = ss[i].substring(0,j)+' '+ss[i].substring(j+1);
        }
      }
    }
  }
  if (inp.type==ARRAY) {
    ArrayList<Poppable> out = inp.a;
    out = spacesquared(out);
    for (int i = 0; i < out.size(); i++) {
      for (int j = 0; j < out.get(i).s.length(); j++) {
        if (out.get(i).s.charAt(j)=='_') {
          if (i > 0 && (".,'` ".indexOf(out.get(i-1).s.charAt(j))>=0))
            out.set(i-1, tp(out.get(i-1).s.substring(0,j)+'_'+out.get(i-1).s.substring(j+1)));
          out.set(i, tp(out.get(i).s.substring(0,j)+' '+out.get(i).s.substring(j+1)));
        }
      }
    }
    inp.a = out;
  }
  return inp;
}
Poppable horizPalen (Poppable inp, int center, boolean swapChars, boolean extraSpace) {
  if (inp.type==STRING) {
    return horizPalen(SA2PA(inp.s.split("\n")), center, swapChars, extraSpace);
  }
  if (inp.type==BIGDECIMAL) return tp(B((inp.s+(new StringBuilder(inp.s).reverse().substring(center%2))).replaceAll("(\\..+)\\.", "$1")));
  if (extraSpace && inp.a.size()>0 && inp.a.get(0).type!=ARRAY) inp.a = spacesquared(inp.a);
  ArrayList<Poppable> out = ea();
  for (Poppable c : inp.a) {
    out.add(horizPalenNS(c, center, swapChars, extraSpace));
  }
  return tp(out);
}
Poppable horizPalenNS (Poppable inp, int center, boolean swapChars, boolean extraSpace) {//non-string version
  if (inp.type==STRING) {
    return tp(inp.s+(new StringBuilder(swapChars? horizMirror(inp).s : inp.s).reverse().substring(center%2)));
  }
  if (inp.type==BIGDECIMAL) return tp(inp.s+(new StringBuilder(inp.s).reverse().substring(center%2)));
  if (extraSpace && inp.a.size()>0 && inp.a.get(0).type!=ARRAY) inp.a = spacesquared(inp.a);
  ArrayList<Poppable> out = ea();
  for (Poppable c : inp.a) {
    out.add(horizPalenNS(c, center, swapChars, extraSpace));
  }
  return tp(out);
}
Poppable vertPalen (Poppable inp, int center, boolean swapChars, boolean extraSpace) {//vertically palendromize non-string
  if (inp.type==STRING) {
    return vertPalen(SA2PA(inp.s.split("\n")), center, swapChars, extraSpace);
  }
  if (inp.type==BIGDECIMAL) return inp;
  if (extraSpace && inp.a.size()>0 && inp.a.get(0).type!=ARRAY) inp.a = spacesquared(inp.a);
  ArrayList<Poppable> out = ea();
  int ssize = inp.a.size();
  for (int i = ssize-1-center%2; i >= 0; i--) {
    out.add(inp.a.get(i));
  }
  if (swapChars) out = vertMirror(tp(out)).a;
  for (int i = 0; i < ssize; i++) {
    if (center == 1 && i==ssize-1 && inp.a.get(i).type == STRING) {
      out.add(i, tp(inp.a.get(i).s.replaceAll("[,.`']", ":").replaceAll("[\\\\/]", "X")));
    } else
      out.add(i, inp.a.get(i));
  }
  return tp(out);
}
Poppable quadPalen (Poppable inp, int centerX, int centerY, boolean swapCharsX, boolean swapCharsY, boolean extraSpace) {
  //if (extraSpace && inp.a.size()>0 && inp.a.get(0).type!=ARRAY) inp.a = spacesquared(inp.a);
  inp = vertPalen(inp, centerY, swapCharsY, extraSpace);
  inp = horizPalen(inp, centerX, swapCharsX, extraSpace);
  return inp;
}
Poppable regexReplace (Poppable inp, String what, String toWhat) {
  if (inp.type==STRING||inp.type==BIGDECIMAL) return tp(inp.s.replaceAll(what, toWhat));
  ArrayList<Poppable> out = ea();
  for (Poppable c : inp.a) {
    out.add(regexReplace(c, what, toWhat));
  }
  return tp(out);
}
Poppable[] badReorder (Poppable a, Poppable b, Poppable c, Poppable d) {
  //worst way to make a & b numbers and c & d not numbers without losing order :p
  Poppable t;
  if (b.type==BIGDECIMAL && c.type!=BIGDECIMAL) {
    t = b;
    b = c;
    c = t;
  }
  if (c.type==BIGDECIMAL && d.type!=BIGDECIMAL) {
    t = d;
    d = c;
    c = t;
  }
  if (a.type==BIGDECIMAL && b.type!=BIGDECIMAL) {
    t = b;
    b = a;
    a = t;
  }
  if (b.type==BIGDECIMAL && c.type!=BIGDECIMAL) {
    t = b;
    b = c;
    c = t;
  }
  return new Poppable[]{a, b, c, d};
}
Poppable reverseStrings (Poppable inp) {
  if (inp.type==STRING) return tp(new StringBuilder(inp.s).reverse().toString());
  if (inp.type==BIGDECIMAL) return tp(new StringBuilder(inp.bd.toString()).reverse().toString());
  ArrayList<Poppable> out = ea();
  for (Poppable c : inp.a) {
    out.add(reverseStrings(c));
  }
  return tp(out);
}
public class Vo {
  public Poppable e(Poppable inp){return null;}
  public Vo s(String a, String b){return this;}
  public Vo s(String a){return this;}
}
Poppable vectorize (Poppable inp, Vo rn) {
  Poppable ce = rn.e(inp);
  if (ce != null) return ce;
  ArrayList<Poppable> out = ea();
  for (Poppable c : inp.a) {
    out.add(vectorize(c, rn));
  }
  return tp(out);
}
Poppable sort(Poppable ts) {
  if (ts.type==BIGDECIMAL) {
    return tp("");
  } else if (ts.type==STRING) {
    char[] sorted = ts.s.toCharArray();
    Arrays.sort(sorted);
    return tp(new String(sorted));
  } else {
    ArrayList<Poppable> current = ea();
    ArrayList<Poppable> out = ea();
    for (Poppable c : ts.a) {
      if (current.size() == 0 || current.get(current.size()-1).type == c.type) {
        if (current.size() > 0 && current.get(current.size()-1).type == ARRAY) {
          out.add(sort(c));
        } else 
          current.add(c);
      } else {
        Collections.sort(current, new Comparator<Poppable>() {
          public int compare(Poppable o1, Poppable o2) {
              return o1.compareTo(o2);
          }
        });
        for (Poppable c2 : current) {
          out.add(c2);
        }
        current = ea();
        current.add(c);
      }
    }
    if (current.size() > 0) {
      Collections.sort(current, new Comparator<Poppable>() {
        public int compare(Poppable o1, Poppable o2) {
            return o1.compareTo(o2);
        }
      });
      for (Poppable c2 : current) {
        out.add(c2);
      }
    }
    return tp(out);
  }
}

Poppable to2DList (Poppable inp) {
  if (inp.type != ARRAY) return SA2PA(split(inp.s, '\n'));
  ArrayList<Poppable> out = ea();
  for (Poppable c : inp.a) {
    out.add(tp(joinTogether(c)));
  }
  return tp(out);
}
ArrayList<Poppable> toArt(Poppable inp) {
  return spacesquared(to2DList(inp).a);
}
String[] SArt (Poppable inp) {
  return PA2SA(tp(toArt(inp)));
}
Poppable flattenPA (Poppable inp) {
  if (inp.type != ARRAY) return inp;
  ArrayList<Poppable> out = ea();
  for (Poppable c : inp.a) {
    if (c.type==ARRAY) {
      for (Poppable c2 : flattenPA(c).a) out.add(c2);
    } else
      out.add(c);
  }
  return tp(out);
}
String reverse (String s) {
  String res = "";
  for (int i =s.length()-1; i > -1; i--) {
    res += s.charAt(i);
  }
  return res; 
}
String artToString (Poppable arr) {
  arr = to2DList(arr);
  String o = "";
  for (Poppable c : arr.a) {
    if (c.type==ARRAY)
      o+= joinTogether(c);
    else
      o+=c.s;
    if (c != arr.a.get(arr.a.size()-1)) o+= "\n";
  }
  return o;
}

String joinTogether (Poppable inp) {
  if (inp.type!=ARRAY) return inp.s;
  String cl = "";
  for (Poppable c : inp.a) {
    cl+= joinTogether(c);
  }
  return cl;
}
BigDecimal gcd(BigDecimal x, BigDecimal y) {
  if (x.equals(BigDecimal.ZERO)) return y;
  if (y.equals(BigDecimal.ZERO)) return x;
  return gcd(y, x.remainder(y));
}

/* template for vectorizing functions
Poppable vf (Poppable inp) {
  if (inp.type==STRING) 
  if (inp.type==BIGDECIMAL) 
  ArrayList<Poppable> out = ea();
  for (Poppable c : inp.a) {
    out.add(vf(c));
  }
  return tp(out);
}
*/
Executable EX() {
  return currentPrinter;
}