/** 
* @author: Menad CHABI
* @date : Creation 26/07/2019
* @date : Modification 19/07/2019
* @description : Vérifier les points remarquables et les tache liés a un dossier.
*/
global class StatutDossier {
    

  @InvocableMethod(label='StatutDossier' description='Vérifier qu’aucun point remarquable n est rattaché au dossier.')
    global static List<Case> getCasePRT(List<CaseRequest> requests) {
    
    CaseRequest req = requests[0] ;
    List<PointRemarquable__c > PointRemarquables = new List<PointRemarquable__c >();    
    PointRemarquables = [SELECT Id,Dossier__c, Statut__c FROM PointRemarquable__c where  Dossier__c =: req.CaseId];
        
    List<Case > Cases = new List<Case >();
    List<Case > listCasesToUpdate = new List<Case >();   
    Cases = [SELECT Id,Status  FROM Case where Id =: req.CaseId];
        
    List<Task > Tasks = new List<Task >();
    Tasks = [SELECT Id, Subject, WhatId, Status   FROM Task where WhatId  =: req.CaseId];
     
    
        system.debug('Tasks :' + Tasks); 
        
        if((PointRemarquables==null || PointRemarquables.isEmpty())&&(Tasks==null || Tasks.isEmpty())){
            system.debug('PointRemarquables is null '); 
        	Cases[0].Status ='Expertise'; 
            system.debug('Cases'+Cases);
            
        }
        
       boolean isPROpen = false ;
       boolean isTaskOpen = false ;
        
         if(PointRemarquables != null && PointRemarquables.size() > 0){
               
              for (PointRemarquable__c PR : PointRemarquables) {
              		if(PR.Statut__c == 'Nouveau' ) { 
                          isPROpen = true ;	
 						
               		}   
              }
  		}     
        
        if(Tasks != null && Tasks.size() > 0){
            system.debug('Tasksss'+Tasks);
            
              for (Task T : Tasks) {
              		if(T.Status == 'Open') { 
                        isTaskOpen = true ;	
               		}         
              }
        }
        
        if(!isPROpen && !isTaskOpen){
            Cases[0].Status ='Expertise';
            listCasesToUpdate.add(Cases[0]) ;
        }
    
       if(listCasesToUpdate != null && listCasesToUpdate.size()>0){
                update listCasesToUpdate;
                system.debug('listCasesToUpdate' + listCasesToUpdate); 
        }     
    	
        return listCasesToUpdate;
    }
    
    
    global class CaseRequest {

    
        @InvocableVariable(required=true)
        global ID CaseId;


  }
    
}