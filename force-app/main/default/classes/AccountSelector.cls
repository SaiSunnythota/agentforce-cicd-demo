/**
 * Selector class for Account queries.
 * Encapsulates all SOQL for Account records.
 * All methods return bulkified results (Lists or Maps).
 */
public inherited sharing class AccountSelector {

    private static String getDefaultFields() {
        return String.join(
            new List<String>{
                'Id',
                'Name',
                'Industry',
                'Phone',
                'BillingCity',
                'BillingState',
                'BillingCountry',
                'OwnerId',
                'CreatedDate',
                'LastModifiedDate'
            },
            ', '
        );
    }

    /**
     * Selects Account records by their Ids.
     * @param recordIds Set of Account Ids to query
     * @return List of Account records matching the provided Ids
     * @example
     * Set<Id> ids = new Set<Id>{ '001xx000003DGbY' };
     * List<Account> results = AccountSelector.selectByIds(ids);
     */
    public static List<Account> selectByIds(Set<Id> recordIds) {
        if (recordIds == null || recordIds.isEmpty()) {
            return new List<Account>();
        }

        return [
            SELECT Id, Name, Industry, Phone, BillingCity,
                   BillingState, BillingCountry, OwnerId,
                   CreatedDate, LastModifiedDate
            FROM Account
            WHERE Id IN :recordIds
            WITH USER_MODE
        ];
    }

    /**
     * Selects Account records as a Map keyed by Id.
     * @param recordIds Set of Account Ids to query
     * @return Map of Id to Account
     */
    public static Map<Id, Account> selectMapByIds(Set<Id> recordIds) {
        return new Map<Id, Account>(selectByIds(recordIds));
    }

    /**
     * Selects Account records by Name (partial match).
     * @param searchName Name or partial name to search for
     * @param recordLimit Maximum number of records to return
     * @return List of matching Account records ordered by Name
     * @example
     * List<Account> results = AccountSelector.selectByName('Acme', 10);
     */
    public static List<Account> selectByName(String searchName, Integer recordLimit) {
        if (String.isBlank(searchName)) {
            return new List<Account>();
        }

        String nameFilter = '%' + String.escapeSingleQuotes(searchName.trim()) + '%';
        return [
            SELECT Id, Name, Industry, Phone, BillingCity,
                   BillingState, BillingCountry, OwnerId,
                   CreatedDate, LastModifiedDate
            FROM Account
            WHERE Name LIKE :nameFilter
            WITH USER_MODE
            ORDER BY Name ASC
            LIMIT :recordLimit
        ];
    }

    /**
     * Selects Account records by Industry.
     * @param industries Set of Industry values to filter on
     * @return List of matching Account records
     * @example
     * List<Account> results = AccountSelector.selectByIndustry(new Set<String>{ 'Technology', 'Finance' });
     */
    public static List<Account> selectByIndustry(Set<String> industries) {
        if (industries == null || industries.isEmpty()) {
            return new List<Account>();
        }

        return [
            SELECT Id, Name, Industry, Phone, BillingCity,
                   BillingState, BillingCountry, OwnerId,
                   CreatedDate, LastModifiedDate
            FROM Account
            WHERE Industry IN :industries
            WITH USER_MODE
            ORDER BY Name ASC
        ];
    }

    /**
     * Selects all Account records with pagination support.
     * @param recordLimit Maximum number of records to return
     * @param offset Number of records to skip
     * @return List of Account records
     * @example
     * List<Account> page1 = AccountSelector.selectAll(50, 0);
     * List<Account> page2 = AccountSelector.selectAll(50, 50);
     */
    public static List<Account> selectAll(Integer recordLimit, Integer offset) {
        return [
            SELECT Id, Name, Industry, Phone, BillingCity,
                   BillingState, BillingCountry, OwnerId,
                   CreatedDate, LastModifiedDate
            FROM Account
            WITH USER_MODE
            ORDER BY Name ASC
            LIMIT :recordLimit
            OFFSET :offset
        ];
    }
}