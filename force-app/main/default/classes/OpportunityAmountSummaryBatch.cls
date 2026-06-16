public with sharing class OpportunityAmountSummaryBatch implements Database.batchable<sObject>, Database.Stateful {
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id FROM Account]);
    }

    public void execute(Database.BatchableContext BC, List<Account> accList){
        Set<Id> accIds = new Set<Id>();
        Map<Id,decimal> accountToRevenueMap = new Map<Id,decimal>();
        List<Account> accListUpdate = new List<Account>();
        for(Account accRec:accList){
            accIds.add(accRec.Id);
        }

        if(!accIds.isEmpty()){
            for(AggregateResult aggRes:[SELECT AccountId, SUM(Amount) OppAmount FROM Opportunity WHERE AccountId IN : accIds AND StageName = 'Closed Won' AND Amount != NULL GROUP BY AccountId]){
                accountToRevenueMap.put( (Id)aggRes.get('AccountId'), (Decimal)aggRes.get('OppAmount'));
            }   

            for(Id accKeyId: accountToRevenueMap.keySet()){
                Account accRecord = new Account();
                accRecord.Id = accKeyId;
                accRecord.AnnualRevenue = accountToRevenueMap.get(accKeyId);
                accListUpdate.add(accRecord);
            }

            if(!accListUpdate.isEmpty()){
                Database.update(accListUpdate, false);
            }
        }
    }

    public void finish(Database.BatchableContext BC){

    }
}