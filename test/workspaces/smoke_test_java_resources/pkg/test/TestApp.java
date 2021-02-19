package pkg.test;

import pkg.resources.a.LibA;
import pkg.resources.b.LibB;

public class TestApp {
  public static void main(String[] args) {
    assert LibA.getFirstLineOfResourceAsUtf8String().equals("Hello, A.");
    assert LibB.getFirstLineOfResourceAsUtf8String().equals("Hello, B.");
  }
}
