package pkg.a;

import java.net.URL;

public class A {
    private static final String resourceName = "pkg/a/A.class";

    public static void check() {
        URL classUrl = ClassLoader.getSystemResource(resourceName);
        if (classUrl == null) {
            throw new RuntimeException("Failed to load a system resource named " + resourceName);
        }

        pkg.b.B.check();
    }
}
