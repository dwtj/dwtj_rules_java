package jni;

class MyLib {
    static {
        System.loadLibrary("myjni");
    }

    public native static void myMethod();

    public static void main(String[] args) {
        System.out.println("Hello, from Java application.");
        myMethod();
    }
}
