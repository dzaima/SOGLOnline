import java.nio.charset.StandardCharsets;
import java.util.Scanner;
void setup() {
  try {
    String pname = "interpreter";
    String inF = dataPath("../"+pname);//input folder
    String outF = dataPath("../../");//output folder
    println("Input path: " + inF);
    println("Output path: " + outF);
    File folder = new File(inF+"/data");
    File[] listOfFiles = folder.listFiles();
    String mainPDE = "";
    String writableFiles = "";
    String[] disabledFiles = new String[]{"Defs","p.sogl", "options"};
    cf: for (int i = 0; i < listOfFiles.length; i++) {
      for (String cdf : disabledFiles) {
        if (listOfFiles[i].getName().contains(cdf)) {
          continue cf;
        }
      }
      if (listOfFiles[i].isFile() ) {
        writableFiles+= "  if (name.equals(\""+escape(listOfFiles[i].getName())+"\")) out = \""+escape(new String(loadBytes(listOfFiles[i]), StandardCharsets.UTF_8))+"\";\n";
        println("writing file for " + listOfFiles[i].getName());
      }
    }
    println("written files");
    folder = new File(inF);
    listOfFiles = folder.listFiles();
    mainPDE+= process(new String(loadBytes(inF+"/"+pname+".pde"), StandardCharsets.UTF_8)+"\n\n");
    for (int i = 0; i < listOfFiles.length; i++) {
      if (listOfFiles[i].isFile() && listOfFiles[i].getName().endsWith(".pde") && !listOfFiles[i].getName().equals(pname+".pde")) {
        if (listOfFiles[i].getName().equals("poppable.pde"))
          mainPDE+= process(le("poppable12.pde")+"\n\n");
        else
          mainPDE+= process(new String(loadBytes(listOfFiles[i]), StandardCharsets.UTF_8)+"\n\n");
        println("added "+ listOfFiles[i].getName());
      }
    }
    mainPDE = mainPDE.replace("//--ENDINIT--", le("additions.pde").replace("//insert", writableFiles));
    println("written additions");
    saveStrings(outF+"/compiled.pde", new String[]{mainPDE});
    println("Saved compiled.pde");
    
    //async-stripped
    folder = new File(outF);
    listOfFiles = folder.listFiles();
    for (File cFile : listOfFiles) {
      if (cFile.isFile() && !cFile.getName().equals(".git")) {
        println("copying async-stripped "+ outF+"/"+cFile.getName());
        String[] fi = loadStrings(outF+"/"+cFile.getName());
        String[] fo = new String[fi.length];
        int i = 0;
        for (String c : fi) {
          fo[i] = cFile.getName().equals("processing.js")? c : c.replaceAll("async|await", "");
          i++;
        }
        saveStrings(outF+"/comp/"+cFile.getName(), fo);
      }
    }
    //compressor
    writableFiles = "";
    mainPDE = "";
    inF = dataPath("../compression");//input folder
    outF = dataPath("../../compression");//output folder
    println("Compression input path: " + inF);
    println("Compression output path: " + outF);
    folder = new File(inF+"/data");
    listOfFiles = folder.listFiles();
    for (int i = 0; i < listOfFiles.length; i++) {
      if (listOfFiles[i].isFile()) {
        writableFiles+= "  if (name.equals(\""+escape(listOfFiles[i].getName())+"\")) out = \""+escape(new String(loadBytes(listOfFiles[i]), StandardCharsets.UTF_8))+"\";\n";
        println("writing file for " + listOfFiles[i].getName());
      }
    }
    println("written files");
    folder = new File(inF);
    listOfFiles = folder.listFiles();
    for (int i = 0; i < listOfFiles.length; i++) {
      if (listOfFiles[i].isFile() && listOfFiles[i].getName().endsWith(".pde"))
        mainPDE+= process(new String(loadBytes(listOfFiles[i]), StandardCharsets.UTF_8)+"\n\n");
      println("added "+ listOfFiles[i].getName());
    }
    mainPDE = mainPDE.replace("//insert", writableFiles);
    println("written additions");
    saveStrings(outF+"/compiled.pde", new String[]{mainPDE});
    println("Saved compiled.pde");
  } catch (Exception e) {
    System.err.println("Error: ");
    e.printStackTrace();
  }
  println("updating word file from interpreter");
  String wordFileName = "words3.0_wiktionary.org-Frequency_lists.txt";
  saveStrings(dataPath("../compression/data/"+wordFileName), loadStrings(dataPath("../interpreter/data/"+wordFileName)));
  System.exit(0);
}
boolean debug = false;
String process (String s) {
  if (debug) {
    s = s.replace("e.printStackTrace();", "console.log(new Error().stack);");
  } else {
    s = s.replace("e.printStackTrace();", "");
  }
  return s.replaceAll("([a-z_]+) instanceof Integer","$1 === parseInt($1)")
          .replaceAll("([^, \\d] *)- *'(\\\\?.)'", "$1.charCodeAt(0)-'$2'.charCodeAt(0)")
          .replaceAll("/\\*\\*/'(\\\\?.)'","\"$1\".charCodeAt(0)")
          .replace("runningP5", "true")
          .replace("readFromArg = false;", "readFromArg = true;")
          .replace("push(a.s.length() > 0? a.s.charAt(0) : 0);", "push(a.s.length() > 0? a.s.charAt(0).charCodeAt(0) : 0);")
          .replace("RMP5*/","")
          .replace("ADDP5","*/")
          .replaceAll("\\.get(Boolean|String|Int)\\(\"([^\"]+)\"\\)", ".$2")
          .replaceAll("\\(char\\)([^\n]+?)\\+\"\"", "String.fromCharCode($1)")
          .replace(", StandardCharsets.UTF_8", "")
          .replace("readFile", "loadString")
          .replaceAll("\\.replaceAll\\(\"(([^\"]|\\.)*)\"", ".replace(new RegExp(\"$1\",\"g\")")
          .replace("//P5JSPushes", le("pushes.pde"))
          .replace("//P5JSfromPase", le("fromBase.pde"))
          .replaceAll("'([^\\\\]|\\\\.)'", "\"$1\"")
          .replace("\"\\\\'\"", "\"'\"")
          .replace("\"\"\"", "\"\\\"\"")
          .replace("delay", "await sleep")
          .replace("/*IP5", "")
          .replace("IP5*/", "")
          .replaceAll("Collections\\.sort\\((\\w+),", "$1 = new Collections().sort($1,")
          .replaceAll("Arrays\\.sort\\((\\w+)\\)", "$1.sort()")//(a,b)=>a.compareTo(b)
          .replace("new String(sorted)", "join(sorted, \"\")")
          .replace("System.exit(0);", "running = false;")
          .replaceAll("\\.matches\\(\"(([^\"]|\\\\.)+)\"\\)", "\\.match\\(new RegExp\\(\"$1\"\\)\\)!=null")
          .replace("void setup() {", "void setup(){\n  size(1,1);\n  PLoaded();\n}\nvoid launchSOGLP2() {")
          .replaceAll("toCharArray\\(\\)\\) \\{","toCharArray\\(\\)\\) {s=String.fromCharCode(s);")
          .replaceAll("(?!\\.|o)\\b(o?println)\\(\\)", "$1\\(\"\"\\)");
}
String le(String path) {
  return new String(loadBytes(dataPath(path)), StandardCharsets.UTF_8);
}
String escape (String s) {
  return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n","\\n").replace("\r","");
}
String unescape (String s) {
  return s.replace("\\\"","\"").replace("\\\\", "\\");
}