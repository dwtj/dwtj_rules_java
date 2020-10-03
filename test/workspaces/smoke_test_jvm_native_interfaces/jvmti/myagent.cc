#include <iostream>

#include "jvmti.h"
#include "jni.h"

JNIEXPORT jint JNICALL
Agent_OnLoad(JavaVM *vm, char *options, void *reserved) {
  std::cout << "Hello, from JVMTI." << std::endl;
  return 0;
}
