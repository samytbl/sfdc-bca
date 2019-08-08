/** 
* @author: Menad CHABI
* @date : Creation 19/07/2019
* @date : Modification 19/07/2019
* @description : Récuperer la date du dernièr.
*/
global class DateEnvoiNull {
    

  @InvocableMethod(label='GetWorkOrderDateID' description='Returns the list of workOrders id corresponding to the Case IDs.')
    global static List<WorkOrder> getWorkOrderDate(List<WorkOrderRequest> requests) {
    
    WorkOrderRequest req = requests[0] ;
    List<WorkOrder> workOrderDate = new List<WorkOrder>();
    List<WorkOrder> workOrders = [SELECT id, DateEnvoi__c, CaseId, CreatedDate FROM WorkOrder WHERE CaseId =: req.CaseId and CreatedDate =: req.DateTechnique ];
    for (WorkOrder wr : workOrders) {
        wr.DateEnvoi__c = null;
      	workOrderDate.add(wr);
        system.debug('Work Order to Update' + workOrderDate);
    }
    
    if(workOrderDate != null && workOrderDate.size()>0){
            update workOrderDate;
            system.debug('workOrderDate' + workOrderDate); 
    }     
    return workOrderDate;
       

  }
    
    
    global class WorkOrderRequest {

        @InvocableVariable(required=true)
        global DateTime DateTechnique;
    
        @InvocableVariable(required=true)
        global ID CaseId;


  }
}