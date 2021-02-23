package attrs.javac_flags.test_anno;

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

/**
 * This annotation processor helps test that the `javac_args` attribute is
 * working by failing if a certain option's isn't set or if this option's value
 * isn't as expected.
 *
 * To help avoid false positives, this annotation processor also creates a
 * small Java source file which is used in the test, since this ensures that
 * the annotation processor actually runs during the test.
 */
public class TestAnnoProc implements Processor {

  private boolean sourceFileGenerated = false;

  private static final String EXPECTED_OPTION_NAME = "attrs.javac_flags.test_anno.TestOption";
  private static final Set<String> SUPPORTED_OPTIONS = Collections.singleton(EXPECTED_OPTION_NAME);
  private static final String EXPECTED_OPTION_VALUE = "Hello, world!";
  private static final Set<String> SUPPORTED_ANNOTATION_TYPES = Collections.singleton("attrs.javac_flags.test_anno.TestAnno");
  private static final String TESTGENSRC_SOURCE_FILE_NAME = "attrs.javac_flags.test_anno.TestGenSrc";
  private static final String TESTGENSRC_SOURCE_FILE_CONTENTS =
      """
      package attrs.javac_flags.test_anno;

      public class TestGenSrc {
        public static void myMethod() {
          System.out.println("Hello, world");
        }
      }
      """;

  private ProcessingEnvironment procEnv;

  private static void checkForExpectedOption(ProcessingEnvironment procEnv) {
    var opts = procEnv.getOptions();
    if (! opts.containsKey(EXPECTED_OPTION_NAME)) {
      throw new RuntimeException("Annotation processor could not find the expected option: " + EXPECTED_OPTION_NAME);
    }
    var val = opts.get(EXPECTED_OPTION_NAME);
    if (! EXPECTED_OPTION_VALUE.equals(val)) {
      throw new RuntimeException("Annotation processor expected an option %s=%s, but value was actually %s".formatted(
        EXPECTED_OPTION_NAME,
        EXPECTED_OPTION_VALUE,
        val
      ));
    }
  }

  @Override
  public void init(ProcessingEnvironment procEnv) {
    this.procEnv = procEnv;

    procEnv.getMessager().printMessage(Diagnostic.Kind.NOTE, "TestAnnoProc#init()");
    checkForExpectedOption(procEnv);
  }

  @Override
  public boolean process(Set<? extends TypeElement> anno, RoundEnvironment roundEnv) {
    procEnv.getMessager().printMessage(Diagnostic.Kind.NOTE, "TestAnnoProc#process()");;
    if (sourceFileGenerated) {
      return true;
    }

    var filer = procEnv.getFiler();
    // TODO(dwtj): Consider checking whether there exists a class annotated "@my_anno.MakeMyGenSrc".
    // Then list this as one of the `originatingElements` in this call to `createSourceFile()`.
    try {
      var file = filer.createSourceFile(TESTGENSRC_SOURCE_FILE_NAME);
      try (var writer = file.openWriter()) {
          writer.write(TESTGENSRC_SOURCE_FILE_CONTENTS);
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
