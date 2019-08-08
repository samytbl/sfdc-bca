/** 
* @author: Adolphe SONKO
* @date : Création 07/06/2019
* @date : Modification 07/06/2019
* @description : this Class allow to manage Vehicule (Asset) business entity data preparation .
*/

public class EM001_Vehicule {
    
    private static String CLASS_NAME = 'EM001_Vehicule';
    private static String HTTP_METHOD_GET = 'GET';
    private static String GET_VEHICULE = system.label.WS_Sivit_Ressource_API_v1 ;
    private static String CONTENT_TYPE = 'application/json';
    
    
      /**
    * @auteur :Adolphe SONKO
    * @date : Création 07/06/2019
    * @date : Modification 07/06/2019
    * @description : This method creates a http request to request vehicule infos from Sivit
    * @param : Sivit_Parameters__c param_setting This parameter is the base URL parameter.
    * @param : String requestBody This parameter is the body of the request 
    * @param : String entityName   This parameter is the storeName or country 
    * @return : HttpRequest The request
    */
    public static HttpRequest getVehiculeSivit(SivitParameters__c param_setting, String immat){
      
      String methodName = 'getVehiculeSivit';
      
      ObjectUtil.debugLogBegin(CLASS_NAME, methodName , '[param_setting] : ' + param_setting);
      
      HttpRequest request = getVehiculeSivit(param_setting, HTTP_METHOD_GET, GET_VEHICULE, immat);
        
      ObjectUtil.debugLogEnd(CLASS_NAME, methodName, '[request] : ' + request);
      return request;
    }
    
   /**
    * @auteur :Adolphe SONKO
    * @date : Création 07/06/2019
    * @date : Modification 07/06/2019
    * @description : This method creates a http request to request vehicule infos from Sivit
    * @param : Sivit_Parameters__c param_setting This parameter is the Mulesoft Sivit base URL parameter.
    * @param : String httpMethod   This parameter is the http Method 
    * @param : String ExpectedWebService   This parameter is the rest endpoint 
    * @return : HttpRequest The request
    */
    public static HttpRequest getVehiculeSivit(SivitParameters__c param_setting, String httpMethod, String ExpectedWebService, String immat){
      
       String methodName = 'getVehiculeSivit';
       ObjectUtil.debugLogBegin(CLASS_NAME, methodName , '[param_setting] : ' + param_setting);
       ObjectUtil.debugLogBegin(CLASS_NAME, methodName , '[httpMethod] : ' + httpMethod);
      
       HttpRequest request = new HttpRequest();
       request.setEndpoint(param_setting.BaseURL__c  + ExpectedWebService + immat);
       request.setMethod(httpMethod);
       request.setHeader('Content-Type', CONTENT_TYPE);
       request.setTimeout(120000); 

       ObjectUtil.debugLogEnd(CLASS_NAME, methodName, '[request] : ' + request);
       return request;
    }
    
}