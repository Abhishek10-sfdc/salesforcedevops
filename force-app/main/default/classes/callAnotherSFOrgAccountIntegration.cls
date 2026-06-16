public with sharing class callAnotherSFOrgAccountIntegration {
    
    public static void createAccountOrgB(){

        Http httpObj =new Http();
        HttpRequest reqObj=new HttpRequest();
        reqObj.setEndpoint('https://wise-bear-rwkchi-dev-ed.trailblaze.my.salesforce.com/services/apexrest//createAccountDemo');
        reqObj.setMethod('POST');
        wrapperObj newObj =new wrapperObj();
        newObj.accountName ='AS';
        newObj.accountName ='ASTraining@gmail.com';
        String jsonOutput = JSON.serialize(newObj);
        reqObj.setBody(jsonOutput);
       reqObj.setHeader('Content-Type','application/json');

        HttpResponse respObj =new HttpResponse();
        respObj = httpObj.send(reqObj);

        System.System.debug('respObj---->'+respObj.getStatus());
        System.System.debug('respObj---->'+respObj.getStatusCode());
    }


    public class wrapperObj{
        public String accountName;
        public String websiteName;
    }
}