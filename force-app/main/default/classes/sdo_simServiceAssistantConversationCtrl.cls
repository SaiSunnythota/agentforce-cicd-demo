public class sdo_simServiceAssistantConversationCtrl {
    @AuraEnabled(cacheable=true)
    public static List<Message> getPreloadedMessages(Id recordId) {
        MessagingSession ms = [SELECT SDO_Service_Assistant_Configuration__c FROM MessagingSession WHERE Id = :recordId];
        Id configurationId = ms.SDO_Service_Assistant_Configuration__c;
    
        if(configurationId == null){
            return null;
        }
        
        List<SDO_Service_Assistant_Message__c> messageList = [
            SELECT Id, Order__c, Type__c, User__c, Text__c, Custom_Event_Info__c, Custom_Event_Icon__c
            FROM SDO_Service_Assistant_Message__c
            WHERE Service_Assistant_Configuration__c = :configurationId
            ORDER BY Order__c ASC
        ];

        List<Message> messages = new List<Message>();

        for (SDO_Service_Assistant_Message__c message : messageList) {
            Message msg = new Message();
            msg.id = message.Id;
            msg.order = message.Order__c;
            msg.type = message.Type__c;
            msg.user = message.User__c;
            msg.text = message.Text__c;
            msg.info = message.Custom_Event_Info__c;
            msg.icon = message.Custom_Event_Icon__c;

            messages.add(msg);
        }

        return messages;
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