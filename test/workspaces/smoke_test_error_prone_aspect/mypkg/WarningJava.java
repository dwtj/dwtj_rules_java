package mypkg;

class WarningJava {
    boolean myMethod() {
        // https://errorprone.info/bugpattern/BadInstanceof
        if (this instanceof WarningJava) { // BAD: always true
            return true;
        }
        return false;
    }
}
