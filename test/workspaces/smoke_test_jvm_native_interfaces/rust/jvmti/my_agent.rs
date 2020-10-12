use jvmti::{
    JavaVM,
    jint,
};

#[no_mangle]
pub extern fn Agent_OnLoad(
    vm: *mut JavaVM,
    options: *mut ::std::os::raw::c_char,
    reserved: *mut ::std::os::raw::c_void,
) -> jint {
    println!("Hello, from `Agent_OnLoad()`, implemented in Rust.");
    return 0;
}

#[no_mangle]
pub extern fn Agent_OnAttach(
    vm: *mut JavaVM,
    options: *mut ::std::os::raw::c_char,
    reserved: *mut ::std::os::raw::c_void,
) -> jint {
    println!("Hello, from `Agent_OnAttach()`, implemented in Rust.");
    return 0;
}

#[no_mangle]
pub extern fn Agent_OnUnload(vm: *mut JavaVM) {
    println!("Hello, from `Agent_OnUnoad()`, implemented in Rust.");
}
