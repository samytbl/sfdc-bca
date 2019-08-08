/** 
* @author: Adolphe SONKO
* @date : Creation 13/06/2019
* @date : Modification 13/06/2019
* @description : This class contains utility methods for the WS Sivit config
*/
public class APU001_SivitConfigUtils {
    
    /**
    * @author: Adolphe Sonko
    * @date : Creation 13/06/2019
    * @description : Get the Sivit Parameter for WS Sivit API callouts
    * @return : SivitParameters__c => Sivit Paramter with values corresponding to the org
    */
    public static SivitParameters__c sParameter { get {
        if (sParameter == null) {
            sParameter = SivitParameters__c.getInstance(Label.TECH_SIVIT_PARAMETERS_NAME);
        }
        return sParameter;
    } private set; }

}