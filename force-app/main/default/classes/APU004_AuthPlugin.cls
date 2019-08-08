/** 
* @author: Samy TOUBAL
* @date : Creation 18/08/2019
* @description : This class contains authentication plugin for communities
*/
global class APU004_AuthPlugin extends Auth.AuthProviderPluginClass {
  
  // use this URL for the endpoint that the authentication provider calls back to for configuration   
  public String redirectUrl; 
  //private String key;
  //private String secret;
  // application redirection to the website for authentication and authorization
  private String authUrl;
  //private String accessTokenUrl; // uri to get the new access token from concur  using the GET verb
  // api name for the custom metadata type created for this auth provider
  private String customMetadataTypeApiName = 'ExtranetAuthPlugin__mdt';
  //private String userAPIUrl; // api url to access the user in concur
  //private String userAPIVersionUrl; // version of the user api url to access data from concur
               
  /** 
  * @author: Samy TOUBAL
  * @date : Creation 18/08/2019
  * @description : Getter for custom meta data type
  */     
  global String getCustomMetadataType() {
    return customMetadataTypeApiName;
  }
  
  /** 
  * @author: Samy TOUBAL
  * @date : Creation 18/08/2019
  * @description : initiate method used to call login page
  */           
  global PageReference initiate(Map<string,string> authProviderConfiguration, String stateToPropagate) {
    authUrl = authProviderConfiguration.get('URL__c');
    redirectUrl = authProviderConfiguration.get('redirectUrl__c');
    //Here the developer can build up a request of some sort
    //Ultimately they’ll return a URL where we will redirect the user
    System.debug('#### authProviderConfiguration :: '+authProviderConfiguration);
    System.debug('#### authUrl :: '+authUrl);
    String url = authUrl;// + '?client_id='+ key +'&scope=USER,EXPRPT,LIST&redirect_uri='+ redirectUrl + '&state=' + stateToPropagate;
    return new PageReference(url);
  }
        
  global Auth.AuthProviderTokenResponse handleCallback(Map<string,string> authProviderConfiguration, Auth.AuthProviderCallbackState state ) {
     ////Here, the developer will get the callback with actual protocol.  
     ////Their responsibility is to return a new object called AuthProviderToken
     ////This will contain an optional accessToken and refreshToken
     //key = authProviderConfiguration.get('Key__c');
     //secret = authProviderConfiguration.get('Secret__c');
     //accessTokenUrl = authProviderConfiguration.get('Access_Token_Url__c');
     
     //Map<String,String> queryParams = state.queryParameters;
     //String code = queryParams.get('code');
     //String sfdcState = queryParams.get('state');
     
     //HttpRequest req = new HttpRequest();
     //String url = accessTokenUrl+'?code=' + code + '&client_id=' + key + '&client_secret=' + secret;
     //req.setEndpoint(url);
     //req.setHeader('Content-Type','application/xml');
     //req.setMethod('GET');
     
     //Http http = new Http();
     //HTTPResponse res = http.send(req);
     //String responseBody = res.getBody();
     //String token = getTokenValueFromResponse(responseBody, 'Token', null);
                   
    return new Auth.AuthProviderTokenResponse('Concur', 'token', 'refreshToken', 'sfdcState');
  }
    
    
  global Auth.UserData  getUserInfo(Map<string,string> authProviderConfiguration, Auth.AuthProviderTokenResponse response) { 
     //Here the developer is responsible for constructing an Auth.UserData object
     //String token = response.oauthToken;
     //HttpRequest req = new HttpRequest();
     //userAPIUrl = authProviderConfiguration.get('API_User_Url__c');
     //userAPIVersionUrl = authProviderConfiguration.get('API_User_Version_Url__c');
     //req.setHeader('Authorization', 'OAuth ' + token);
     //req.setEndpoint(userAPIUrl);
     //req.setHeader('Content-Type','application/xml');
     //req.setMethod('GET');
     
     //Http http = new Http();
     //HTTPResponse res = http.send(req);
     //String responseBody = res.getBody();
     //String id = getTokenValueFromResponse(responseBody, 'LoginId',userAPIVersionUrl);
     //String fname = getTokenValueFromResponse(responseBody, 'FirstName', userAPIVersionUrl);
     //String lname = getTokenValueFromResponse(responseBody, 'LastName', userAPIVersionUrl);
     //String flname = fname + ' ' + lname;
     //String uname = getTokenValueFromResponse(responseBody, 'EmailAddress', userAPIVersionUrl);
     //String locale = getTokenValueFromResponse(responseBody, 'LocaleName', userAPIVersionUrl);
     Map<String,String> provMap = new Map<String,String>();
     provMap.put('what1', 'noidea1');
     provMap.put('what2', 'noidea2');
     return new Auth.UserData('id', 'fname', 'lname', 'flname', 'uname',
          'what', 'locale', null, 'Concur', null, provMap);
  }
                
      //private String getTokenValueFromResponse(String response, String token, String ns) {
      //    Dom.Document docx = new Dom.Document();
      //    docx.load(response);
      //    String ret = null;

      //    dom.XmlNode xroot = docx.getrootelement() ;
      //    if(xroot != null){
      //       ret = xroot.getChildElement(token, ns).getText();
      //    }
      //    return ret;
      //}  
    
}