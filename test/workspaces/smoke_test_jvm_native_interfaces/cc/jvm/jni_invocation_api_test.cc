#include <iostream>
#include <cassert>

#include "jni.h"

using std::string;
using std::cout;
using std::endl;

const string class_path_property_prefix = "-Djava.class.path=";

constexpr int num_jvm_options = 1;

int main(int argc, char* argv[]) {
  assert(argc == 3);

  string class_path_option(class_path_property_prefix);
  class_path_option += argv[1];
  cout << "Class Path Option: " + class_path_option << endl;

  const char* main_class_name(argv[2]);
  cout << "Main Class Name: " << main_class_name << endl;

  JavaVMOption options[num_jvm_options];
  options[0].optionString = (char *) class_path_option.c_str();
  options[0].extraInfo = nullptr;

  JavaVMInitArgs jvm_args;
  jvm_args.version = JNI_VERSION_1_8;
  jvm_args.nOptions = num_jvm_options;
  jvm_args.options = options;
  jvm_args.ignoreUnrecognized = false;

  jint err = 0;
  JavaVM *jvm = nullptr;
  JNIEnv *env = nullptr;

  err = JNI_CreateJavaVM(&jvm, reinterpret_cast<void **>(&env), &jvm_args);
  assert(err == 0);
  assert(env != nullptr);
  assert(env->ExceptionCheck() == JNI_FALSE);

  jclass cls = env->FindClass(main_class_name);
  assert(env->ExceptionCheck() == JNI_FALSE);
  assert(cls != nullptr);

  jmethodID mid = env->GetStaticMethodID(cls, "main", "([Ljava/lang/String;)V");
  assert(env->ExceptionCheck() == JNI_FALSE);
  assert(mid != nullptr);

  jclass stringClass{env->FindClass("java/lang/String")};
  assert(env->ExceptionCheck() == JNI_FALSE);
  assert(stringClass != nullptr);

  jobjectArray args = env->NewObjectArray(0, stringClass, nullptr);
  assert(env->ExceptionCheck() == JNI_FALSE);
  assert(args != nullptr);

  env->CallStaticVoidMethod(cls, mid, args);
  assert(env->ExceptionCheck() == JNI_FALSE);
  assert(args != nullptr);

  err = jvm->DestroyJavaVM();
  assert(err == 0);

  return 0;
}
