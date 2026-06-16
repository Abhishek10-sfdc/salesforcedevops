public with sharing class apexReqresCalloutDemoTest {
    
    public static void getReqresUserData(){

        Http httpObj =new Http();
        Httprequest httpReq = new HttpRequest();
        httpReq.setEndpoint('https://reqres.in/api/users?page=1');
        httpReq.setMethod('GET');
        httpReq.setHeader('x-api-key','reqres_852660f5c7bd47d8ada8caf1c3391ab3');

        HttpResponse httpResp = new HttpResponse();
        httpResp = httpObj.send(httpReq);

        System.System.debug('Response---->'+httpResp.getBody());
        if(httpResp.getStatusCode() == 200 && httpResp.getStatus() == 'Success'){
            List<Account> accNewList = new List<Account>();
            responseWrapper respWrapObj =new responseWrapper();
            respWrapObj = (responseWrapper)JSON.deserialize(httpResp.getBody(),responseWrapper.class);

            if(respWrapObj != null){
                List<dataWrapper> dataWarpperList =new List<dataWrapper>();
                dataWarpperList = respWrapObj.data;
                for(dataWrapper dataRec:dataWarpperList){
                    Account newAcc =new Account();
                    newAcc.Name = dataRec.first_name+'----'+dataRec.last_name;
                    newAcc.Site = dataRec.email;
                    accNewList.add(newAcc);
                }

                if(!accNewList.isEmpty()){
                    insert accNewList;
                }
            }
        }
    }


    public class responseWrapper{
        public Integer page;	//1
        public Integer per_page;	//6
        public Integer total;	//12
        public Integer total_pages;	//2
        public List<dataWrapper> data;
        public supportWrapper support;
    }

    public class dataWrapper {
		public Integer id;	//1
		public String email;	//george.bluth@reqres.in
		public String first_name;	//George
		public String last_name;	//Bluth
		public String avatar;	//https://reqres.in/img/faces/1-image.jpg
	}
	public class supportWrapper {
		public String url;	//https://contentcaddy.io?utm_source=reqres&utm_medium=json&utm_campaign=referral
		public String text;	//Tired of writing endless social media content? Let Content Caddy generate it for you.
	}
}