@RestResource(urlMapping='/alignementXPS/*')
global with sharing class WS003_AlignementXPS {
    
    @HttpPATCH
    global static GenericResponse alignCodeInterv(DossierInfoRequest dossier) {
        GenericResponse response = null;
        boolean processed = false;
        Savepoint sp = Database.setSavepoint(); 
        List<SObject> records = new List<SObject>();
        System.debug('Update Data to align');
        try{    
            //Reset the Alignement GE
            Case dossierSO = [SELECT Id, AlignementGE__c FROM Case WHERE Id=:dossier.Id];
            dossierSO.AlignementGE__c = null;
            records.add(dossierSO);
             System.debug('Update Data to align' + dossierSO);
            //Set the real Code Intervenants
            if(dossier.lese != null){
				Account leseSO = [SELECT Id, CodeIntervGE__c FROM Account WHERE Id=:dossier.lese.Id];
            	leseSO.CodeIntervGE__c = dossier.lese.CodeIntervGE;
            	records.add(leseSO);                
            }
            
            if(dossier.rdv != null){
                WorkOrder rdvSO = [SELECT Id, CodeIntervGE__c FROM WorkOrder WHERE Id=:dossier.rdv.Id];
            	rdvSO.CodeIntervGE__c = dossier.rdv.CodeIntervGE;
            	records.add(rdvSO);
            }
                       
            update records;
            processed = true;
        }catch(Exception e){
            System.debug('Error during processing the record : ' + e.getStackTraceString());
            Database.rollback(sp);
            response = new GenericResponse(false, e.getMessage() + ' - ' + e.getStackTraceString());                    
        }
        if(processed){
            response = new GenericResponse(true, null); 
        } 
        return response;
    }
    
    global virtual class GenericResponse {
        global boolean success;
        global String message;
        
        global GenericResponse(boolean success, String message){
            this.success = success;
            this.message = message;
        }
    }
   
    global class DossierInfoRequest {
        global String Id; 
        global Acteur lese; 
        global Acteur rdv;
    }
   
    global class Acteur{
        global String Id;
        global Integer CodeIntervGE; 
    }
}