/**
 * Centralized test data creation factory.
 * All test classes should delegate record creation here.
 */
@IsTest
public class TestDataFactory {

    /**
     * Creates Account records with default field values.
     * @param count Number of Account records to create
     * @param doInsert Whether to insert records into the database
     * @return List of Account records
     */
    public static List<Account> createAccounts(Integer count, Boolean doInsert) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            accounts.add(new Account(
                Name = 'Test Account ' + i,
                Industry = 'Technology',
                Phone = '555-000-' + String.valueOf(i).leftPad(4, '0'),
                BillingCity = 'San Francisco',
                BillingState = 'CA',
                BillingCountry = 'US'
            ));
        }
        if (doInsert) {
            insert accounts;
        }
        return accounts;
    }
}