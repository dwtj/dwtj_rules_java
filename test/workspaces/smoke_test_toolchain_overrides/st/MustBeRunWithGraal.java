package st;

class MustBeRunWithGraal {
    public static void main(String[] args) {
        String vendor = System.getProperty("java.vm.vendor");
        if (! "GraalVM Community".equals(vendor)) {
            System.out.println("Unexpected `java.vm.vendor`: " + vendor);
            System.exit(1);
        }
    }
}
