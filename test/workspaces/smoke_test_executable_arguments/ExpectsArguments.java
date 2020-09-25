class ExpectsArguments {

    private static final String[] expectedArgs = {"Hello", "World"};

    public static void main(String[] actualArgs) {
        if (actualArgs.length != expectedArgs.length) {
            System.err.println("Wrong number of CLI arguments.");
            System.exit(-1);
        }
        for (int idx = 0; idx < expectedArgs.length; idx++) {
            if (!expectedArgs[idx].equals(actualArgs[idx])) {
                System.err.println("A CLI argument was not as expected.");
                System.exit(-1);
            }
        }
        System.exit(0);
    }
}
