package pkg.resources.a;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.nio.charset.Charset;

public class LibA {
  public static String getFirstLineOfResourceAsUtf8String() {
    try {
      InputStream inStream = LibA.class.getResourceAsStream("a.txt");
      InputStreamReader inReader = new InputStreamReader(inStream, Charset.forName("UTF-8"));
      BufferedReader in = new BufferedReader(inReader);
      return in.readLine();
    } catch (Exception ex) {
      throw new RuntimeException(ex);
    }
  }
}
