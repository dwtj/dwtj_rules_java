package pkg.resources.a;

public class TestA {
  public static void main(String[] args) {
      assert LibA.getFirstLineOfResourceAsUtf8String().equals("Hello, A.");
  }
}
