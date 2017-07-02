soglOS = "";
soglOSP = "";
void launchSOGL(String program, String[] inputs) {
  soglOS = "";
  args = new String[inputs.length()+1];
  args[0] = program;
  for (int i = 0; i < inputs.length(); i++) {
    args[i+1] = inputs[i];
  }
  launchSOGLP2();
  readyOutput();
  console.log("escaped output: \""+(soglOSP.replace("\\","\\\\").replace("\"","\\\"").replace("\n", "\\n"))+"\"");
}
void readyOutput() {
  soglOSP = soglOS;
  try {
    if (soglOSP.charAt(0)=="\n")
      soglOSP = soglOSP.substring(1);
    if (soglOSP.charAt(soglOSP.length()-1)=="\n")
      soglOSP = soglOSP.substring(0, soglOSP.length()-1);
    if (soglOSP.charAt(soglOSP.length()-1)=="\n")
      soglOSP = soglOSP.substring(0, soglOSP.length()-1);
  } catch(Exception e){e.printStackTrace();}
}
/*
boolean loaded = false;
String lfCont = "";
void loadFile (String dir) {
  var xhr = new XMLHttpRequest();
  xhr.open('GET', 'example.com');
  xhr.onreadystatechange = function() {
    lfCont = xhr.responseText;
    
  }
  xhr.send();
}
function loadFile (String dir) {
  var quote;
 
  return new Promise(function(resolve, reject) {
    request('http://ron-swanson-quotes.herokuapp.com/v2/quotes', function(error, response, body) {
      quote = body;
 
      resolve(quote);
    });
  });
}*/

Big.DP = precision;
Big.RM = 1;
String loadString(String name) {
  String out = null;
//insert
  return out;
}
String[] loadStrings(String name) {
  return split(loadString(name), "\n");
}
String loadJSONObject(String name) {
  String out = loadString(name);
  return parseJSONObject(out);
}
JSONObject parseJSONObject(String jsonin) {
  return eval(jsonin);
}
String dataPath (String s) {
  return s;
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
class IntList {
  ArrayList<Integer> sl = new ArrayList<Integer>();
  void add(String s) {
    sl.add(s);
  }
  int get(int pos) {
    return sl.get(pos);
  }
  void append (int addable) {
    sl.add(addable);
  }
  int size() {
    return sl.size();
  }
  void remove(int pos) {
    sl.remove(pos);
  }
}

SystemClass System = new SystemClass();
args = new String[]{" h i"};
class SystemClass {
  SystemErr err = new SystemErr();
  SystemOut out = new SystemOut();
  void exit(int c) {}
}
void print(Object pr) {
  //console.log(pr);
  soglOS+= pr;
}
void println(Object pr) {
  //console.log(pr);
  soglOS+= pr+"\n";
}
pprint = print;
pprintln = println;
BI = B;
String lastConsoleLine = "";
class SystemErr {
  void print(Object pr) {
    lastConsoleLine+= pr;
    checkPrint();
  }
  void println(Object pr) {
    lastConsoleLine+= pr+"\n";
    checkPrint();
  }
  void checkPrint () {
    while (lastConsoleLine.indexOf("\n") >= 0) {
      console.log(lastConsoleLine.substring(0, lastConsoleLine.indexOf("\n")));
      lastConsoleLine = lastConsoleLine.substring(lastConsoleLine.indexOf("\n")+1);
    }//*/pprint(lastConsoleLine+"<br>");lastConsoleLine="";
  }
}
//Object tsketch = this;
class SystemOut {
  void print(Object pr) {
    pprint(pr);
  }
  void println(Object pr) {
    pprintln(pr);
  }
}
printArray = println;
class StringBuilder {
  String s;
  StringBuilder (String i) {
    s = i;
  }
  StringBuilder reverse () {
    String ns = "";
    for (int i = s.length()-1; i >= 0; i--) { 
      ns += s.charAt(i);
    }
    s = ns;
    return this;
  }
  String toString() {
    return s;
  }
  StringBuilder substring(int i, int j) {
    if (j==undefined)
      s = s.substring(i);
    else 
      s = s.substring(i, j);
    return this;
  }
}