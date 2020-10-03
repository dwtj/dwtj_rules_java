#include "jni/jni_MyLib.h"
#include <iostream>

extern "C"
JNIEXPORT void JNICALL Java_jni_MyLib_myMethod(JNIEnv* env, jclass cls) {
  std::cout << "Hello, from JNI." << std::endl;
}
