/** 
* @author: Adolphe SONKO
* @date : Création 23/08/2019
* @date : Modification 23/08/2019
* @description : this Class allow to manage all database operations (such as select requests and dml) with Salesforce.com .
*/
public class DM003_WorkOrder {

    private static String CLASS_NAME = 'DM003_WorkOrder';
    private static final String ALL_FIELDS = ObjectUtil.constructFieldListForQueryFrom('WorkOrder');
    
    
    /**
     * @author: Adolphe SONKO
     * @date : Création 23/08/2019
     * @date : Modification 23/08/2019 
     * @description : This method performs an SQL query on the work order to repatriate its data from an ID list.
     * @param : List<Id> VehiculeIds This parameter is a list of unique identifiers of work order.
     * @return : List<WorkOrder> The returned item is a list of WorkOrders.
     */  
    public static List<WorkOrder> getListByIds(List<Id> workOrderIds){
        
        String methodName = 'getListByIds';    
        ObjectUtil.debugLogBegin(CLASS_NAME, methodName, '[workOrderIds] :' + workOrderIds);
        
        String soqlQuery = 'SELECT ' + ALL_FIELDS + ' FROM WorkOrder WHERE Id IN: workOrderIds ';    
        List<WorkOrder> listWorkOrders = new List<WorkOrder>((List<WorkOrder>)Database.query(soqlQuery));
        
        ObjectUtil.debugLogEnd(CLASS_NAME, methodName, '[RESULTS] :' + listWorkOrders);
        return listWorkOrders; 
    }
    
    /**
     * @author: Adolphe SONKO
     * @date : Création 23/08/2019
     * @date : Modification 23/08/2019 
     * @description : This method performs an SQL query on the work order to repatriate its data from an ID list.
     * @param : List<Id> VehiculeIds This parameter is a list of unique identifiers of case.
     * @return : List<WorkOrder> The returned item is a list of WorkOrders.
     */  
    public static List<WorkOrder> getListByCaseIds(List<Id> caseIds){
        
        String methodName = 'getListByCaseIds';    
        ObjectUtil.debugLogBegin(CLASS_NAME, methodName, '[caseIds] :' + caseIds);
        
        String soqlQuery = 'SELECT ' + ALL_FIELDS + ' FROM WorkOrder WHERE CaseId IN: caseIds ORDER BY CreatedDate DESC';    
        List<WorkOrder> listWorkOrders = new List<WorkOrder>((List<WorkOrder>)Database.query(soqlQuery));
        
        ObjectUtil.debugLogEnd(CLASS_NAME, methodName, '[RESULTS] :' + listWorkOrders);
        return listWorkOrders; 
    }
    
}