package st;

import org.graalvm.nativeimage.IsolateThread;
import org.graalvm.nativeimage.c.function.CEntryPoint;

class MyTestApp {
    @CEntryPoint
    public static void myMethod(IsolateThread isolateThread) {
        System.out.println("Hello, world!");
    }
}
