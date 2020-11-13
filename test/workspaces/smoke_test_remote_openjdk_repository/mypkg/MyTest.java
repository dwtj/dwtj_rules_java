package mypkg;

import static java.lang.System.getProperty;
import static java.lang.System.out;

class MyTest {
    private static final String expectedVersion = "11.0.9";

    public static void main(String[] args) {
        String actualVersion = getProperty("java.version");
        if (expectedVersion.equals(actualVersion)) {
            out.println("The `java.version` system property value is as expected: " + expectedVersion);
        } else {
            throw new RuntimeException("Unexpected `java.version` system property value: " + actualVersion);
        }
    }
}
