/** 
* @author: Adolphe SONKO
* @date : Creation 12/06/2019
* @date : Modification 12/06/2019
* @description : This Class allows to Simule the WS Sivit Api calls.
*/

public class MCK001_SivitHttpResponse implements HttpCalloutMock {
    
    private static String CLASS_NAME = 'MCK001_SivitHttpResponse';
    
    /**
     * @author: Adolphe SONKO
     * @date : Creation 12/06/2019
     * @date : Modification 12/06/2019
     * @description : This Method simules a call to webservices method
     * @param : HttpRequest request This param is the HTTP request.
     * @return : HttpResponse The Sivit WS Api call response.
     */
    public HttpResponse respond(HttpRequest request){
        
        String methodName = 'respond';
        ObjectUtil.debugLogBegin(CLASS_NAME, methodName , '[request] :' + request);

        // Create Manually json response For Test Class
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');

        response.setBody('{"carrosserieCG": "BREAK","codEnergie": "GO","codifVin": "1C4BU0000GPC68482","cylindree": 1956,"immatSiv": "DX-497-LB","date1ErCir": "2015-11-19T00:00:00+01:00","depollution": "Oui"}');
        system.debug('MCK001_SivitHttpResponse response body: ' + response.getBody()); 
        response.setStatusCode(200);
        
        ObjectUtil.debugLogEnd(CLASS_NAME, methodName, '[RESULTS] :' + response);              
        return response ;    
    }
    

}