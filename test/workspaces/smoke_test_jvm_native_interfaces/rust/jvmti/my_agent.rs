use jvmti::{
    JavaVM,
    jint,
    jvmtiCapabilities,
};

pub fn use_derived_default_trait_impl() {
    let capa = jvmtiCapabilities {
        ..Default::default()
    };
    println!("Default for `jvmtiCapabilities.can_generate_all_class_hook_events`: {}", capa.can_generate_all_class_hook_events());
}

#[no_mangle]
pub extern fn Agent_OnLoad(
    vm: *mut JavaVM,
    options: *mut ::std::os::raw::c_char,
    reserved: *mut ::std::os::raw::c_void,
) -> jint {
    println!("Hello, from `Agent_OnLoad()`, implemented in Rust.");
    use_derived_default_trait_impl();
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
