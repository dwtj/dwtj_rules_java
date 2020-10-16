package st.simple;

class A {
    public static void main(String[] args) {
        a();
    }

    static void a() {
        System.out.println("a");
        B.b();
        C.c();
    }
}
