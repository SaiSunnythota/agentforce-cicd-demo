/**
 * Test class for HelloWorldService.
 */
@isTest
private class HelloWorldServiceTest {

    @isTest
    static void shouldReturnPersonalizedGreeting_WhenNameProvided() {
        // Given
        String name = 'Salesforce';

        // When
        Test.startTest();
        String result = HelloWorldService.greet(name);
        Test.stopTest();

        // Then
        Assert.areEqual('Hello, Salesforce!', result, 'Should return personalized greeting');
    }

    @isTest
    static void shouldReturnDefaultGreeting_WhenNameIsNull() {
        // When
        Test.startTest();
        String result = HelloWorldService.greet(null);
        Test.stopTest();

        // Then
        Assert.areEqual('Hello, World!', result, 'Should return default greeting for null input');
    }

    @isTest
    static void shouldReturnDefaultGreeting_WhenNameIsBlank() {
        // When
        Test.startTest();
        String result = HelloWorldService.greet('   ');
        Test.stopTest();

        // Then
        Assert.areEqual('Hello, World!', result, 'Should return default greeting for blank input');
    }

    @isTest
    static void shouldTrimName_WhenNameHasWhitespace() {
        // Given
        String name = '  Developer  ';

        // When
        Test.startTest();
        String result = HelloWorldService.greet(name);
        Test.stopTest();

        // Then
        Assert.areEqual('Hello, Developer!', result, 'Should trim whitespace from name');
    }

    @isTest
    static void shouldReturnGreetingsForAll_WhenMultipleNamesProvided() {
        // Given
        List<String> names = new List<String>{ 'Alice', 'Bob', 'Charlie' };

        // When
        Test.startTest();
        List<String> results = HelloWorldService.greetAll(names);
        Test.stopTest();

        // Then
        Assert.areEqual(3, results.size(), 'Should return greeting for each name');
        Assert.areEqual('Hello, Alice!', results[0], 'First greeting should match');
        Assert.areEqual('Hello, Bob!', results[1], 'Second greeting should match');
        Assert.areEqual('Hello, Charlie!', results[2], 'Third greeting should match');
    }

    @isTest
    static void shouldReturnEmptyList_WhenNamesListIsNull() {
        // When
        Test.startTest();
        List<String> results = HelloWorldService.greetAll(null);
        Test.stopTest();

        // Then
        Assert.areEqual(0, results.size(), 'Should return empty list for null input');
    }

    @isTest
    static void shouldReturnEmptyList_WhenNamesListIsEmpty() {
        // Given
        List<String> names = new List<String>();

        // When
        Test.startTest();
        List<String> results = HelloWorldService.greetAll(names);
        Test.stopTest();

        // Then
        Assert.areEqual(0, results.size(), 'Should return empty list for empty input');
    }
}