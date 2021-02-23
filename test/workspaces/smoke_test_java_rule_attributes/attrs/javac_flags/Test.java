package attrs.javac_flags;

import attrs.javac_flags.test_anno.TestAnno;
import attrs.javac_flags.test_anno.TestGenSrc;

@TestAnno
class Test {
  public static void main(String[] args) {
    TestGenSrc.myMethod();
  }
}
