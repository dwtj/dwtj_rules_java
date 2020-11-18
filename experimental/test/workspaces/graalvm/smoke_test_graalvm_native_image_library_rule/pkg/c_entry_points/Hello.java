package pkg.c_entry_points;

import org.graalvm.nativeimage.IsolateThread;
import org.graalvm.nativeimage.c.function.CEntryPoint;

class Hello {
  @CEntryPoint(name = "Java_pkg_c_entry_points_Hello_myEntryPoint")
  public static void myEntryPoint(IsolateThread isolateThread) {
    System.out.println("Hello, world!");
    Goodbye.goodbye();
  }

  public static void main(String[] args) {
    System.out.println("Hello, world!");
    Goodbye.goodbye();
  }
}
