/** 
* @author: Adolphe SONKO
* @date : Creation 13/06/2019
* @description : This class contains webservice utils
*/
public class APU002_WebserviceUtils {
    /**
     * @auteur : Adolphe SONKO
     * @date : Création 13/06/2019
     * @date : Modification 13/06/2019
     * @description : This Methods call webservices method using http standard protocol
     * @param : HttpRequest request This param is the HTTP request.
     * @return : HttpResponse The webservice call response.
     */
    public static HttpResponse sendRequest(HttpRequest request){
        return new Http().send(request) ;    
    }
}