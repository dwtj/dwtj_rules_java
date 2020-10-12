use jni::{
    JNIEnv,
    jclass,
};

#[no_mangle]
pub extern fn Java_rust_jni_MyLib_myMethod(_arg1: *mut JNIEnv, _arg2: jclass) {
    println!("Hello, from `rust.jni.MyLib#myMethod`, implemented in Rust.");
}
