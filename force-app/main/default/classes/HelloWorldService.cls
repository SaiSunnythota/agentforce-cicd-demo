/**
 * Basic service class demonstrating core Apex patterns.
 */
public with sharing class HelloWorldService {

    /**
     * Returns a greeting message for the given name.
     * @param name The name to greet
     * @return A personalized greeting string
     * @example
     * String greeting = HelloWorldService.greet('World');
     * // Returns: 'Hello, World!'
     */
    public static String greet(String name) {
        if (String.isBlank(name)) {
            return 'Hello, World!';
        }
        return 'Hello, ' + name.trim() + '!';
    }

    /**
     * Returns greeting messages for a list of names.
     * @param names The names to greet
     * @return A list of personalized greetings
     */
    public static List<String> greetAll(List<String> names) {
        List<String> greetings = new List<String>();
        if (names == null || names.isEmpty()) {
            return greetings;
        }
        for (String name : names) {
            greetings.add(greet(name));
        }
        return greetings;
    }
}