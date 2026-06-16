public with sharing class addMultipleContactController {
    
    @AuraEnabled
    public static responseWrapper createContacts(List<Contact> conList){
        responseWrapper respWrap=new responseWrapper();
        try{
            insert conList;
            respWrap.isSuccess=true;
        }
        catch(exception ex){
            respWrap.isSuccess=false;
            respWrap.errorMessage=ex.getMessage();
        }
        return respWrap;
    }

    public class responseWrapper{
        @AuraEnabled public boolean isSuccess;
        @AuraEnabled public String errorMessage;
    }
}