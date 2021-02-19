package pkg.resources.b;

public class TestB {
  public static void main(String[] args) {
      assert LibB.getFirstLineOfResourceAsUtf8String().equals("Hello, B.");
  }
}
