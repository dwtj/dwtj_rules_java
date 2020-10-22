package st;

class CheckJdkVersion {
    public static void main(String[] args) {
        var java_version = System.getProperty("java.version");
        if (!java_version.startsWith("16")) {
            System.err.println("Unexpected `java.version`: " + java_version);
            System.exit(1);
        }
    }
}
