void push (Object p) {
    //console.log(p);
    //println("PUSH "+ p +" type "+ (typeof p) +" string "+ (p instanceof Poppable));
    if (p instanceof Poppable) {
      stack.add(new Poppable(p).copy());
    }
    else if (p instanceof String) {
      push(new Poppable(p));
    }
    else if (typeof p == "number") {
      push(new Poppable(new BigDecimal(p)));
    }
    else if (p instanceof ArrayList<Poppable>) {
      push(new Poppable(p));
    }
    else if (typeof p == "boolean") {
      push(new Poppable(B(p?"1":"0")));
    }
    else if (p instanceof BigDecimal) {
      push(new Poppable(new BigDecimal(p.toString())));
    } else {
      push(js2P(p));
    }
  }
  Poppable js2P(var cP) {
    if (typeof cP == "string") return new Poppable(cP);
    if (typeof cP == "number") return new Poppable(new BigDecimal(cP));
    ArrayList<Poppable> cout = ea();
    for (int i = 0; i < cP.length; i++) {
      cout.add(js2P(cP[i]));
    }
    return new Poppable(cout);
  }