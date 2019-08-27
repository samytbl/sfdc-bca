/** 
* @author: Adolphe SONKO
* @date : Creation 23/08/2019
* @date : Modification 26/08/2019
* @description : This Class allows to handle trigger events in Work Order entity.
*/
public class SM003_WorkOrderTriggerHandler {

    private static String  CLASS_NAME = SM003_WorkOrderTriggerHandler.class.getName();
    
    public static void onAfterInsert(List<WorkOrder> rendezvous){
  
        String methodName = 'onAfterInsert';  
        ObjectUtil.debugLogBegin(CLASS_NAME, methodName, ' [rendezvous] : ' + rendezvous);
        
        List<Id> rdvIds = new List<Id>();
        List<Id> caseIds = new List<Id>();
        List<Case> listCasesToUpdate = new List<Case>();
        
        for(WorkOrder  r: rendezvous){
             if(r.DateRDV__c != null && !ObjectUtil.isEmpty(r.PostalCode) && r.TECH_RDVInitial__c == true) {
                  rdvIds.add(r.Id);  
                  caseIds.add(r.CaseId); 
              }
        }    
        
        if(caseIds != null && caseIds.size() > 0){
         // listCasesToUpdate = checkValidityOfJourPassage(rdvIds, caseIds);
        } 
        
        ObjectUtil.debugLogEnd(CLASS_NAME, methodName, '') ;
              
    } // End method onAfterInsert
    
    
    /**
     * @author: Adolphe SONKO
     * @date : Création 23/08/2019
     * @date : Modification 26/08/2019
     * @description : This method checks if the Date RDV & Lieu RDV are valid for passage.
     * @param : List<WorkOrder> dossiers.
     * @return : -Non-
     */
    public static List<Case> checkValidityOfJourPassage(List<Id> rdvIds, List<Id> caseIds){
        String methodName = 'checkValidityOfJourPassage';
        
        ObjectUtil.debugLogBegin(CLASS_NAME, methodName, ' [rdvIds] : ' + rdvIds);
      
        List<Case> listCasesToUpdate = new List<Case>();
        List<Id> caseIdsToUpdate = new List<Id>();
        List<Decimal> listPostalCode = new List<Decimal>();
        Map<Id, WorkOrder> mapRDVByCaseId = new Map<Id, WorkOrder>();
        
        List<WorkOrder> RDVs = DM003_WorkOrder.getListByCaseIds(caseIds);  //sort DESC
        for(Id i: caseIds){
            for(WorkOrder w: RDVs){
                if(mapRDVByCaseId.get(i) == null && i == w.CaseId){
                    mapRDVByCaseId.put(i, w) ;
                    listPostalCode.add(Decimal.valueOf(w.PostalCode)) ;
                }
            }
        }
        
        system.debug('ADBS mapRDVByCaseId     : ' + mapRDVByCaseId);
        
        //Get Jour de Passage
        List<JourPassage__c> jrsPassage = [SELECT AdresseAgence2__c,AdresseAgence3__c,AdresseAgence__c,CodePE__c,CodePostalAgence__c,CodeUSC__c,Jeudi__c,Lundi__c,Mardi__c,Mercredi__c,Reference__c,USCPoleExpertise__c,Vendredi__c,VilleAgence__c,VillePassage__c FROM JourPassage__c WHERE Reference__c IN: listPostalCode ];
        
        for(WorkOrder wo: RDVs){
            for(JourPassage__c jr: jrsPassage){
                if(Decimal.valueOf(wo.PostalCode) == jr.Reference__c && !isJourpassage(jr, wo.DateRDV__c) ) {
                    caseIdsToUpdate.add(wo.CaseId) ;
                } 
            }
        }
        
		//Get Cases
        listCasesToUpdate = DM002_Case.getListByIds(caseIdsToUpdate);
      //  QueueSObject queueGroup = [Select Queue.Id, Queue.Name, Queue.Type from QueueSObject WHERE Queue.Type ='Queue' AND Queue.Name =: Label.TECH_Queue_Dossier_Urgent  Limit 1];
        //Get Queue Id of Dossier à traiter urgemment
        Group queue = [SELECT DeveloperName,Id,Name,Type FROM Group WHERE Type = 'Queue' AND DeveloperName =: Label.TECH_Queue_Dossier_Urgent  Limit 1];
        for(Case c: listCasesToUpdate){
            c.TECH_MauvaisJourPassage__c = true ;
            if(queue.Id != null){
                c.OwnerId = queue.Id ;  //Dossier à traiter urgemment
            }
        }
        
        if(listCasesToUpdate != null && listCasesToUpdate.size() > 0){
            update listCasesToUpdate ;
        } 
        
        system.debug('ADBS Here is the updated cases : ' + listCasesToUpdate);
        return listCasesToUpdate ;
    }
    
    /**
     * @author: Adolphe SONKO
     * @date : Création 26/08/2019
     * @date : Modification 26/08/2019
     * @description : isJourpassage.
     * @param : JourPassage__c jrPass, Date myDate.
     * @return : Boolean
     */
    public static Boolean isJourpassage(JourPassage__c jrPass, Date myDate){
        
        Boolean isJourpassage = false ;
        String[] jours = new String[]{} ;
        
        DateTime dt = DateTime.newInstance(myDate, Time.newInstance(0,0,0,0));
		String dayOfWeek = dt.format('u');
        system.debug('ADBS dayOfWeek : ' + dayOfWeek); 
        
        if(jrPass.Lundi__c ){
            jours.add('1');      //dayOfWeek = 1 
        }
        if(jrPass.Mardi__c){
            jours.add('2');      //dayOfWeek = 2
        }
        if(jrPass.Mercredi__c){
            jours.add('3');      //dayOfWeek = 3
        }
        if(jrPass.Jeudi__c){
            jours.add('4');      //dayOfWeek = 4
        }
        if(jrPass.Vendredi__c){
            jours.add('5');      //dayOfWeek = 5
        }
        
        for(integer i=0; i<jours.size(); i++){
            if(dayOfWeek.equals(jours[i])){
                isJourpassage = true ;
                break;
            }
        }
        
        return isJourpassage ;
    }
    
    
    
}