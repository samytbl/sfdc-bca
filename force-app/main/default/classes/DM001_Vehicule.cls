/** 
* @author: Adolphe SONKO
* @date : Création 12/06/2019
* @date : Modification 12/06/2019
* @description : this Class allow to manage all database operations (such as select requests and dml) with Salesforce.com .
*/
public class DM001_Vehicule {
	
    private static String CLASS_NAME = 'DM001_Vehicule';
    private static final String ALL_FIELDS = ObjectUtil.constructFieldListForQueryFrom('Asset');
    
    
    /**
     * @author : Adolphe SONKO
     * @date : Création 12/06/2019
     * @date : Modification 12/06/2019 
     * @description : This method performs an SQL query on the account to repatriate its data from an ID list.
     * @param : List<Id> VehiculeIds This parameter is a list of unique identifiers of vehicule.
     * @return : List<Asset> The returned item is a list of Assets.
     */  
    public static List<Asset> getListByIds(List<Id> vehiculeIds){
        
        String methodName = 'getListByIds';    
        ObjectUtil.debugLogBegin(CLASS_NAME, methodName, '[vehiculeIds] :' + vehiculeIds);
        
        String soqlQuery = 'SELECT ' + ALL_FIELDS + ' FROM Asset WHERE Id IN: vehiculeIds';    
        List<Asset> listVehicules = new List<Asset>((List<Asset>)Database.query(soqlQuery));
        
        ObjectUtil.debugLogEnd(CLASS_NAME, methodName, '[RESULTS] :' + listVehicules);
        return listVehicules; 
    }
    
    
}