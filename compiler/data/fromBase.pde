BigInteger fromBase (int base, Object num) {
  if (num instanceof String) {
    BigInteger o = BI(0);
    for (int i = 0; i < num.length(); i++) {
      o = o.multiply(BI(base)).add(BI(num.charAt(i)+""));
    }
    return o;
  } else {
    BigInteger o = BI(0);
    for (byte b : num) {
      o = o.multiply(BI(base)).add(BI(b&0xFF));
    }
    return o;
  }
}