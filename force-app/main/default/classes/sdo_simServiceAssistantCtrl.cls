public class sdo_simServiceAssistantCtrl {
    
    @AuraEnabled(cacheable=true)
    public static SDO_Service_Assistant_Configuration__c getConfiguration(String configurationId){
        SDO_Service_Assistant_Configuration__c selectedConfiguration = [SELECT Name, Id FROM SDO_Service_Assistant_Configuration__c WHERE Id =: configurationId];  
        return selectedConfiguration;
        
    }

    @AuraEnabled(cacheable=true)
    public static String getConfigurationFromParent(String recordId, String objectName){
        String query = 'SELECT Id, SDO_Service_Assistant_Configuration__c FROM ' + objectName + ' WHERE Id = \'' + recordId + '\'';

        List<sObject> records = Database.query(query);

        if(records.size() > 0){
            return (String) records[0].get('SDO_Service_Assistant_Configuration__c');
        }
        else{
            return null;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Agent_Response> getSimulatedPlan(Id recordId) {
        Id configurationId;

        // Case
        if (recordId.getSObjectType() == Case.SObjectType) {
            Case c = [SELECT SDO_Service_Assistant_Configuration__c FROM Case WHERE Id = :recordId];
            configurationId = c.SDO_Service_Assistant_Configuration__c;

            system.debug('Case ID:' + configurationId);
        }
        // MessagingSession
        else if (recordId.getSObjectType() == MessagingSession.SObjectType) {
            MessagingSession ms = [SELECT SDO_Service_Assistant_Configuration__c FROM MessagingSession WHERE Id = :recordId];
            configurationId = ms.SDO_Service_Assistant_Configuration__c;

            system.debug('MessagingSession ID:' + configurationId);
        }
        // VoiceCall
        else if (recordId.getSObjectType() == VoiceCall.SObjectType) {
            VoiceCall vc = [SELECT SDO_Service_Assistant_Configuration__c FROM VoiceCall WHERE Id = :recordId];
            configurationId = vc.SDO_Service_Assistant_Configuration__c;

            system.debug('VoiceCall configuration ID:' + configurationId);
        }

        if (configurationId == null) {
            return new List<Agent_Response>();
        }

        List<Agent_Response> servicePlan = new List<Agent_Response>();
        List<SDO_Service_Assistant_Response__c> responseList = [
            SELECT Id, Response_Type__c, Response_Subtype__c, Order__c, Title__c, Content__c, Card_Icon_Name__c, Loading_Text__c, Loading_Time__c,
                (SELECT Id, Action_Label__c, Action_Type__c, Record_Id__c, Flow_API_Name__c FROM Service_Assistant_Simulated_Actions__r),
                (SELECT Id, Order__c, Type__c, User__c, Text__c, Custom_Event_Info__c, Custom_Event_Icon__c FROM Conversation_Messages__r ORDER BY Order__c ASC)
            FROM SDO_Service_Assistant_Response__c
            WHERE Service_Assistant_Configuration__c = :configurationId
            ORDER BY Order__c ASC
        ];

        system.debug('ResponseList: ' + responseList);

        for (SDO_Service_Assistant_Response__c simResponse : responseList) {
            Agent_Response resp = new Agent_Response();
            resp.id = simResponse.Id;
            resp.order = simResponse.Order__c;
            resp.responseType = simResponse.Response_Type__c;
            resp.responseSubtype = simResponse.Response_Subtype__c;
            resp.title = simResponse.Title__c;
            resp.content = simResponse.Content__c;
            resp.icon = simResponse.Card_Icon_Name__c;
            resp.loadingText = simResponse.Loading_Text__c;
            resp.loadingTime = simResponse.Loading_Time__c;

            // actions
            resp.actions = new List<Agent_Action>();
            for (SDO_Service_Assistant_Simulated_Action__c action : simResponse.Service_Assistant_Simulated_Actions__r) {
                Agent_Action act = new Agent_Action();
                act.id = action.Id;
                act.label = action.Action_Label__c;
                act.type = action.Action_Type__c;
                act.recordId = action.Record_Id__c;
                act.flowApiName = action.Flow_API_Name__c;
                resp.actions.add(act);
            }

            // messages
            resp.messages = new List<Message>();
            for (SDO_Service_Assistant_Message__c message : simResponse.Conversation_Messages__r) {
                Message msg = new Message();
                msg.id = message.Id;
                msg.order = message.Order__c;
                msg.type = message.Type__c;
                msg.user = message.User__c;
                msg.text = message.Text__c;
                msg.info = message.Custom_Event_Info__c;
                msg.icon = message.Custom_Event_Icon__c;

                resp.messages.add(msg);
            }
            servicePlan.add(resp);
        }

        system.debug('servicePlan: ' + servicePlan);

        return servicePlan;
    }

    
    @AuraEnabled(cacheable=true)
    public static Agent_Response getResponsePreview(Id responseId) {
        
        SDO_Service_Assistant_Response__c simResponse = [
            SELECT Id, Response_Type__c, Response_Subtype__c, Order__c, Title__c, Content__c, Card_Icon_Name__c,
                (SELECT Id, Action_Label__c, Action_Type__c, Record_Id__c, Flow_API_Name__c FROM Service_Assistant_Simulated_Actions__r),
                (SELECT Id, Order__c, Type__c, User__c, Text__c, Custom_Event_Info__c, Custom_Event_Icon__c FROM Conversation_Messages__r ORDER BY Order__c ASC)
            FROM SDO_Service_Assistant_Response__c
            WHERE Id = :responseId LIMIT 1
        ];
       
        Agent_Response resp = new Agent_Response();
        resp.id = simResponse.Id;
        resp.order = simResponse.Order__c;
        resp.responseType = simResponse.Response_Type__c;
        resp.responseSubtype = simResponse.Response_Subtype__c;
        resp.title = simResponse.Title__c;
        resp.content = simResponse.Content__c;
        resp.icon = simResponse.Card_Icon_Name__c;

        resp.actions = new List<Agent_Action>();
        for (SDO_Service_Assistant_Simulated_Action__c action : simResponse.Service_Assistant_Simulated_Actions__r){
            Agent_Action act = new Agent_Action();
            act.id = action.Id;
            act.label = action.Action_Label__c;
            act.type = action.Action_Type__c;
            act.recordId = action.Record_Id__c;
            act.flowApiName = action.Flow_API_Name__c;
            resp.actions.add(act);
        }

        resp.messages = new List<Message>();
        for (SDO_Service_Assistant_Message__c message : simResponse.Conversation_Messages__r) {
            Message msg = new Message();
            msg.id = message.Id;
            msg.order = message.Order__c;
            msg.type = message.Type__c;
            msg.user = message.User__c;
            msg.text = message.Text__c;
            msg.info = message.Custom_Event_Info__c;
            msg.icon = message.Custom_Event_Icon__c;

            resp.messages.add(msg);
        }

        return resp;
    }

    public class Agent_Response {
        @AuraEnabled public Id id { get; set; }
        @AuraEnabled public Decimal order { get; set; }
        @AuraEnabled public String title { get; set; }
        @AuraEnabled public String content { get; set; }
        @AuraEnabled public String responseType { get; set; }
        @AuraEnabled public String responseSubtype { get; set; }
        @AuraEnabled public String loadingText { get; set; }
        @AuraEnabled public Decimal loadingTime { get; set; }
        @AuraEnabled public String icon { get; set; }
        @AuraEnabled public List<Agent_Action> actions { get; set; }
        @AuraEnabled public List<Message> messages { get; set; }
    }

    public class Agent_Action {
        @AuraEnabled public Id id { get; set; }
        @AuraEnabled public String label { get; set; }
        @AuraEnabled public String type { get; set; }
        @AuraEnabled public String recordId { get; set; }
        @AuraEnabled public String flowApiName { get; set; }
    }
    
    public class Message {
        @AuraEnabled public Id id { get; set; }
        @AuraEnabled public Decimal order { get; set; }
        @AuraEnabled public String type { get; set; }
        @AuraEnabled public String user { get; set; }
        @AuraEnabled public String text { get; set; }
        @AuraEnabled public String info { get; set; }
        @AuraEnabled public String icon { get; set; }
    }
}