public class ReqresCalloutController {
    
    public static void getUserList(){
        
        List<Account> accList=new List<Account>();
        Http httpObj=new Http();

        HttpRequest requestObj=new HttpRequest();
        requestObj.setMethod('GET');
        requestObj.setEndpoint('https://reqres.in/api/users?');
        requestObj.setHeader('Content-Type','application/json');
        requestObj.setHeader('x-api-key','reqres_852660f5c7bd47d8ada8caf1c3391ab3');

        HttpResponse responseObj=new HttpResponse();
        responseObj = httpObj.send(requestObj);

        try{
            if(responseObj.getStatusCode() == 200){
                responseWrapper respWrap = new responseWrapper();
                respWrap = (responseWrapper)JSON.deserialize(responseObj.getBody(),responseWrapper.class);
                System.debug('Response Body'+respWrap);
                List<dataRecord> dataList = respWrap.data;
                for(dataRecord dataRec:dataList){
                    Account accNew=new Account();
                    accNew.Name =dataRec.first_name+' API Record';
                    accNew.DunsNumber = String.valueOf(dataRec.id);
                    accList.add(accNew);
                 }   

                 if(!accList.isEmpty()){
                    insert accList;
                 }
            }
        }
        catch(exception ex){
            System.debug('Exception:--'+ex.getMessage());
        }
    }

    public class responseWrapper{
        public Integer page;	//1
        public Integer per_page;	//6
        public Integer total;	//12
        public Integer total_pages;	//2
        public List<dataRecord> data;
        public supportRecord support;
    }
    public class dataRecord {
        public Integer id;	//1
        public String email;	//george.bluth@reqres.in
        public String first_name;	//George
        public String last_name;	//Bluth
        public String avatar;	//https://reqres.in/img/faces/1-image.jpg
    }
    public class supportRecord {
        public String url;	//https://contentcaddy.io?utm_source=reqres&utm_medium=json&utm_campaign=referral
        public String text;	//Tired of writing endless social media content? Let Content Caddy generate it for you.
    }
}