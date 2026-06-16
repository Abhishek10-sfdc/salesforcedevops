@RestResource(UrlMapping='/createReqresUsers/')
global class ReqresRestController {

    @HttpPost
    global static void createReqUsers(){

        //Initiate Resquest & Request Params
        RestRequest reqObj=RestContext.request;
        RestResponse respObj=RestContext.response;

        //Parse JSON
        String reqBody = reqObj.requestBody.toString();
        userWrapper userDataWrapper= (userWrapper) JSON.deserialize(reqBody, userWrapper.class);

        if(userDataWrapper != null && userDataWrapper?.data?.size()>0){
            List<Contact> conList=new List<Contact>();
            List<dataRec> createUserData = userDataWrapper.data;

            for(dataRec dataObj:createUserData){
                Contact conRec=new Contact(LastName=dataObj.last_name);
                conList.add(conRec);
            }

            if(!conList.isEmpty()){
                Insert conList;
            }
        }
    }

    public class userWrapper{
        public Integer page;	//1
        public Integer per_page;	//6
        public Integer total;	//12
        public Integer total_pages;	//2
        public List<dataRec> data;
        public supportData support;
    }   

    public class dataRec {
		public Integer id;	//1
		public String email;	//george.bluth@reqres.in
		public String first_name;	//George
		public String last_name;	//Bluth
		public String avatar;	//https://reqres.in/img/faces/1-image.jpg
	}
	public class supportData {
		public String url;	//https://contentcaddy.io?utm_source=reqres&utm_medium=json&utm_campaign=referral
		public String text;	//Tired of writing endless social media content? Let Content Caddy generate it for you.
	}
}