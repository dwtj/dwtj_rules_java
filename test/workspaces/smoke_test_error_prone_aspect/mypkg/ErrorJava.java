package mypkg;

class ErrorJava {
    void myMethod() {
        // https://errorprone.info/bugpattern/ComparingThisWithNull
        if (this == null) {
            System.out.println("Somehow, `this` is `null`.");
        }
    }
}
