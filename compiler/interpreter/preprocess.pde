String quirkLetters = " 0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
String[] quirks = {"0*0/","1*1/","2*2/","3*3/","4*4/","5*5/","6*6/","7*7/","8*8/","9*9/","0/0*","1/1*","2/2*","3/3*","4/4*","5/5*","6/6*","7/7*","8/8*","9/9*","UU","uu","SU","Su","US","uS","!?","²²","!!","2÷","╥╥","╥╤","ΓΓ","╥Γ"};
class Preprocessable {
  ArrayList<Poppable> stack = new ArrayList<Poppable>();
  //ArrayList<Poppable> usedInputs = new ArrayList<Poppable>();
  int ptr = 0;
  int inpCtr = -1;
  Poppable lIT = tp(B("-1234"));//last input taken
  String[] inputs;
  int[] sdata;
  int[] ldata;
  int[] qdata;
  int[] lef; 
  /*
  subarrays:
    object
    counter
  */
  Poppable[] data;
  int[] dataL;
  Poppable[] vars;
  String p;
  Executable parent = null;
  String lastString = "Hello, World!";
  boolean lastStringUsed = false;
  boolean specifiedScreenRefresh = false;
  Preprocessable (String prog, String[] inputs) {
    if (getDebugInfo)
      eprintln("###");
    preprocess(prog, inputs);
  }
  Preprocessable preprocess(String prog, String[] inputs) {
    this.inputs = inputs;
    p = prog;//.replace("…", "\n");
    sdata = new int[p.length()];
    ldata = new int[p.length()];
    qdata = new int[p.length()];
    data = new Poppable[p.length()];
    dataL = new int[p.length()];
    for (int i = 0; i < sdata.length; i++) {
      sdata[i]=0;
      ldata[i]=0;
      qdata[i]=-1;
    }
    //variable defaults
    vars = new Poppable[5];
    vars[0] = new Poppable (B(0));
    vars[1] = new Poppable (INN);
    vars[2] = new Poppable (ea());
    vars[3] = new Poppable (INS);
    vars[4] = new Poppable (INN);
    char[] skippingChars = {' ', 'Ζ', 'ƨ', 'Ƨ', '╬'};
    int[] skippingCharsL = { 1,   2,   2,   2,   1 };
    /*
    SDATA: (string data)
     1 - string ender
     2 - string starter
     3 - string
     4 - compressed ender
     LDATA: (loop/if data)
     "{", "?", "[", "]", "∫", "‽", "⌠" - ending pointer
     "}" - starting pointer (for loops)
     */
    //for (int i = 0; i < p.length(); i++) if (p.charAt(i)=='→') CT = true;
      if (p.contains("\n")) {
        //println (p.contains("→"));
        int i = 0;
        String res = "";
        while (p.charAt(i)!='\n') {
          //println(p.charAt(i)+" → "+(p.charAt(i)!='→'));
          res+=p.charAt(i);
          i++;
        }
      eprintln("preprocessor: "+p.replace("\n", "…"));
      //5{t}→Y \Y /Y
      //println(res+"\n"+i+"\n"+p);
      return preprocess(p.substring(i+1).replace(p.charAt(i-1)+"", res.substring(0, res.length()-1)), inputs);
    }
    for (int i = 0; i < p.length(); i++) {
      boolean skip = false;
        for (int j = 0; j < skippingChars.length; j++)
          if (skippingChars[j]==p.charAt(i)) {
          skip = true;
          i+=skippingCharsL[j];
        }
      if (skip) {
        continue;
      }
      if (p.charAt(i)=='”' || p.charAt(i)=='‘' || p.charAt(i)=='’' || p.charAt(i)=='“') {
        sdata[i]=1;
        int j=i-1;
        String thisString = "";
        while (true) {
          if (j == -1) break;
          sdata[j]=3;
          thisString = p.charAt(j) + thisString;
          j--;
          if (j == -1) break;
          if (p.charAt(j)=='"') {
            sdata[j]=2;
            break;
          }
          if (sdata[j]<3&sdata[j]>0) break;
        }
        lastString = thisString;
      } else if (p.charAt(i)=='"') {
        sdata[i]=2;
        i++;
        String thisString = "";
        while (true) {
          if (i == p.length()) break;
          sdata[i]=3;
          if (p.charAt(i)=='”' || p.charAt(i)=='‘' || p.charAt(i)=='’' || p.charAt(i)=='“') {
            sdata[i]=1;
            break;
          }
          thisString = thisString + p.charAt(i);
          i++;
          if (i == p.length()) break;
          if (sdata[i]<3&sdata[i]>0) break;
        }
        //if (i < p.length() && p.charAt(i)=='‘')
          //lastString = decompress(thisString);
        //else
          lastString = thisString;
      } else for (int j = 0; j < quirks.length; j++)
        if (p.substring(i).startsWith(quirks[j]) && qdata[i] == -1)
          for (int k = 0; k < quirks[j].length(); k++)
            qdata[k+i] = j;
    }
    IntList loopStack = new IntList();
    for (int i = 0; i < p.length(); i++) {
      if (p.charAt(i)==' ') {
        i++;
        continue;
      }
      if (p.charAt(i)=='Ƨ') {
        i+=2;
        continue;
      }
      while (i<sdata.length && sdata[i]!=0) i++;
      if (i>sdata.length-1) break;
      if ("{?[]∫‽⌠".contains(p.charAt(i)+"")) {
        loopStack.append(i);
      }
      if (p.charAt(i)=='}'|p.charAt(i)=='←') {
        if (loopStack.size()>0) {
          ldata[i]=loopStack.get(loopStack.size()-1);
          int temp = loopStack.get(loopStack.size()-1);
          loopStack.remove(loopStack.size()-1);
          ldata[temp] = i;
        } else {
          ldata[i]=0;
        }
      }
    }
    /*if (p.contains("⌡")) {
        //println (p.contains("→"));
        int i = 0;
        String res = "";
        while (i < p.length()) {
          if (p.charAt(i)!='⌡' && sdata[i] == 0) {
            eprintln("preprocessor: "+p.replace("\n", "¶"));
            return preprocess(p.substring(0, i)+p.charAt(i+1)+p.substring(i+2, p.length()-1), inputs);
          }
          res+=p.charAt(i);
          i++;
        }
      
    }*/
    if (loopStack.size()>0) {
      if (sdata.length>0 && sdata[sdata.length-1] == 3) p+= '”';
      for (int i = 0; i < loopStack.size(); i++) p+= '}';
      eprintln("preprocessor: "+p.replace("\n", "…"));
      return preprocess(p, inputs);
    }
    for (int i = 0; i < p.length(); i++) {
      if (p.charAt(i) == '▒' && sdata[i] != 3) specifiedScreenRefresh = true;
    }
    //p = p.replace("¶", "\n");
    if (!getDebugInfo) return this;
    eprintln("program: "+p.replace("\n", "¶"));
    eprint("|");
    for (int i=0; i<sdata.length; i++)eprint((p.charAt(i)+(i==sdata.length-1?"|":" ")).replace("\n", "¶"));
    eprint(" chars\n|");
    for (int i=0; i<sdata.length; i++)eprint(sdata[i]+"|");
    eprint(" strings\n|");
    for (int i=0; i<sdata.length; i++)eprint(quirkLetters.charAt(qdata[i]+1)+"|");
    eprint(" quirks\n|");
    for (int i=0; i<sdata.length; i++)eprint((ldata[i]+"").length()==1?ldata[i]+"|":ldata[i]+"");
    eprint(" loops\n|");
    for (int i=0; i<sdata.length; i++)eprint(i%10+"|");
    eprint(" 1s\n|");
    for (int i=0; i<sdata.length; i++)eprint(floor(i/10)%10+"|");
    eprintln(" 10s");
    eprintln("###\n");
    return this;
  }
  Poppable sI () {
    try {
      inpCtr++;
      if (inpCtr>=inputs.length)
        inpCtr = 0;
      //  usedInputs.add(new Poppable(inputs[inpCtr], true));
      return new Poppable (inputs[inpCtr], true);
    } 
    catch (Exception e) {
      eprintln("*-*String input error at inpCtr "+inpCtr+": "+e+"*-*");
      return new Poppable ("", false);
    }
  }

