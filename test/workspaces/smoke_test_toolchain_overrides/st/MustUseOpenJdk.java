package st;

class MustUseOpenJdk {
    public static void main(String[] args) {
        String vendor = System.getProperty("java.vm.vendor");
        if (! "AdoptOpenJDK".equals(vendor)) {
            System.out.println("Unexpected `java.vm.vendor`: " + vendor);
            System.exit(1);
        }
    }
}
