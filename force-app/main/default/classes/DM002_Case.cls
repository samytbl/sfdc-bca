/** 
* @author: Adolphe SONKO
* @date : Création 17/06/2019
* @date : Modification 17/06/2019
* @description : this Class allow to manage all database operations (such as select requests and dml) with Salesforce.com .
*/
public class DM002_Case {
	private static String CLASS_NAME = 'DM002_Case';
    private static final String ALL_FIELDS = ObjectUtil.constructFieldListForQueryFrom('Case');
    
    
    /**
     * @author : Adolphe SONKO
     * @date : Création 17/06/2019
     * @date : Modification 17/06/2019 
     * @description : This method performs an SQL query on the account to repatriate its data from an ID list.
     * @param : List<Id> VehiculeIds This parameter is a list of unique identifiers of case.
     * @return : List<Case> The returned item is a list of Cases.
     */  
    public static List<Case> getListByIds(List<Id> caseIds){
        
        String methodName = 'getListByIds';    
        ObjectUtil.debugLogBegin(CLASS_NAME, methodName, '[caseIds] :' + caseIds);
        
        String soqlQuery = 'SELECT ' + ALL_FIELDS + ' FROM Case WHERE Id IN: caseIds';    
        List<Case> listCases = new List<Case>((List<Case>)Database.query(soqlQuery));
        
        ObjectUtil.debugLogEnd(CLASS_NAME, methodName, '[RESULTS] :' + listCases);
        return listCases; 
    }
    
}