  Poppable nI () {
    String input = "this should not happen (it can tho)";
    try {
      inpCtr++;
      if (inpCtr>=inputs.length)
        inpCtr = 0;
      input = inputs[inpCtr];
      //usedInputs.add(new Poppable(B(inputs[inpCtr]), true));
      lIT = new Poppable (B(input), true);
      return new Poppable (B(input), true);
    } 
    catch (Exception e) {
      eprintln("*-*nI error: "+e+"*-*");
      lIT = new Poppable (input, true);
      return new Poppable (input, true);
    }
  }
  void setvar (int v, Poppable p) {
    vars[v]=p;
  }
  
  /*RMP5*/
  void push (Poppable p) {
    stack.add(new Poppable(p).copy());
  }
  void push (String s) {
    push(new Poppable(s));
  }
  void push (long l) {
    push(new Poppable(new BigDecimal(l)));
  }
  void push (float l) {
    push(new Poppable(new BigDecimal(l)));
  }
  void push (ArrayList<Poppable> a) {
    push(new Poppable(a));
  }
  void push (String[] a) {
    push(new Poppable(SA2PA(a)));
  }
  void push (boolean b) {
    push(new Poppable(B(b?"1":"0")));
  }
  void push (BigDecimal d) {
    push(new Poppable(d));
  }
  //*/
  //P5JSPushes
  Poppable pop (int implicitType) {
    Poppable res;
    if (stack.size()>0) res = pop();
    else if (implicitType == BIGDECIMAL) res = nI();
    else if (implicitType == STRING) res = sI();
    else res = new Poppable(B("0"));
    lIT = res;
    return res.copy();
  }
  
