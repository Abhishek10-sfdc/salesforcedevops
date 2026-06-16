public with sharing class DatatableController {

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList(){
        List<Contact> conList = [SELECT Id,Name,AccountId,Email,Phone,Title,Rank__c,Company__c,Account.Name FROM Contact WHERE AccountId!=null ];
        return conList;
    }
}