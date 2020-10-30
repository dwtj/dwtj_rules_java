package pkg;

import static java.lang.System.getProperty;
import static java.lang.System.exit;
import static java.lang.System.err;
import static java.lang.System.out;

public class ExpectJvmProperties {
    public static void main(String[] args) {
        if (args.length == 0) {
            out.println("No arguments...");
            exit(0);
        }

        out.println("Arguments: ");
        for (String arg : args) {
            out.println(arg);
        }
        out.println();

        if (args.length != 2) {
            err.println("ERROR: Expected either zero or two arguments, but got " + args.length);
            exit(-1);
        }
        String vendor = getProperty("java.vendor");
        String version = getProperty("java.version");

        if (! args[0].equals(vendor)) {
            err.println("ERROR: Got an unexpected value for `java.vendor`.");
            err.println("Expected: " + args[0]);
            err.println("Actual: " + vendor);
            exit(-1);
        }

        if (! args[1].equals(version)) {
            err.println("ERROR: Got an unexpected value for `java.version`.");
            err.println("Expected: " + args[1]);
            err.println("Actual: " + version);
            exit(-1);
        }
    }
}
