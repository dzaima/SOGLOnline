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
      }
    }
    mainPDE = mainPDE.replace("//--ENDINIT--", le("additions.pde").replace("//insert", writableFiles));
    println("written additions");
    saveStrings(outF+"/compiled.pde", new String[]{mainPDE});
    println("Saved compiled.pde");
  } catch (Exception e) {
    System.err.println("Error: ");
    e.printStackTrace();
  }
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
          .replaceAll("-'(\\\\?.)'", ".charCodeAt(0)-'$1'.charCodeAt(0)")
          .replace("readFromArg = false;", "readFromArg = true;")
          .replace("push(a.s.length() > 0? a.s.charAt(0) : 0);", "push(a.s.length() > 0? a.s.charAt(0).charCodeAt(0) : 0);")
          .replace("RMP5*/","")
          .replace("ADDP5","*/")
          .replaceAll("\\.get(Boolean|String|Int)\\(\"([^\"]+)\"\\)", ".$2")
          .replaceAll("\\(char\\)([^\n]+?)\\+\"\"", "String.fromCharCode($1)")
          .replace(", StandardCharsets.UTF_8", "")
          .replace("readFile", "loadString")
          .replace("//P5JSPushes", le("pushes.pde"))
          .replace("//P5JSfromPase", le("fromBase.pde"))
          .replaceAll("'([^\\\\]|\\\\.)'", "\"$1\"")
          .replace("\"\\\\'\"", "\"'\"")
          .replace("\"\"\"", "\"\\\"\"")
          .replaceAll("\\.matches\\(\"(([^\"]|\\\\.)+)\"\\)", "\\.match\\(new RegExp\\(\"$1\"\\)\\)!=null")
          .replace("void setup() {", "void setup(){size(1,1);}void launchSOGLP2() {")
          .replaceAll("toCharArray\\(\\)\\) \\{","toCharArray\\(\\)\\) {s=String.fromCharCode(s);")
          .replaceAll("(?!\\.|o)\\b(o?println)\\(\\)", "$1\\(\"\"\\)");
}
String le(String path) {
  return new String(loadBytes(dataPath(path)), StandardCharsets.UTF_8);
}
String escape (String s) {
  return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n","\\n");
}
String unescape (String s) {
  return s.replace("\\\"","\"").replace("\\\\", "\\");
}