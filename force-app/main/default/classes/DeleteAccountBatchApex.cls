global with sharing class DeleteAccountBatchApex implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        Date oneYearPastDate = Date.today().addDays(-365);
        return Database.getQueryLocator('SELECT Id from Account WHERE End_Date__c < oneYearPastDate');
    }

    global void execute(Database.BatchableContext BC,List<Account> accList){
        if(!accList.isEmpty()){
            Delete accList;
        }
    }

    global void finish(Database.BatchableContext BC){
        System.debug('Finish---->');
    }
}