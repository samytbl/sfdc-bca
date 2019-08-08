/** 
* @author: Adolphe SONKO
* @date : Creation 25/07/2019
* @description : This class contains authentication plugin for communities
*/
global class APU003_AuthPlugin extends Auth.AuthProviderPluginClass {
  
  // use this URL for the endpoint that the authentication provider calls back to for configuration   
  public String redirectUrl; 
  private String clientId;
  private String clientSecret;
  private String scope;
  private String accessTokenUrl;
    
  // application redirection to the website for authentication and authorization
  private String authorizeEndpointURL;
  //private String accessTokenUrl; // uri to get the new access token from concur  using the GET verb
  // api name for the custom metadata type created for this auth provider
  private String customMetadataTypeApiName = 'Google_Auth_Plugin__mdt';
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
    authorizeEndpointURL = authProviderConfiguration.get('AuthorizeEndpointURL__c');
    redirectUrl = authProviderConfiguration.get('RedirectURL__c');
    clientId = authProviderConfiguration.get('ConsumerKey__c');
    clientSecret = authProviderConfiguration.get('ConsumerSecret__c');
    scope = authProviderConfiguration.get('Scope__c');
    //Here the developer can build up a request of some sort
    //Ultimately they’ll return a URL where we will redirect the user
    System.debug('#### authProviderConfiguration :: '+authProviderConfiguration);
    System.debug('#### authUrl :: '+authorizeEndpointURL);
    System.debug('#### redirectUrl :: '+redirectUrl);
    System.debug('#### clientId :: '+clientId);
    String url = authorizeEndpointURL + '?client_id='+ clientId +'&scope='+scope+'&redirect_uri='+ redirectUrl + '&state=' + stateToPropagate+'&response_type=code';
  //  String url = authorizeEndpointURL + '?client_id='+ clientId+'&secret='+ clientSecret +'&scope='+scope+'&redirect_uri='+ redirectUrl + '&state=' + stateToPropagate;
      System.debug('#### authUrl :: '+url);
    return new PageReference(url);
  }
        
  global Auth.AuthProviderTokenResponse handleCallback(Map<string,string> authProviderConfiguration, Auth.AuthProviderCallbackState state ) {
     ////Here, the developer will get the callback with actual protocol.  
     ////Their responsibility is to return a new object called AuthProviderToken
     ////This will contain an optional accessToken and refreshToken
     clientId = authProviderConfiguration.get('ConsumerKey__c');
     clientSecret = authProviderConfiguration.get('ConsumerSecret__c');
     accessTokenUrl = authProviderConfiguration.get('TokenEndpointURL__c');
     redirectUrl = authProviderConfiguration.get('RedirectURL__c');
     scope = authProviderConfiguration.get('Scope__c');
     
     Map<String,String> queryParams = state.queryParameters;
     String code = queryParams.get('code');
     String sfdcState = queryParams.get('state');
     System.debug('#### code :: '+code);
     System.debug('#### sfdcState :: '+sfdcState);
      
     HttpRequest req = new HttpRequest();
     String url = accessTokenUrl + '?client_id='+ clientId +'&grant_type=authorization_code'+'&code='+code+'&client_secret='+clientSecret+'&redirect_uri='+ redirectUrl;
     //String url = accessTokenUrl+'?code=' + code + '&client_id=' + key + '&client_secret=' + secret;
      req.setEndpoint(url);
      System.debug('#### url :: '+url);
     req.setHeader('Content-Type','x-www-form-urlencoded');
     //req.setHeader('Content-Type','application/xml');
     req.setHeader('Content-Length','0');
     req.setMethod('POST');
     String requestBody = 'client_id='+ clientId +'&grant_type=authorization_code'+'&code='+code+'&client_secret='+clientSecret;
   //  req.setBody(requestBody) ;
     
     Http http = new Http();
     HTTPResponse res = http.send(req);
     String responseBody = res.getBody();
    // String token = getTokenValueFromResponse(responseBody, 'Token', null);
      System.debug('#### responseBody : '+responseBody);
     
      System.debug('#### I am here');
      System.debug('#### request : '+req);

    return new Auth.AuthProviderTokenResponse('Google', accessTokenUrl, 'refreshToken', sfdcState);
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
     
      System.debug('#### getUserInfo I am here');
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