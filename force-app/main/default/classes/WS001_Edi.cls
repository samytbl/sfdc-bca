@RestResource(urlMapping='/edi/*')
global with sharing class WS001_Edi {
    
    global static String PACIFICA_CODE = '446';
    
    @HttpPost
    global static EdiResponse importData(EdiRequest record) {
        EdiResponse response = null;
        Savepoint sp = Database.setSavepoint(); 
        Boolean processed = false;
        try{            
            createOM(record);            
            processed = true;
        }catch(Exception e){
            Database.rollback(sp);
            response = new EdiResponse(record.referenceId, false, e.getMessage() + ' - ' + e.getStackTraceString());                    
        }
        if(processed){
            response = new EdiResponse(record.referenceId, true, null); 
        } 
        return response;
    }

    private static void createOM(EdiRequest record) {
         
            OM om = record.om;
            Dossier dossier = record.dossier;
            ClientAssureur clientAssureur = record.clientAssureur;
            Emetteur emetteur = record.emetteur;
            GestionnaireDossierEmetteur gestionnaireDossierEmetteur = record.gestionnaireDossierEmetteur;
            Lese lese = record.lese;  
            Reparateur reparateur = record.reparateur;
            VehiculeOM vehiculeOM = record.vehiculeOM;
            Tiers tiers = record.tiers;
            
            
            emetteur.init(om, clientAssureur);
            Account emetteurSO = emetteur.save();   
            gestionnaireDossierEmetteur.init(emetteurSO);
            Contact gestionnaireDossierEmetteurSO = gestionnaireDossierEmetteur.save();    
            Account leseSO = lese.save();
            Account reparateurSO = reparateur.save();
            Account tiersSo = tiers.save();
            dossier.init(om, clientAssureur, emetteurSO, gestionnaireDossierEmetteurSO, leseSO, reparateurSO, tiersSo);
            Case dossierSO = dossier.save();
            
            vehiculeOM.init(dossierSO, leseSO);
            vehiculeOM.save();
            
            //if(true) throw new  MathException('Reviser les maths'); 
            om.init(dossierSO); 
            om.save();
                     
    }
        
    global class EdiRequest {
        
        global String referenceId;
        global OM om;
        global Dossier dossier;
        global Lese lese;
        global ClientAssureur clientAssureur;
        global Emetteur emetteur;
        global GestionnaireDossierEmetteur gestionnaireDossierEmetteur;
        global Reparateur reparateur;
        global VehiculeOM vehiculeOM;
        global Tiers tiers;
    }    
   
    global class EdiResponse {
        global String referenceId;
        global Boolean success;
        global String message;
        global EdiResponse(String referenceId, Boolean success, String message){
            this.referenceId = referenceId;
            this.success = success;
            this.message = message;
        }
    } 

    global virtual class DataObject{

    }   
    
    global class OM extends DataObject {
        global String AdresseEmetteur;
        global String AdresseLieuExamen;
        global String AdresseLese;
        global boolean AssureProprietaireVehicule;
        global String CirconstancesSinistre;
        global String ClientAssureur;
        global Integer CodeBCALieuExamen;
        global String CodeLieuExamen;
        global String CodePlafondGarantie;
        global String CodePostalLieuExamen;
        global String CodePostalLieuSinistre;
        global String CodePostalLeseOuCodeDept;
        global String CodePostalEmetteur;
        global String CommentairesLigne1;
        global Date DateDepotVehiculeExamen;
        global Date DateMission;
        global Date DateSouscriptionContrat;
        global Date DateSinistre;
        global String DommagesDeclares;
        global String GarantieMiseEnJeu;
        global boolean GarantieRemorquage;
        global String ImmatriculationVehiculeAssure;
        global String IndicateurReglementDirect;
        global String LibelleValeurConventionnelle;
        global String LibelleMarqueVehiculeAssure;
        global String LibelleModeleVehiculeAssure;
        global Integer LimiteAccessoires;
        global Integer LimiteEventuelleReglementDirect;
        global String ListeCodesGarantiesAcquises;
        global String LocaliteEmetteur;
        global String LocaliteLieuExamen;
        global String LocaliteLese;
        global String LocaliteSinistre;
        global Integer MontantLimiteRemorquage;
        global Integer MontantPlafondFranchise;
        global Integer MontantPlafondGarantie;
        global Integer MontantPlancheOuFixeFranchise;        
        global String NatureMission;
        global String Emetteur;
        global String Lese;
        global String NomExamen;
        global String NomGestionnaire;
        global String NumeroMissionBCA;
        global String NumeroSinistre;
        global String NumeroTelephoneGestionnaire;
        global String NDossierEmetteur;
        global String NPoliceAssure;
        global String PaysEmetteur;
        global String PaysLieuExamen;
        global String PaysLese;
        global boolean PriseEnChargeAccessoires;
        global String PrenomGestionnaire;
        global String SituationMaterielExpertiser;
        global Integer TauxFranchise;
        global Integer TauxPriseEnCharge;
        global Integer TauxResponsabiliteAssure;
        global String TextePrecisantTypeFranchiseD;
        global String TitreEmetteur;
        global String TitreExamen;
        global String TitreLese;
        global String TVAPriseEnChargeParAssureur;
        global String TypeEmetteur;
        global String TypeFranchise;
        global String TelephoneLieuExamen;
        global String TelephoneLese;
        global String VehiculeAExpertiser;
        global String ZonesChoc;
        
        global Date DateTarif;		
		global String Clause1; 
		global String Clause2;
		global String Clause3; 
		global String Clause4;
		global String Clause5;							
		global Integer PourcentageRemise; 
		global String TypeRemise; 
		global Double TarifI1;  
		global Double TarifI2;
		global Double TarifI3;  
		global Double TarifT1;
		global Double TarifT2;
		global Double TarifT3;
		global Double TarifTP;
		global String ObservationsConstatLese;
		global String DirectivesParticulieres;
		global String CopieConstatAmiable;
		global String AutresPiecesAdressees;
		global Boolean RapportPapierNecessaire;
		global String ConditionsAchatVehicule;
        
        private Case dossier;
        
        global void init(Case dossier){
            this.dossier = dossier;           
        }
        
        global Ordre_de_Mission__c save(){
            Ordre_de_Mission__c so = find();
            if(so == null){
                so = createSO();
                insert so;
                System.debug('New <Ordre de Mission> created (' + so + ')');
            }else{           
                updateSO(so);          
                update so;
                System.debug('Existing <Ordre de Mission> updated (' + so + ')');
            }           
            return so;
        }
        private Ordre_de_Mission__c find(){  
            //We create always the <Ordre de Mission>
            return null;
        }
        
        private Ordre_de_Mission__c createSO(){
            Ordre_de_Mission__c so = new Ordre_de_Mission__c();
            updateSO(so);
            return so;
        }
        private void updateSO(Ordre_de_Mission__c so){
            
            so.AdresseEmetteur__c = this.AdresseEmetteur;
            so.AdresseLieuExamen__c = this.AdresseLieuExamen;
            so.AdresseLese__c = this.AdresseLese;
            so.AssureProprietaireVehicule__c = this.AssureProprietaireVehicule;
            so.CirconstancesSinistre__c = this.CirconstancesSinistre;
            so.ClientAssureur__c = this.ClientAssureur;
            so.CodeBCALieuExamen__c = this.CodeBCALieuExamen;
            so.CodeLieuExamen__c = this.CodeLieuExamen;
            so.CodePlafondGarantie__c = this.CodePlafondGarantie;
            so.CodePostalLieuExamen__c = this.CodePostalLieuExamen;
            so.CodePostalLieuSinistre__c = this.CodePostalLieuSinistre;
            so.CodePostalLeseOuCodeDept__c = this.CodePostalLeseOuCodeDept;
            so.CodePostalEmetteur__c = this.CodePostalEmetteur;
            so.CommentairesLigne1__c = this.CommentairesLigne1;
            so.DateDepotVehiculeExamen__c = this.DateDepotVehiculeExamen;
            so.DateMission__c = this.DateMission;
            so.DateSouscriptionContrat__c = this.DateSouscriptionContrat;
            so.DateSinistre__c = this.DateSinistre;
            so.DommagesDeclares__c = this.DommagesDeclares;
            so.GarantieMiseEnJeu__c = this.GarantieMiseEnJeu;
            so.GarantieRemorquage__c = this.GarantieRemorquage;
            so.ImmatriculationVehiculeAssure__c = this.ImmatriculationVehiculeAssure;
            so.IndicateurReglementDirect__c = this.IndicateurReglementDirect;
            so.LibelleValeurConventionnelle__c = this.LibelleValeurConventionnelle;
            so.LibelleMarqueVehiculeAssure__c = this.LibelleMarqueVehiculeAssure;
            so.LibelleModeleVehiculeAssure__c = this.LibelleModeleVehiculeAssure;
            so.LimiteAccessoires__c  = this.LimiteAccessoires ;
            so.LimiteEventuelleReglementDirect__c = this.LimiteEventuelleReglementDirect;
            so.ListeCodesGarantiesAcquises__c = this.ListeCodesGarantiesAcquises;
            so.LocaliteEmetteur__c = this.LocaliteEmetteur;
            so.LocaliteLieuExamen__c = this.LocaliteLieuExamen;
            so.LocaliteLese__c = this.LocaliteLese;
            so.LocaliteSinistre__c = this.LocaliteSinistre;
            so.MontantLimiteRemorquage__c = this.MontantLimiteRemorquage;
            so.MontantPlafondFranchise__c = this.MontantPlafondFranchise;
            so.MontantPlancheOuFixeFranchise__c = this.MontantPlancheOuFixeFranchise;
            so.MontantPlafondGarantie__c = this.MontantPlafondGarantie;
            so.NatureMission__c = this.NatureMission;
            so.Emetteur__c = this.Emetteur;
            so.Lese__c = this.Lese;
            so.NomExamen__c = this.NomExamen;
            so.NomGestionnaire__c = this.NomGestionnaire;
            so.NumeroMissionBCA__c = this.NumeroMissionBCA;
            so.NumeroSinistre__c = this.NumeroSinistre;
            so.NumeroTelephoneGestionnaire__c = this.NumeroTelephoneGestionnaire;
            so.NDossierEmetteur__c = this.NDossierEmetteur;
            so.NPoliceAssure__c = this.NPoliceAssure;
            so.PaysEmetteur__c = this.PaysEmetteur;
            so.PaysLieuExamen__c = this.PaysLieuExamen;
            so.PaysLese__c = this.PaysLese;
            so.PriseEnChargeAccessoires__c = this.PriseEnChargeAccessoires ;
            so.PrenomGestionnaire__c = this.PrenomGestionnaire;
            so.SituationMaterielExpertiser__c = this.SituationMaterielExpertiser;
            so.TauxFranchise__c = this.TauxFranchise;
            so.TauxPriseEnCharge__c = this.TauxPriseEnCharge;
            so.TauxResponsabiliteAssure__c = this.TauxResponsabiliteAssure;
            so.TextePrecisantTypeFranchiseD__c = this.TextePrecisantTypeFranchiseD;
            so.TitreEmetteur__c = this.TitreEmetteur;
            so.TitreExamen__c = this.TitreExamen;
            so.TitreLese__c = this.TitreLese;
            so.TVAPriseEnChargeParAssureur__c = this.TVAPriseEnChargeParAssureur;
            so.TypeEmetteur__c = this.TypeEmetteur;
            so.TypeFranchise__c = this.TypeFranchise;
            so.TelephoneLieuExamen__c = this.TelephoneLieuExamen;
            so.TelephoneLese__c = this.TelephoneLese;
            so.VehiculeAExpertiser__c = this.VehiculeAExpertiser;
            so.ZonesChoc__c = this.ZonesChoc;
            
            so.DateTarif__c= this.DateTarif;		
            so.Clause1__c= this.Clause1; 
            so.Clause2__c= this.Clause2;
            so.Clause3__c= this.Clause3; 
            so.Clause4__c= this.Clause4;
            so.Clause5__c= this.Clause5;				
            so.PourcentageRemise__c= this.PourcentageRemise; 
            so.TypeRemise__c=this.TypeRemise; 
            so.TarifI1__c= this.TarifI1;
            so.TarifI2__c= this.TarifI2;
            so.TarifI3__c= this.TarifI3;
            so.TarifT1__c= this.TarifT1;
            so.TarifT2__c= this.TarifT2;
            so.TarifT3__c= this.TarifT3;
            so.TarifTP__c= this.TarifTP;
            so.ObservationsConstatLese__c= this.ObservationsConstatLese;
            so.DirectivesParticulieres__c= this.DirectivesParticulieres;
            so.CopieConstatAmiable__c= this.CopieConstatAmiable;
            so.AutresPiecesAdressees__c= this.AutresPiecesAdressees;
            so.RapportPapierNecessaire__c= this.RapportPapierNecessaire;
            so.ConditionsAchatVehicule__c= this.ConditionsAchatVehicule;
            
            //Update dependencies           
            so.Dossier__c = dossier.Id;
        }
        
    }
    
    global class Dossier extends DataObject {
        
        global String RecordTypeId;
        private OM om;
        private ClientAssureur clientAssureur; 
        private Account emetteur; 
        private Contact gestionnaireDossierEmetteur;
        private Account lese;
        private Account reparateur;
        private Account tiers;
        
        global void init(OM om, ClientAssureur clientAssureur, Account emetteur, Contact gestionnaireDossierEmetteur, Account lese, Account reparateur, Account tiers){
            this.om = om;
            this.clientAssureur = clientAssureur;
            this.emetteur = emetteur;
            this.gestionnaireDossierEmetteur = gestionnaireDossierEmetteur;
            this.lese = lese;
            this.reparateur = reparateur;
            this.tiers = tiers;
        }
        
        global Case save(){
            Case so = find();
            if(so == null){
                so = createSO();
                insert so;
                System.debug('New <Dossier> created (' + so + ')');
            }else{           
                updateSO(so);          
                update so;
                System.debug('Existing <Dossier> updated (' + so + ')');
            }           
            return so;
        }
        private Case find(){  
            //We create always the <Dossier>
            return null;
        }
        
        private Case createSO(){
            Case so = new Case();
            so.Origin = 'TE';           
            updateSO(so);
            return so;
        }
        
        private void updateSO(Case so){
            
            so.AdresseLieuExamen__c = om.AdresseLieuExamen;                       
            so.CirconstancesSinistre__c = om.CirconstancesSinistre;
            so.CodeLieuExamen__c = om.CodeLieuExamen;
            so.CodePlafondGarantie__c = om.CodePlafondGarantie;
            so.CodePostalLieuExamen__c = om.CodePostalLieuExamen;
            so.CodePostalLieuSinistre__c = om.CodePostalLieuSinistre;            
            so.CommentairesLigne1__c = om.CommentairesLigne1;
            so.DateMission__c = om.DateMission;
            so.DateSouscriptionContrat__c = om.DateSouscriptionContrat;
            so.DateSinistre__c = om.DateSinistre;
            so.DommagesDeclares__c = om.DommagesDeclares;            
            so.GarantieMiseEnJeu__c = om.GarantieMiseEnJeu;
            so.GarantieRemorquage__c = om.GarantieRemorquage;
            so.ImmatriculationVehiculeAssure__c = om.ImmatriculationVehiculeAssure;
            so.IndicateurReglementDirect__c = om.IndicateurReglementDirect;
            so.LibelleValeurConventionnelle__c = om.LibelleValeurConventionnelle;
            so.LimiteAccessoires__c  = om.LimiteAccessoires;
            so.LimiteEventuelleReglementDirect__c = om.LimiteEventuelleReglementDirect;
            so.ListeCodesGarantiesAcquises__c = om.ListeCodesGarantiesAcquises;            
            so.LocaliteSinistre__c = om.LocaliteSinistre;            
            so.MontantLimiteRemorquage__c = om.MontantLimiteRemorquage;
            so.MontantPlafondFranchise__c = om.MontantPlafondFranchise;
            so.MontantPlancheOuFixeFranchise__c = om.MontantPlancheOuFixeFranchise;
            so.MontantPlafondGarantie__c = om.MontantPlafondGarantie;
            so.NatureMission__c = om.NatureMission;
            so.NomExamen__c = om.NomExamen;
            so.NumeroMissionBCA__c = om.NumeroMissionBCA;
            so.NumeroSinistre__c = om.NumeroSinistre;
            so.NDossierEmetteur__c = om.NDossierEmetteur;
            so.NPoliceAssure__c = om.NPoliceAssure;
            so.PriseEnChargeAccessoires__c = om.PriseEnChargeAccessoires;
            so.TauxFranchise__c = om.TauxFranchise;
            so.TauxPriseEnCharge__c = om.TauxPriseEnCharge;
            so.TauxResponsabiliteAssure__c = om.TauxResponsabiliteAssure;
            so.TextePrecisantTypeFranchiseD__c = om.TextePrecisantTypeFranchiseD;            
            so.TVAPriseEnChargeParAssureur__c = om.TVAPriseEnChargeParAssureur;
            so.TypeFranchise__c = om.TypeFranchise;
            so.TelephoneLieuExamen__c = om.TelephoneLieuExamen;
            so.VehiculeAExpertiser__c = om.VehiculeAExpertiser;
            so.ZonesChoc__c = om.ZonesChoc;   
            
            //so.DateTarif__c= om.DateTarif;		
            so.Clause1__c= om.Clause1; 
            so.Clause2__c= om.Clause2;
            so.Clause3__c= om.Clause3; 
            so.Clause4__c= om.Clause4;
            so.Clause5__c= om.Clause5;				
            //so.PourcentageRemise__c= om.PourcentageRemise; 
            //so.TypeRemise__c=om.TypeRemise;             
            so.ObservationsConstatLese__c= om.ObservationsConstatLese;
            so.DirectivesParticulieres__c= om.DirectivesParticulieres;
            so.CopieConstatAmiable__c= om.CopieConstatAmiable;
            so.AutresPiecesAdressees__c= om.AutresPiecesAdressees;
            so.RapportPapierNecessaire__c= om.RapportPapierNecessaire;
            so.ConditionsAchatVehicule__c= om.ConditionsAchatVehicule;
            
            so.Origin = 'TE'; 
            so.RecordTypeId = this.RecordTypeId;
            
            //Update dependencies
            so.ClientAssureur__c = clientAssureur.Name;
           	if(emetteur != null){
                so.Emetteur__c = emetteur.Id;
            }  
            if(gestionnaireDossierEmetteur != null){
                so.ContactId = gestionnaireDossierEmetteur.Id;
            } 
            if(tiers != null){
               so.tiers__c = tiers.Id;
            } 
            so.Lese__c = lese.Id;
                     
            so.LieuExamen__c = reparateur.Id;
            
        }
    }
    
    global class ClientAssureur extends DataObject{
        
        global String Name;
        global String CodeSociete;
        global String LibelleSociete;
        
        global String RecordTypeId;
        
        global Account save(){
            Account so = find();
            if(so == null){
                so = createSO();
                insert so;
                System.debug('New Emetteur created (' + so + ')');
            }else{           
                updateSO(so);          
                update so;
                System.debug('Existing Emetteur updated (' + so + ')');
            }           
            return so;
        }
        
        private Account find(){ 
            List<Account> result = [SELECT Id FROM Account WHERE RecordTypeId=:this.RecordTypeId AND CodeSociete__c=:this.CodeSociete]; 
            Account so = null;
            if(!result.isEmpty()){
                so = result[0];   
            }
            return so;
        }
        
        private Account createSO(){
            Account so = new Account();
            updateSO(so);
            so.RecordTypeId = this.RecordTypeId;
            return so;
        }
        private void updateSO(Account so){
            so.Name = this.Name;             
            so.CodeSociete__c = this.CodeSociete;  
            so.LibelleSociete__c = this.LibelleSociete;  
        }
    }
    
    global class Emetteur extends DataObject{
        global String Name;
        global String Phone;
        
        global String TypeEmetteur;
        global String BillingStreet;        
        global String BillingPostalCode;
        global String BillingCity;
        global String BillingCountry;
        global String Civilite; 
        global String Fax;
        
        private OM om;
        private ClientAssureur clientAssureur;
        global String RecordTypeId;
        
        global void init(OM om, ClientAssureur clientAssureur){
            this.om = om;
            this.clientAssureur = clientAssureur;
        }
        global Account save(){
            if(PACIFICA_CODE.equals(clientAssureur.CodeSociete)){
                //Temporary : use inheritence
                return findUGCPacifica();
            }else{
                Account so = find();
                if(so == null){
                    so = createSO();
                    insert so;
                    System.debug('New Emetteur created (' + so + ')');
                }else{           
                    updateSO(so);          
                    update so;
                    System.debug('Existing Emetteur updated (' + so + ')');
                }           
                return so;
            }
            
        }
        
        global Account findUGCPacifica(){
            Account so = null;
            if(om.NumeroSinistre != null && om.NumeroSinistre.length() >= 6){
                String ugsCode = om.NumeroSinistre.substring(om.NumeroSinistre.length() - 6, om.NumeroSinistre.length() - 3);
                List<Account> result = [SELECT Id FROM Account WHERE RecordTypeId=:this.RecordTypeId AND MotCle__c=:ugsCode];                 
                if(!result.isEmpty()){
                    so = result[0];   
                }
            }
           
            return so;
        }
        
        private Account find(){ 
            List<Account> result = [SELECT Id FROM Account WHERE RecordTypeId=:this.RecordTypeId AND Phone=:this.Phone]; 
            Account so = null;
            if(!result.isEmpty()){
                so = result[0];   
            }
            return so;
        }
        
        private Account createSO(){
            Account so = new Account();
            updateSO(so);
            so.RecordTypeId = this.RecordTypeId;
            return so;
        }
        private void updateSO(Account so){
            so.Name = this.Name;
            so.Phone = this.Phone;             
            so.BillingStreet = this.BillingStreet;                    
            so.BillingPostalCode = this.BillingPostalCode;            
            so.BillingCity = this.BillingCity;   
            so.BillingCountry = this.BillingCountry;
            so.Fax = this.Fax;
            so.Civilite__c = this.Civilite;
            so.TypeEmetteur__c = this.TypeEmetteur;           
        }
    }
    global class GestionnaireDossierEmetteur extends DataObject {
        global String LastName;
        global String FirstName;
        global String Phone;
        global String RecordTypeId;        
        private Account emetteur;
        
        global void init(Account emetteur){
            this.emetteur = emetteur;
        }
        
        global Contact save(){
            if(emetteur == null)
                return null;
            Contact so = find();
            if(so == null){                
                so = createSO();  
                System.debug('Create New <GestionnaireDossierEmetteur> (' + so + ')');
                insert so;
                System.debug('New <GestionnaireDossierEmetteur> created (' + so + ')');
            }else{           
                updateSO(so);          
                update so;
                System.debug('Existing <GestionnaireDossierEmetteur updated> (' + so + ')');
            }           
            return so;
        }
        
        private Contact find(){ 
            List<Contact> result = [SELECT Id FROM Contact WHERE RecordTypeId=:this.RecordTypeId AND Phone=:this.Phone]; 
            Contact so = null;
            if(!result.isEmpty()){
                so = result[0];   
            }
            return so;
        }
        
        private Contact createSO(){
            Contact so = new Contact();
            updateSO(so);            
            so.RecordTypeId = this.RecordTypeId;
            return so;
        }
        private void updateSO(Contact so){
            so.AccountId = emetteur.Id;
            so.LastName= this.LastName;
            so.FirstName = this.FirstName;
            so.Phone = this.Phone;
        }
    }
    global class Lese extends DataObject {
        global String Name;       
        global boolean AssureProprietaireVehicule;
        global String NPoliceAssure;
        global String Phone;
        global String AutreTelephone;   
        global String BillingStreet;        
        global String BillingPostalCode;
        global String BillingCity;
        global String BillingCountry;
        global String Civilite; 
        global String RecordTypeId;
        
        global Account save(){
            Account so = find();
            if(so == null){
                so = createSO();
                insert so;
                System.debug('New <lese> created (' + so + ')');
            }else{           
                updateSO(so);          
                update so;
                System.debug('Existing <lese> updated (' + so + ')');
            }           
            return so;
        }
        
        private Account find(){ 
            List<Account> result = [SELECT Id, PersonContactId FROM Account WHERE RecordTypeId=:this.RecordTypeId AND (Phone = :this.Phone OR AutreTelephone__c = :this.AutreTelephone)]; 
            Account so = null;
            if(!result.isEmpty()){
                so = result[0];   
            }
            return so;
        }
        
        private Account createSO(){
            Account so = new Account();
            updateSO(so);
            so.RecordTypeId = this.RecordTypeId;
            return so;
        }
        private void updateSO(Account so){
            so.LastName = this.Name;
            so.AssureProprietaireVehicule__c = this.AssureProprietaireVehicule;
            so.NPoliceAssure__c = this.NPoliceAssure;
            so.BillingStreet = this.BillingStreet;                    
            so.BillingPostalCode = this.BillingPostalCode;            
            so.BillingCity = this.BillingCity;   
            so.BillingCountry = this.BillingCountry;
            so.Phone = this.Phone;  
            so.AutreTelephone__c = this.AutreTelephone;              
            so.Civilite__c = this.Civilite;
        }
    }
    
    global class Tiers extends DataObject{
		global String CodeSociete; 
        global String Name;       
        global String LibelleSociete;
        global String BillingStreet;        
        global String BillingPostalCode;
        global String BillingCity;
        global String BillingCountry;
        global String Civilite; 
        global String RecordTypeId;
        
        global Account save(){
            Account so = null;
            if(String.isNotEmpty(this.Name)){
                so = find();
                if(so == null){
                    so = createSO();
                    insert so;
                    System.debug('New <tiers> created (' + so + ')');
                }else{           
                    updateSO(so);          
                    update so;
                    System.debug('Existing <tiers> updated (' + so + ')');
                }  
            }
         
            return so;
        }
        
        private Account find(){ 
            List<Account> result = [SELECT Id FROM Account WHERE RecordTypeId=:this.RecordTypeId AND Name = :this.Name]; 
            Account so = null;
            if(!result.isEmpty()){
                so = result[0];   
            }
            return so;
        }
        
        private Account createSO(){
            Account so = new Account();
            updateSO(so);
            so.RecordTypeId = this.RecordTypeId;
            return so;
        }
        private void updateSO(Account so){
        	so.CodeSociete__c = this.CodeSociete;
            so.LibelleSociete__c = this.LibelleSociete;
            so.Name = this.Name;
            so.BillingStreet = this.BillingStreet;                    
            so.BillingPostalCode = this.BillingPostalCode;            
            so.BillingCity = this.BillingCity;   
            so.BillingCountry = this.BillingCountry;
            so.Civilite__c = this.Civilite;            
        }
    }
    
    global class Reparateur extends DataObject{  
        global Integer CodeIntervGE;
        global String Name;
        global String Phone;
        global String BillingStreet;        
        global String BillingPostalCode;
        global String BillingCity;
        global String BillingCountry;
        global String Civilite;        
        global String RecordTypeId;
        
        global Account save(){ 
            Account so = find();
            if(so == null){
                so = saveDePassage();
            }
            return so;
        }
        private Account find(){             
            Account so = null;
            if(this.CodeIntervGE != 0 ){
                List<Account> result = [SELECT Id FROM Account WHERE RecordTypeId=:this.RecordTypeId AND CodeIntervGE__c=:this.CodeIntervGE AND EstUnReparateur__c=true];
                if(!result.isEmpty()){
                    so = result[0];
                }
            }
            
            return so;
        }
        
        private Account saveDePassage(){
            List<Account> result = [SELECT Id FROM Account WHERE RecordTypeId=:this.RecordTypeId AND Phone=:this.Phone AND EstUnReparateur__c=true AND EstUnReparateurDePassage__c=true ]; 
            Account so = null;
            if(result.isEmpty()){
                so = createSO();
                so.EstUnReparateurDePassage__c = true;  
                insert so;
                System.debug('New <reparateur de passage> created (' + so + ')');
            }else{
                so = result[0];           
                this.updateSO(so); 
                update so;
                System.debug('Existing <reparateur de passage> updated (' + so + ')');
            } 
            return so;
        }
        
        private Account createSO(){
            Account so = new Account();
            updateSO(so);
            so.RecordTypeId = this.RecordTypeId;
            return so;
        }
        private void updateSO(Account so){
            so.Name = this.Name;
            so.Phone = this.Phone;
            so.BillingStreet = this.BillingStreet;                    
            so.BillingPostalCode = this.BillingPostalCode;            
            so.BillingCity = this.BillingCity;   
            so.BillingCountry = this.BillingCountry;
            so.Civilite__c = this.Civilite;               
            so.EstUnReparateur__c = true;
        }
    }
    
    global class VehiculeOM extends DataObject{  
        global String name;       
        global String ImmatriculationVehicule;
        global String LibelleMarqueVehiculeAssure;
        global String LibelleModeleVehiculeAssure;
        global boolean IndicateurVGAVE;
        global String NumeroSerie;
        global Date DatePremiereMiseCirculation;
        global String DommagesDeclares;
        global String ObservationsConstat;
        global Integer PuissanceReelle;
        global String RecordTypeId;
        
        private Case dossier;
        private Account lese;
        
        global void init(Case dossier, Account lese){
            this.dossier = dossier;
            this.lese = lese;
        }
        
        global Asset save(){
            Asset so = find();
            if(so == null){
                so = createSO();
                insert so;
                System.debug('New <Vehicule OM> created (' + so + ')');
            }else{           
                updateSO(so);          
                update so;
                System.debug('Existing <Vehicule OM> updated (' + so + ')');
            }           
            return so;
        }
        
        private Asset find(){ 
            //We alwayse create Vehicule OM
            return null;
        }
        
        private Asset createSO(){
            Asset so = new Asset();
            updateSO(so);
            so.RecordTypeId = this.RecordTypeId;
            return so;
        }
        private void updateSO(Asset so){
            
            so.name = this.name;
            so.ImmatriculationVehicule__c = this.ImmatriculationVehicule;
            so.LibelleMarqueVehiculeAssure__c = this.LibelleMarqueVehiculeAssure;
            so.LibelleModeleVehiculeAssure__c = this.LibelleModeleVehiculeAssure;            
            so.IndicateurVGAVE__c= this.IndicateurVGAVE;
            so.NumeroSerie__c = this.NumeroSerie;
            so.DatePremiereMiseCirculation__c = this.DatePremiereMiseCirculation;
            so.DommagesDeclares__c = this.DommagesDeclares;
        	so.ObservationsConstat__c = this.ObservationsConstat;
        	so.PuissanceReelle__c = this.PuissanceReelle;
            so.dossier__c = this.dossier.Id;
            so.AccountId = this.lese.Id;
            so.ContactId = this.lese.PersonContactId;
        }
    }   
    
    global class VehiculeSivit extends DataObject{  
        
        global String RecordTypeId;
        
        private VehiculeOM vehiculeOM;
        
        global void init(VehiculeOM vehiculeOM){
            this.vehiculeOM = vehiculeOM;
        }
        
        global Asset save(){
            Asset so = find();
            if(so == null){
                so = createSO();
                insert so;
                System.debug('New <Vehicule Sivit> created (' + so + ')');
            }else{           
                updateSO(so);          
                update so;
                System.debug('Existing <Vehicule Sivit> updated (' + so + ')');
            }           
            return so;
        }
        
        private Asset find(){ 
            //We alwayse create Vehicule SIVIT
            return null;
        }
        
        private Asset createSO(){
            Asset so = new Asset();
            updateSO(so);
            so.RecordTypeId = this.RecordTypeId;
            return so;
        }
        private void updateSO(Asset so){
            so.name = this.vehiculeOM.name;
            so.ImmatriculationVehicule__c = this.vehiculeOM.ImmatriculationVehicule;
            so.dossier__c = this.vehiculeOM.dossier.Id;
            so.AccountId = this.vehiculeOM.lese.Id;
            so.ContactId = this.vehiculeOM.lese.PersonContactId;
        }
    }
}