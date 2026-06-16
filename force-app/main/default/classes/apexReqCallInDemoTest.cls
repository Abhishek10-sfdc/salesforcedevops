@RestResource(urlMapping='/createReqUser')
global class apexReqCallInDemoTest {
   
    @HttpPost
    global static void createAccountUsers(){

        RestRequest req = RestContext.request;
        RestResponse resp= RestContext.response;

        String reqBody = req.requestBody.toString();
        requestWrapper reqObj = (requestWrapper)JSON.deserialize(reqBody,requestWrapper.class);

        if(reqObj != null && reqObj.data?.size() > 0){
            List<Account> accList =new List<Account>();
            List<dataRec> dataList = reqObj.data;

            for(dataRec dataRecord:dataList){
                Account newAcc =new Account();
                newAcc.Name = dataRecord.first_name+'-<>-'+dataRecord.last_name;
                newAcc.website = dataRecord.email;
                accList.add(newAcc);
            }

            if(!accList.isEmpty()){
                insert accList;
            }
        }
    }


    public class requestWrapper{
	public Integer page;	//1
	public Integer per_page;	//6
	public Integer total;	//12
	public Integer total_pages;	//2
	public List<dataRec> data;
	public supportRec support;
    }

    public class dataRec {
		public Integer id;	//1
		public String email;	//george.bluth@reqres.in
		public String first_name;	//George
		public String last_name;	//Bluth
		public String avatar;	//https://reqres.in/img/faces/1-image.jpg
	}
	public class supportRec {
		public String url;	//https://contentcaddy.io?utm_source=reqres&utm_medium=json&utm_campaign=referral
		public String text;	//Tired of writing endless social media content? Let Content Caddy generate it for you.
	}
}