/** 
* @author: Adolphe SONKO
* @date : Creation 13/06/2019
* @date : Modification 02/08/2019
* @description : This class contains utility methods for the WS  config
*/
public class APU001_ConfigUtils {
    
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
    
    /**
    * @author: Adolphe Sonko
    * @date : Creation 02/08/2019
    * @description : Get the DocNum Parameter for WS Sivit API callouts
    * @return : DocNum__c => DocNum Paramter with values corresponding to the org
    */
    public static DocNum__c dnParameter { get {
        if (dnParameter == null) {
            dnParameter = DocNum__c.getInstance(Label.TECH_DOC_NUM_PARAMETERS_NAME);
        }
        return dnParameter;
    } private set; }

}