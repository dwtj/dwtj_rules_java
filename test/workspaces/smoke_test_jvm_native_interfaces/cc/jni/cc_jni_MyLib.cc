#include "cc/jni/cc_jni_MyLib.h"
#include <iostream>

extern "C"
JNIEXPORT void JNICALL Java_cc_jni_MyLib_myMethod(JNIEnv* env, jclass cls) {
  std::cout << "Hello, from JNI." << std::endl;
}
