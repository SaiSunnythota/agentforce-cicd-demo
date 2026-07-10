/**
 * Test class for AccountSelector.
 * Validates query methods with bulk data (251+ records).
 */
@IsTest
private class AccountSelectorTest {

    @TestSetup
    static void setupTestData() {
        List<Account> accounts = TestDataFactory.createAccounts(251, true);
    }

    @IsTest
    static void shouldReturnAccounts_WhenValidIds() {
        // Given
        List<Account> accounts = [SELECT Id FROM Account];
        Set<Id> accountIds = new Map<Id, Account>(accounts).keySet();

        // When
        Test.startTest();
        List<Account> results = AccountSelector.selectByIds(accountIds);
        Test.stopTest();

        // Then
        Assert.areEqual(251, results.size(), 'Should return all 251 accounts');
        Assert.isNotNull(results[0].Name, 'Name field should be populated');
        Assert.isNotNull(results[0].Industry, 'Industry field should be populated');
    }

    @IsTest
    static void shouldReturnEmptyList_WhenNullIds() {
        // When
        Test.startTest();
        List<Account> results = AccountSelector.selectByIds(null);
        Test.stopTest();

        // Then
        Assert.areEqual(0, results.size(), 'Should return empty list for null input');
    }

    @IsTest
    static void shouldReturnEmptyList_WhenEmptyIds() {
        // When
        Test.startTest();
        List<Account> results = AccountSelector.selectByIds(new Set<Id>());
        Test.stopTest();

        // Then
        Assert.areEqual(0, results.size(), 'Should return empty list for empty set');
    }

    @IsTest
    static void shouldReturnMap_WhenValidIds() {
        // Given
        List<Account> accounts = [SELECT Id FROM Account LIMIT 5];
        Set<Id> accountIds = new Map<Id, Account>(accounts).keySet();

        // When
        Test.startTest();
        Map<Id, Account> results = AccountSelector.selectMapByIds(accountIds);
        Test.stopTest();

        // Then
        Assert.areEqual(5, results.size(), 'Map should contain 5 entries');
        for (Id accountId : accountIds) {
            Assert.isTrue(results.containsKey(accountId), 'Map should contain queried Id');
        }
    }

    @IsTest
    static void shouldReturnAccounts_WhenNameMatches() {
        // When
        Test.startTest();
        List<Account> results = AccountSelector.selectByName('Test Account', 10);
        Test.stopTest();

        // Then
        Assert.isTrue(results.size() > 0, 'Should return matching accounts');
        Assert.isTrue(results.size() <= 10, 'Should respect limit');
    }

    @IsTest
    static void shouldReturnEmptyList_WhenNameIsBlank() {
        // When
        Test.startTest();
        List<Account> results = AccountSelector.selectByName('', 10);
        Test.stopTest();

        // Then
        Assert.areEqual(0, results.size(), 'Should return empty list for blank name');
    }

    @IsTest
    static void shouldReturnEmptyList_WhenNameIsNull() {
        // When
        Test.startTest();
        List<Account> results = AccountSelector.selectByName(null, 10);
        Test.stopTest();

        // Then
        Assert.areEqual(0, results.size(), 'Should return empty list for null name');
    }

    @IsTest
    static void shouldReturnAccounts_WhenIndustryMatches() {
        // When
        Test.startTest();
        List<Account> results = AccountSelector.selectByIndustry(new Set<String>{ 'Technology' });
        Test.stopTest();

        // Then
        Assert.areEqual(251, results.size(), 'Should return all Technology accounts');
        for (Account account : results) {
            Assert.areEqual('Technology', account.Industry, 'Industry should be Technology');
        }
    }

    @IsTest
    static void shouldReturnEmptyList_WhenIndustrySetIsNull() {
        // When
        Test.startTest();
        List<Account> results = AccountSelector.selectByIndustry(null);
        Test.stopTest();

        // Then
        Assert.areEqual(0, results.size(), 'Should return empty list for null industries');
    }

    @IsTest
    static void shouldReturnEmptyList_WhenIndustrySetIsEmpty() {
        // When
        Test.startTest();
        List<Account> results = AccountSelector.selectByIndustry(new Set<String>());
        Test.stopTest();

        // Then
        Assert.areEqual(0, results.size(), 'Should return empty list for empty industries');
    }

    @IsTest
    static void shouldReturnPaginatedAccounts_WhenSelectAll() {
        // When
        Test.startTest();
        List<Account> page1 = AccountSelector.selectAll(50, 0);
        List<Account> page2 = AccountSelector.selectAll(50, 50);
        Test.stopTest();

        // Then
        Assert.areEqual(50, page1.size(), 'First page should have 50 records');
        Assert.areEqual(50, page2.size(), 'Second page should have 50 records');
        Assert.areNotEqual(page1[0].Id, page2[0].Id, 'Pages should not overlap');
    }

    @IsTest
    static void shouldReturnOrderedByName_WhenSelectAll() {
        // When
        Test.startTest();
        List<Account> results = AccountSelector.selectAll(10, 0);
        Test.stopTest();

        // Then
        for (Integer i = 1; i < results.size(); i++) {
            Assert.isTrue(
                results[i - 1].Name <= results[i].Name,
                'Results should be ordered by Name ascending'
            );
        }
    }
}