/** 
* @author: Adolphe SONKO
* @date : Création 17/06/2019
* @date : Modification 05/08/2019
* @description : this Class allow to manage Case business entity data preparation .
*/
public class EM002_Case {

    private static String CLASS_NAME = 'EM002_Case';
    private static String HTTP_METHOD_GET = 'GET';
    private static String HTTP_METHOD_POST = 'POST';
    private static String GET_DOCNUM_FILES = system.label.WS_Doc_Num_GET_Files_API_v1 ;
    private static String POST_DOCNUM_FILES = system.label.WS_Sivit_Ressource_API_v1 ;
    private static String CONTENT_TYPE = 'application/json';
    
    
   /**
    * @auteur :Adolphe SONKO
    * @date : Création 02/08/2019
    * @date : Modification 05/08/2019
    * @description : This method creates a http request to request vehicule infos from Sivit
    * @param : DocNum__c param_setting This parameter is the base URL parameter.
    * @param : String requestBody This parameter is the body of the request 
    * @param : String entityName   This parameter is the storeName or country 
    * @return : HttpRequest The request
    */
    public static HttpRequest getDocNumFiles(DocNum__c param_setting, String numDos){
      
      String methodName = 'getDocNumFiles';
      
      ObjectUtil.debugLogBegin(CLASS_NAME, methodName , '[param_setting] : ' + param_setting);
      
      HttpRequest request = getDocNumFiles(param_setting, HTTP_METHOD_GET, GET_DOCNUM_FILES, numDos);
        
      ObjectUtil.debugLogEnd(CLASS_NAME, methodName, '[request] : ' + request);
      return request;
    }
    
   /**
    * @auteur :Adolphe SONKO
    * @date : Création 02/08/2019
    * @date : Modification 05/08/2019
    * @description : This method creates a http request to request vehicule infos from Sivit
    * @param : DocNum__c param_setting This parameter is the Mulesoft Doc Num base URL parameter.
    * @param : String httpMethod   This parameter is the http Method 
    * @param : String ExpectedWebService   This parameter is the rest endpoint 
    * @return : HttpRequest The request
    */
    public static HttpRequest getDocNumFiles(DocNum__c param_setting, String httpMethod, String ExpectedWebService, String numDos){
      
       String methodName = 'getDocNumFiles';
       ObjectUtil.debugLogBegin(CLASS_NAME, methodName , '[param_setting] : ' + param_setting);
       ObjectUtil.debugLogBegin(CLASS_NAME, methodName , '[httpMethod] : ' + httpMethod);
      
       HttpRequest request = new HttpRequest();
       request.setEndpoint(param_setting.BaseURL__c  + ExpectedWebService + numDos);
       request.setMethod(httpMethod);
       request.setHeader('Content-Type', CONTENT_TYPE);
       request.setTimeout(120000); 

       ObjectUtil.debugLogEnd(CLASS_NAME, methodName, '[request] : ' + request);
       return request;
    }
    
    
    /**
    * @auteur :Adolphe SONKO
    * @date : Création 02/08/2019
    * @date : Modification 02/08/2019
    * @description : This method creates a http request to request vehicule infos from Sivit
    * @param : DocNum__c param_setting This parameter is the base URL parameter.
    * @param : String requestBody This parameter is the body of the request 
    * @param : String entityName   This parameter is the storeName or country 
    * @return : HttpRequest The request
    */
    public static HttpRequest uploadDocNumFiles(DocNum__c param_setting, String base64Data){
      
      String methodName = 'uploadDocNumFiles';
      
      ObjectUtil.debugLogBegin(CLASS_NAME, methodName , '[param_setting] : ' + param_setting);
      
      HttpRequest request = uploadDocNumFiles(param_setting, HTTP_METHOD_POST, POST_DOCNUM_FILES, base64Data);
        
      ObjectUtil.debugLogEnd(CLASS_NAME, methodName, '[request] : ' + request);
      return request;
    }
    
   /**
    * @auteur :Adolphe SONKO
    * @date : Création 02/08/2019
    * @date : Modification 02/08/2019
    * @description : This method creates a http request to request vehicule infos from Sivit
    * @param : DocNum__c param_setting This parameter is the Mulesoft Doc Num base URL parameter.
    * @param : String httpMethod   This parameter is the http Method 
    * @param : String ExpectedWebService   This parameter is the rest endpoint 
    * @return : HttpRequest The request
    */
    public static HttpRequest uploadDocNumFiles(DocNum__c param_setting, String httpMethod, String ExpectedWebService, String base64Data){
      
       String methodName = 'uploadDocNumFiles';
       ObjectUtil.debugLogBegin(CLASS_NAME, methodName , '[param_setting] : ' + param_setting);
       ObjectUtil.debugLogBegin(CLASS_NAME, methodName , '[httpMethod] : ' + httpMethod);
      
       HttpRequest request = new HttpRequest();
    //   request.setEndpoint(param_setting.BaseURL__c  + ExpectedWebService + base64Data);
       request.setMethod(httpMethod);
       request.setHeader('Content-Type', CONTENT_TYPE);
        
       String requestBody = '';
         
       request.setBody(requestBody);
       request.setTimeout(120000); 

       ObjectUtil.debugLogEnd(CLASS_NAME, methodName, '[request] : ' + request);
       return request;
    }
    

}