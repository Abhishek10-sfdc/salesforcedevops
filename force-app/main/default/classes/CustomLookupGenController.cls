public with sharing class CustomLookupGenController {
    
    @AuraEnabled(cacheable=true)
    public static List<sObject> getSobjectList(String objectName,String searchKeyword){
        List<sObject> sobjList =new List<sObject>();
        if(String.isNotBlank(searchKeyword)){
            String key = '%'+searchKeyword+'%';
            String dynQuery = 'SELECT Id,Name FROM '+objectName+' WHERE Name LIKE : key';
            sobjList = Database.query(dynQuery);
        }
        return sobjList;
    }
}