  Poppable pop () {
    try {
      Poppable r = gl();
      stack.remove(stack.size()-1);
      lIT = r;
      return r.copy();
    } catch (Exception e) {
      eprint("*-*warning on pop(): "+e.toString()+" - function called pop() without implicit input type?*-*");
      e.printStackTrace();
      String ns = sI().s;
      boolean isString = false;
      for (char c : ns.toCharArray())
        if (c<'0' || c>'9') {
          isString = true;
          break;
        }
      if (isString) {
        return tp(ns).copy();
      } else {
        return tp(B(ns)).copy();
      }
    }
  }
  
  Poppable npop (int implicitType) {
    if (stack.size()>0) {
      return gl().copy();
    }
    if (implicitType == BIGDECIMAL)
      return nI().copy();
    else if (implicitType == STRING)
      return sI().copy();
    else return new Poppable(0);
  }
  Poppable gl () {//get last
    if (stack.size()==0) {
      lIT = PZERO;
      return PZERO;
    }
    Poppable g = stack.get(stack.size()-1);
    lIT = g;
    return g;
  }
  String getStart(boolean self) {
    String beggining = "";
    if (parent != null)
      beggining = parent.getStart(true);
    if (self)
      beggining += "`" + p.charAt(ptr) + "`@" + up0(ptr, str(p.length()).length()) + ": ";
    return beggining;
  }
  void oprint (String o) {
    System.out.print(o);
    if (saveOutputToFile) {
      savedOut.append(o);
    }
  }
  void oprintln (String o) {
    System.out.println(o);
    if (saveOutputToFile)
      savedOut.append(o+"\n");
  }
  void oprint (BigDecimal o) {
    System.out.print(o);
    if (saveOutputToFile)
      savedOut.append(o.toString());
  }
  void oprintln (BigDecimal o) {
    System.out.println(o);
    if (saveOutputToFile)
      savedOut.append(o.toString()+"\n");
  }
  void oprint (JSONArray o) {
    System.out.print(o);
    if (saveOutputToFile)
      savedOut.append(o.toString());
  }
  void oprintln (JSONArray o) {
    System.out.println(o);
    if (saveOutputToFile)
      savedOut.append(o.toString()+"\n");
  }
  void oprintln () {
    System.out.println();
    if (saveOutputToFile)
      savedOut.append("\n");
  }
  
  void eprintln (String o) {
    if (getDebugInfo) {
      if (printDebugInfo)
        System.err.println(o);
      if (saveDebugToFile)
        log.append(o+"\n");
    }
  }
  void eprint (String o) {
    if (getDebugInfo) {
      if (printDebugInfo)
        System.err.print(o);
      if (saveDebugToFile)
        log.append(o);
    }
  }
}