package attrs.jvm_args;

class CheckSystemProperty {
    public static void main(String[] args) {
        String name = args[0];
        String expectedValue = "";
        if (args.length < 2) {
            expectedValue = args[1];
        }
        String actualValue = System.getProperty(name);
        if (actualValue == null) {
            System.err.println("System property not set: " + name);
            System.exit(1);
        }
        if (!expectedValue.equals(actualValue)) {
            System.err.println("Unexpected system property value: " + actualValue);
            System.err.println("Expected value: " + expectedValue);
            System.exit(2);
        }
    }
}
