package attrs.data;

import java.util.List;
import static java.nio.charset.StandardCharsets.UTF_8;
import java.nio.file.Paths;
import java.nio.file.Files;
import java.io.IOException;

class ReadEachLine {
    public static void main(String[] args) {
        try {
            List<String> lines = Files.readAllLines(Paths.get(args[0]), UTF_8);
            for (String line : lines) {
                System.out.println(line);
            }
        } catch (IOException ex) {
            ex.printStackTrace();
            System.exit(1);
        }
    }
}
