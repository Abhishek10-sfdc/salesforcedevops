public with sharing class customLookupController {
    
    @AuraEnabled(cacheable=true)
    public static List<sObject> searchLookupRecord(String objectApiName,String searchKey){
        List<sObject> sobjectList = new List<sObject>();
        if(String.isNotBlank(searchKey)){
            String keyValue = '%'+searchKey+'%';
            String queryStr = 'SELECT Id,Name FROM '+objectApiName+' WHERE Name LIKE : keyValue';
            sobjectList = Database.query(queryStr);
        }
        return sobjectList;
    }
}