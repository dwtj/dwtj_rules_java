package my_test_app;

import my_anno.MakeMyGenSrc;
import my_anno.MyGenSrc;

@MakeMyGenSrc
class MyTestApp {
    public static void main(String[] args) {
        MyGenSrc.myMethod();
    }
}
