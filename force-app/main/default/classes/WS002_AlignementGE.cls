@RestResource(urlMapping='/alignementGE/*')
global with sharing class WS002_AlignementGE {
    
    @HttpGET
    global static DossierResponse selectDataToAlign() {
        DossierResponse response = new DossierResponse(true, null);
        System.debug('Get Data to align');
        for(Case record : [SELECT Id, 
                           NumDossierGE__c, 
                           AlignementGE__c, 
                           NatureMission__c, 
                           OwnerId,
                           Lese__r.CodeIntervGE__c,
                           Lese__r.Titre__c, 
                           Lese__r.Name,
                           Lese__r.BillingStreet,        
                           Lese__r.BillingPostalCode,
                           Lese__r.BillingCity,
                           Lese__r.BillingCountry,
                           Lese__r.Phone,
                           Lese__r.ActeurPassage__c, 
                           (SELECT Id,
                            CodeIntervGE__c,
                            TypeLieuRDV__c,
                            TitreLieuRDV__c,
                            NomRDV__c,
                            Street,               
                            PostalCode,         
                            City,
                            Country,
                            DateRDV__c,
                            HeureRDV__c,
                            TelephoneLieu__c,
                            ActeurPassage__c 
                            FROM WorkOrders ORDER BY createdDate DESC LIMIT 1
                           )
                           FROM Case WHERE AlignementGE__c != null
                          ]){
                               String OwnerId = record.OwnerId;
                               //The case must not be in queue, The owner must be a user ( A CC)
                               System.debug('OwnerId : ' + OwnerId);
                               if(OwnerId != null && OwnerId.startsWith('005')){
                                  Dossier dossier = new Dossier(record);                                
                                  if(!dossier.alignement.contains('N')){
                                      dossier.natureMission = null;
                                  }
                                  if(dossier.alignement.contains('L')){
                                      if(record.Lese__r != null){
                                          Lese lese = new Lese(record.Lese__r);
                                          dossier.lese = lese;
                                      } 
                                  }
                                  if(dossier.alignement.contains('RDV')){
                                      if(!record.WorkOrders.isEmpty()){
                                          RDV rdv = new RDV(record.WorkOrders[0]);
                                          dossier.rdv = rdv;
                                      }
                                  }
                                  if(dossier.alignement.contains('CC')){  
                                      User ccSo = [SELECT Id, CodeIntervGE__c FROM User  WHERE Id = :OwnerId];
                                      CC cc = new CC(ccSo);
                                      dossier.cc = cc;
                                  }  
                                  response.addDossier(dossier);  
                               }                                                          
                          }
        return response;
    }
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
            
            //Set the real Code Intervenants
            if(dossier.lese != null){
				Account leseSO = [SELECT Id, CodeIntervGE__c FROM Account WHERE Id=:dossier.lese.Id];
            	leseSO.CodeIntervGE__c = dossier.lese.CodeIntervGE;
            	records.add(leseSO);                
            }
            
            if(dossier.lese != null){
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
    global class DossierResponse extends GenericResponse {
        List<Dossier> dossiers;     
        global DossierResponse(Boolean success, String message){
            super(success, message);
            this.dossiers = new List<Dossier>();
        }
        public void addDossier(Dossier dossier){
            this.dossiers.add(dossier);
        }
    }
    
   
    global class Dossier {
        String Id;
        Integer numeroDossier;
        String natureMission;
        String[] alignement;
        Lese lese;
        CC cc;
        RDV rdv;
        
        global Dossier(Case so){
            this.fill(so);
        }
        public void fill(Case so){
            this.Id = so.Id;
            this.numeroDossier = Integer.valueOf(so.NumDossierGE__c);
            this.natureMission = so.NatureMission__c;
            this.alignement = so.AlignementGE__c.split(';');
        }
    }
    global class DossierInfoRequest {
        global String Id; 
        global Acteur lese; 
        global Acteur rdv;
    }
    global class Lese{
        global String Id;
        global Integer CodeIntervGE;
        global boolean ActeurPassage; 
        global String Titre; 
        global String Name;
        global String Street;        
        global String PostalCode;
        global String City;
        global String Country;
        global String Phone;
        
        global Lese(Account so){
            this.fill(so);
        }
        public void fill(Account so){             
            this.Id = so.Id;
            this.CodeIntervGE = Integer.valueOf(so.CodeIntervGE__c);          
            this.ActeurPassage = so.ActeurPassage__c;
            this.Titre = so.Titre__c;
            this.Name = so.Name;
            this.Street = so.BillingStreet;
            this.PostalCode = so.BillingPostalCode;
            this.City = so.BillingCity;
            this.Country = so.BillingCountry;
            this.Phone = so.Phone;
        }
    }
    
    global class RDV{
        global String Id;
        global String Type;
        global Integer CodeIntervGE; 
        global boolean ActeurPassage; 
        global String Titre; 
        global String Name;
        global String Street;        
        global String PostalCode;
        global String City;
        global String Country;
        global String Phone;
        global DateTime dateRDV;
        
        global RDV(WorkOrder so){
            this.fill(so);
        }
        public void fill(WorkOrder so){             
            this.Id = so.Id;
            this.Type = so.TypeLieuRDV__c;
            this.CodeIntervGE = Integer.valueOf(so.CodeIntervGE__c);          
            this.ActeurPassage = so.ActeurPassage__c;
            this.Titre = so.TitreLieuRDV__c;
            this.Name = so.NomRDV__c;
            this.Street = so.Street;
            this.PostalCode = so.PostalCode;
            this.City = so.City;
            this.Country = so.Country;
            this.Phone = so.TelephoneLieu__c;
            if(so.DateRDV__c != null){
                Time HeureRDV = so.HeureRDV__c;
                if(HeureRDV == null){
                    HeureRDV = Time.newInstance(0, 0, 0, 0);
                }
                this.dateRDV = DateTime.newInstance(so.DateRDV__c, HeureRDV);
            }            
        }
    }
    global class CC{
        global String Id;
        global Integer CodeIntervGE; 
        
        global CC(User so){
            this.fill(so);
        }
        public void fill(User so){             
            this.Id = so.Id;
            this.CodeIntervGE = Integer.valueOf(so.CodeIntervGE__c);  
        }
    }
    global class Acteur{
        global String Id;
        global Integer CodeIntervGE; 
    }
}