public with sharing class CustomerStatusCheckBatch implements Database.Batchable<sObject>, Database.Stateful {

    public Integer totalProcessedRecords = 0;
    public Integer batchSize = 0;
   
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id,Name,Active__c,Last_Order_Date__c FROM Account WHERE 
                                        Active__c = 'Yes' AND Last_Order_Date__c != NULL 
                                        AND (Last_Order_Date__c > :System.today() OR Last_Order_Date__c < :System.today().addDays(-365))]);
    }

    public void execute(Database.BatchableContext BC, List<Account> accList){
        List<Account> accUpdateList = new List<Account>();
        for(Account accRec: accList){
            if(accRec.Active__c == 'Yes' && (accRec.Last_Order_Date__c > System.today() || accRec.Last_Order_Date__c < System.today().addDays(-365))){
                accRec.Active__c = 'Blocked';
                accUpdateList.add(accRec);
                totalProcessedRecords++;
            }
        }

        if(!accUpdateList.isEmpty()){
            update accUpdateList;
        }
    }

    public void finish(Database.BatchableContext BC){
        System.debug('Total Processed Records: ' + totalProcessedRecords);
        AsyncApexJob job =  [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        System.debug('Total JobItemsProcessed Records: ' + job.JobItemsProcessed);

        // 2. Prepare the email message
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // Set recipient (in this case, the person who started the job)
        String[] toAddresses = new String[] {job.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        
        // Set Subject and Body
        mail.setSubject('Batch Process ' + job.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + job.TotalJobItems + 
                            ' batches with ' + job.NumberOfErrors + ' failures.');

        // 3. Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}