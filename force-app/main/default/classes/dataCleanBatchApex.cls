global with sharing class dataCleanBatchApex implements Database.Batchable<sObject>, Database.stateful {

    Integer deleteRecordCount = 0;
    Integer batchCount = 0;
    String lastPhoneNo = '';
    
    global database.QueryLocator start(Database.batchableContext BC){
        return Database.getQueryLocator('Select Phone, count(Id) from Account Where Phone != null group by Phone Having count(Id) > 1');
    }

    global void execute(Database.batchableContext BC, List<AggregateResult> accList){
        Set<String> phoneNoSet = new Set<String>();
        Map<String, Id> phoneToAccIdMap = new Map<String, Id>();
        List<Account> accountsToDelete = new List<Account>();

        for(AggregateResult ar : accList){
            phoneNoSet.add(String.valueOf(ar.get('Phone')));
        }

        for(Account accRec:[SELECT Id,Phone,End_Date__c FROM Account WHERE Phone IN:phoneNoSet order by Phone, End_Date__c ASC]){
            if(!phoneToAccIdMap.containskey(accRec.Phone) && !lastPhoneNo.contains(accRec.Phone)){
                lastPhoneNo = accRec.Phone;
                phoneToAccIdMap.put(accRec.Phone,accRec.Id);
            }
            else{
                deleteRecordCount++;
                accountsToDelete.add(accRec);
            }
        }

        batchCount++;

        if(!accountsToDelete.isEmpty()){
            delete accountsToDelete;
        }
    }

    global void finish(Database.batchableContext BC){
        System.debug('deleteRecordCount---->'+deleteRecordCount);
        System.debug('batchCount---->'+batchCount);
    }
}