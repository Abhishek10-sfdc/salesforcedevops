public with sharing class contactController {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList(String accId){
        List<Contact> conList=[SELECT Id,FirstName,LastName,Email,GenderIdentity,End_Date__c FROM Contact WHERE AccountId!=null AND AccountId =: accId];
        return conList;
    }
}