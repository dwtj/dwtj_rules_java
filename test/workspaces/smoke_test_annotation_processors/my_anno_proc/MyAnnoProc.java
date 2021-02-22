package my_anno_proc;

import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import javax.annotation.processing.Completion;
import javax.annotation.processing.ProcessingEnvironment;
import javax.annotation.processing.RoundEnvironment;
import javax.annotation.processing.Processor;
import javax.lang.model.element.AnnotationMirror;
import javax.lang.model.element.Element;
import javax.lang.model.element.ExecutableElement;
import javax.lang.model.element.TypeElement;
import javax.lang.model.SourceVersion;
import javax.tools.Diagnostic;

public class MyAnnoProc implements Processor {

  private boolean sourceFileGenerated = false;

  private static final Set<String> SUPPORTED_OPTIONS = Collections.singleton("my_anno_proc.Option");
  private static final Set<String> SUPPORTED_ANNOTATION_TYPES = Collections.singleton("my_anno.MakeMyGenSrc");
  private static final String MYGENSRC_SOURCE_FILE_NAME = "my_anno.MyGenSrc";
  private static final String MYGENSRC_SOURCE_FILE_CONTENTS =
      """
      package my_anno;

      public class MyGenSrc {
        public static void myMethod() {
          System.out.println("Hello, world");
        }
      }
      """;

  private ProcessingEnvironment procEnv;

  @Override
  public void init(ProcessingEnvironment procEnv) {
    procEnv.getMessager().printMessage(Diagnostic.Kind.NOTE, "my_anno_proc.MyAnnoProc#init()");

    this.procEnv = procEnv;
  }

  @Override
  public boolean process(Set<? extends TypeElement> anno, RoundEnvironment roundEnv) {
    procEnv.getMessager().printMessage(Diagnostic.Kind.NOTE, "my_anno_proc.MyAnnoProc#process()");;
    if (sourceFileGenerated) {
      return true;
    }

    var filer = procEnv.getFiler();
    // TODO(dwtj): Consider checking whether there exists a class annotated "@my_anno.MakeMyGenSrc".
    // Then list this as one of the `originatingElements` in this call to `createSourceFile()`.
    try {
      var file = filer.createSourceFile(MYGENSRC_SOURCE_FILE_NAME);
      try (var writer = file.openWriter()) {
          writer.write(MYGENSRC_SOURCE_FILE_CONTENTS);
      }
      sourceFileGenerated = true;
    } catch (IOException ex) {
        throw new RuntimeException("Attempt to create a source file failed.", ex);
    }

    return true;
  }

  @Override
  public Set<String> getSupportedOptions() {
    return SUPPORTED_OPTIONS;
  }

  @Override
  public Iterable<? extends Completion> getCompletions(
      Element elem,
      AnnotationMirror anno,
      ExecutableElement member,
      String userText) {
    return Collections.EMPTY_SET;
  }

  @Override
  public Set<String> getSupportedAnnotationTypes() {
    return SUPPORTED_ANNOTATION_TYPES;
  }

  @Override
  public SourceVersion getSupportedSourceVersion() {
    return SourceVersion.RELEASE_15;
  }
}
