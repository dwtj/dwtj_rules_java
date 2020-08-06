class MyLibrary {
    public static void hello() {
        System.out.println("Hello, from `MyLibrary`.");
        MyLegacyLibrary.hello();
    }
}
