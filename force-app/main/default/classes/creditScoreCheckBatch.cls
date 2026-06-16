global class creditScoreCheckBatch implements Database.batchable<sObject>,Database.AllowCallouts {
    
    global Database.QueryLocator start(Database.batchableContext BC){
        return Database.getQueryLocator([SELECT Id,Credit_Rating__c,Credit_Score__c,Last_Credit_Check__c,External_Account_Id__c FROM Account WHERE createdDate = LAST_N_DAYS:30])
    }

    global void execute(Database.batchableContext BC, List<Account> accList){
        List<Account> accUpdateList = new List<Account>();
        List<Debug_Logs__c> logList = new List<Debug_Logs__c>();

        Http http = new Http();
        for(Account accRec:accList){
            Httprequest req = new Httprequest();
             req.setMethod('GET');

            req.setEndpoint(
                'callout:CreditBureau/v1/customers/'
                + acc.External_Account_Id__c
                + '/score'
            );
            try{
                Debug_Logs__c newLogRec = new Debug_Logs__c();
                HttpResponse resp = http.send(req);
                newLogRec.Account__c = accRec.Id;
                newLogRec.Status_Code__c = resp.getStatusCode();
                newLogRec.Status__c = 'Success';
                newLogRec.Response__c = resp.getBody();

            }catch(excpetion ex){
                newLogRec.Account__c = accRec.Id;
                newLogRec.Status_Code__c = resp.getStatusCode();
                newLogRec.Status__c = 'Failed';
                newLogRec.Error_Message__c = ex.getMessage();
            }
        }
    }

    global void finish(Database.batchableContext BC){

    }
}