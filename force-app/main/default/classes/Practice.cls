public class Practice {
    
    // PMD Violation: AvoidDebugStatements
    // PMD Violation: AvoidGlobalModifier (if this was marked global without need)
    public static void processAccounts() {
        
        // PMD Violation: OperationWithLimitsInLoop (SOQL inside a loop)
        for (Integer i = 0; i < 5; i++) {
            List<Account> accs = [SELECT Id, Name FROM Account LIMIT 1];
            System.debug('Account found: ' + accs); 
        }
        
        // PMD Violation: LocalVariableNamingConventions (Variables should be camelCase)
        String USER_FIRST_NAME = 'John';
        
        // PMD Violation: EmptyIfStmt
        if (USER_FIRST_NAME == 'John') {
            // Nothing here!
        }
        
        // PMD Violation: AvoidDeeplyNestedIfStmts (if we kept nesting)
        // PMD Violation: Apology/Empty Catch Block
        try {
            insert new Contact(); // Will fail due to missing required fields
        } catch (Exception e) {
            // PMD Violation: EmptyCatchBlock (Silently swallowing the error)
        }
    }
}