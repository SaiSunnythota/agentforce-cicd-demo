public with sharing class SDO_Service_ServicePlannerCtlr {

    @AuraEnabled(cacheable=true)
    public static SDO_Service_Planner_Configuration__c getServicePlanConfiguration(String recordId){
        system.debug('recordid:'+ recordId);
        return [SELECT Id, Topic_Name__c, Summary__c FROM SDO_Service_Planner_Configuration__c WHERE Id =: recordId];  
    }

    @AuraEnabled(cacheable=true)
    public static List<SDO_Service_Planner_Steps__c> getServicePlanSteps(String servicePlanId) {        
        try {
            return [
                SELECT Id, Category__c, Order__c, Step__c
                FROM SDO_Service_Planner_Steps__c
                WHERE Service_Planner_Configuration__c =: servicePlanId];    
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
 
}