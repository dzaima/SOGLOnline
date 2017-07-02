class Poppable {
  BigDecimal bd;//these should really be final
  String s = "";
  ArrayList<Poppable> a = new ArrayList<Poppable>();
  int type = 0;
  boolean inp = false;
  Poppable (String ii) {
    bd = BigDecimal.ZERO;
    type = STRING;
    s = ii;
  }
  Poppable (BigDecimal ii) {
    type = BIGDECIMAL;
    bd = ii;
    s = ii.toString();
  }
  Poppable (int ii) {
    bd = BigDecimal.ZERO;
    type = ii;
    //bd = B(ii);
  }
  Poppable (ArrayList<Poppable> ii) {
    bd = BigDecimal.ZERO;
    type = ARRAY;
    a = ii;
  }
  Poppable (Poppable tc) {
    type = tc.type;
    s = tc.s;
    a = tc.a;
    bd = tc.bd;
    inp = tc.inp;
  }
  Poppable (Poppable o, int varsave, Executable ex) {
    type = o.type;
    if (o.type==INS) {
      type = STRING;
      s = ex.sI().s;
      bd = StrToBD(s, ZERO);
      inp = true;
      ex.setvar(varsave, this);
    } else if (o.type==INN) {
      type = BIGDECIMAL;
      bd = ex.nI().bd;
      s = bd.toString();
      inp = true;
      ex.setvar(varsave, this);
    } else if (o.type==BIGDECIMAL) {
      bd = o.bd;
      s = bd.toString();
    } else if (o.type==ARRAY) {
      a = o.copy().a;
    } else {
      bd = ZERO;
    }
    if (o.type==STRING) {
      s = o.s;
    }
  }
  Poppable (BigDecimal ii, boolean imp) {
    type = BIGDECIMAL;
    bd = ii;
    s = ii.toString();
    inp = imp;
  }
  Poppable (String ii, boolean imp) {
    bd = BigDecimal.ZERO;
    type = STRING;
    s = ii;
    inp = imp;
  }
  Poppable (ArrayList<Poppable> ii, boolean imp) {
    bd = BigDecimal.ZERO;
    type = ARRAY;
    a = ii;
    inp = imp;
  }
  void print (boolean multiline) {
    if (type==STRING) currentPrinter.oprint(s);
    if (type==BIGDECIMAL) currentPrinter.oprint(bd);
    if (type==ARRAY) printArr(multiline);
  }
  void println (boolean multiline) {
    if (type==STRING) currentPrinter.oprintln(s);
    if (type==BIGDECIMAL) currentPrinter.oprintln(bd);
    if (type==ARRAY) {
      printArr(multiline);
      currentPrinter.oprintln("");
    }
  }
  void printNA () {
    if (type==STRING) currentPrinter.oprintln(s);
    if (type==BIGDECIMAL) currentPrinter.oprintln(bd);
    if (type==ARRAY) {
      currentPrinter.eprintln ("[\n");
      for (int i = 0; i < a.size()-1; i++) {
        a.get(i).printNA();
        currentPrinter.eprintln(",");
      }
      currentPrinter.eprintln("]");
    }
  }
  void printArr(boolean multiline) {
    for (int i = 0; i < a.size()-1; i++) {
      a.get(i).print(false);
      if (multiline) currentPrinter.oprintln("");
    }
    if (a.size()>0) a.get(a.size()-1).print(false);
  }
  String sline(boolean escape) {
    String toEscape = s;
    if (escape) {
      toEscape = toEscape.replace("\\", "\\\\");
      toEscape = toEscape.replace("\n", "\\n");
      toEscape = toEscape.replace("\"", "\\\"");
    }
    if (type==STRING) return "\""+toEscape+"\"";
    if (type==BIGDECIMAL) return bd.toString();
    if (type==ARRAY) {
      if (a.size() == 0) return "[]";
      String o = "[";
      for (int i = 0; i < a.size(); i++) 
        o+=a.get(i).sline(escape)+(i+1==a.size()?"]":", ");
      return o;
    }
    return "*-*sline reached the unreachable type of "+type+"!*-*";
  }
  Poppable copy() {
    if (type==BIGDECIMAL) {
      return tp(bd);
    }
    if (type==STRING) {
      return tp(s);
    }
    ArrayList<Poppable> out = ea();
    for (Poppable cc : a) {
      out.add(cc.copy());
    }
    return tp(out);
  }
  Poppable roundForDisplay() {
    bd = bd.setScale(precision-5, BigDecimal.ROUND_HALF_UP);
    return this;
  }
  boolean equals(Poppable c) {
    if (
        (c.type==type) &&
        ((c.type==STRING && c.s.equals(s)) || (c.type==BIGDECIMAL && c.bd.equals(bd)))
       )
    return true;
    
    return false;
  }
  BigDecimal tobd() {
    if (type==BIGDECIMAL) return bd;
    return new BigDecimal(s);
  }
  String toMLStr(boolean multiline) {//to multiline string
    if (type==STRING) return s;
    if (type==BIGDECIMAL) return bd.toString();
    String res = "";
    for (int i = 0; i < a.size(); i++) {
      res+= a.get(i).toMLStr(false);
      if (multiline) res+="\n";
    }
    if (a.size()>0) a.get(a.size()-1).toMLStr(false);
    return res;
  }
  String toString() {
    return toMLStr(true);
  }
  String stringRepr(boolean multilineArrays) {
    if (type == ARRAY && multilineArrays) return toMLStr(true);
    return sline(true);
  }
}