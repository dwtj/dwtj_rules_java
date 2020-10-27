package pkg.b;

import java.net.URL;

public class B {
    private static final String resourceName = "pkg/b/B.class";

    public static void check() {
        URL classUrl = ClassLoader.getSystemResource(resourceName);
        if (classUrl == null) {
            throw new RuntimeException("Failed to load a system resource named " + resourceName);
        }
    }
}
