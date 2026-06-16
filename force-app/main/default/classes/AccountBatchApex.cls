global with sharing class AccountBatchApex implements Database.Batchable<sObject>,Database.stateful {

    Integer accountUpdateCount = 0;
    Integer batchCount = 0;

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id,Name FROM Account WHERE Industry != null AND Type = \'Customer - Direct\'');
    }

    global void execute(Database.BatchableContext BC,List<Account> accList){
        List<Account> accUpdateList =new List<Account>();
        for(Account accRec:accList){
            accRec.NumberOfEmployees = 2200001;
            accountUpdateCount++;
            accUpdateList.add(accRec);
        }
        System.debug('Limits.getQueueableJobs()---->'+Limits.getQueueableJobs());
        if(!accUpdateList.isEmpty()){
            update accUpdateList;
            batchCount++;
        }
    }

    global void finish(Database.BatchableContext BC){
        System.debug('Finish---->accountUpdate'+accountUpdateCount);
        System.debug('Finish---->batchCount'+batchCount);
    }
}