package attrs.args;

public class ExpectNumArgs {
    public static void main(String[] args) {
        if (args.length == 0) {
            System.exit(0);
        }

        int numArgs = Integer.parseInt(args[0]);
        if (args.length != numArgs) {
            System.err.println("Wrong number of arguments found.");
            System.err.println("Expected number of args: " + numArgs);
            System.err.println("Actual number of args: " + args.length);
            System.exit(-1);
        } else {
            for (String arg : args) {
                System.out.println(arg);
            }
            System.exit(0);
        }
    }
}
