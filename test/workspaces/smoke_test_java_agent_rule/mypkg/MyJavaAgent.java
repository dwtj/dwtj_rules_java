package mypkg;

import java.lang.instrument.Instrumentation;

class MyJavaAgent {
    public static void premain(String agentArgs, Instrumentation inst) {
        System.out.println("Hello, from `MyJavaAgent.premain()`.");
    }
}