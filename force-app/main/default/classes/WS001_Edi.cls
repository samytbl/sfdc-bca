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
        LieuExamen lieuExamen = record.lieuExamen;
        
        
        emetteur.init(om, clientAssureur);
        Account emetteurSO = emetteur.save();   
        gestionnaireDossierEmetteur.init(emetteurSO);
        Contact gestionnaireDossierEmetteurSO = gestionnaireDossierEmetteur.save();    
        Account leseSO = lese.save();
       
        reparateur.init(lieuExamen);
        Account reparateurSO = null;
        if(lieuExamen.isTypeReparateur()){
            reparateurSO = reparateur.save();
        }
        
        Account tiersSo = null;
        if(String.isNotEmpty(tiers.Name)){
            tiersSo = tiers.save();
        }
        User conseillerClientSo = record.conseillerClient.find();
        User expertSo = record.expert.find();
        Account uniteExpertSo = record.uniteExpert.find();
        Account uscSo = record.usc.find();
        
        dossier.init(om, 
                     clientAssureur, 
                     conseillerClientSo,
                     expertSo,
                     uniteExpertSo,
                     uscSo,
                     emetteurSO,                     
                     gestionnaireDossierEmetteurSO, 
                     leseSO, 
                     reparateurSO, 
                     tiersSo);
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
        global UniteExpert uniteExpert;
        global USC usc;
        global ConseillerClient conseillerClient;
        global Expert expert;
        global Lese lese;
        global ClientAssureur clientAssureur;
        global Emetteur emetteur;
        global GestionnaireDossierEmetteur gestionnaireDossierEmetteur;
        global LieuExamen lieuExamen;
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
        
        public virtual String className(){
            return String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        }
    }   
    
    global virtual class UserBCA extends DataObject{
        
        global Integer CodeIntervGE;
        
        public User find(){ 
			User so = null;
			if(CodeIntervGE != null){
				 List<User> result = [SELECT Id FROM User WHERE CodeIntervGE__c=:this.CodeIntervGE];             
				if(!result.isEmpty()){
					so = result[0];   
				}
			}           
            return so;
        }
        
    }
    
    global class ConseillerClient extends UserBCA { }    
    global class Expert extends UserBCA { }
    
    global virtual class AccountBCA extends DataObject{
        
        private Integer CodeIntervGE;        
        global String RecordTypeId;
        global String Phone;
        global String Name;
        global String BillingStreet;        
        global String BillingPostalCode;
        global String BillingCity;
        global String BillingCountry;
        global String Titre; 
        
        public virtual Account find(){ 
            Account so = findByBusinessKey();
            if(so == null && CodeIntervGE != null){
                so = findByLegacyCode();
            }
            return so;
        }
        
        public virtual Account findByBusinessKey(){ 
            List<Account> result = [SELECT Id FROM Account WHERE RecordTypeId=:this.RecordTypeId AND (Phone=:this.Phone or Name = :this.Name)]; 
            Account so = null;
            if(!result.isEmpty()){
                so = result[0];   
            }
            return so;
        }
        
        public Account findByLegacyCode(){ 
            List<Account> result = [SELECT Id FROM Account WHERE RecordTypeId=:this.RecordTypeId AND CodeIntervGE__c=:this.CodeIntervGE]; 
            Account so = null;
            if(!result.isEmpty()){
                so = result[0];   
            }
            return so;
        }
        
        public virtual Account save(){
            Account so = null;
            so = find();
            if(so == null){
                so = createSO();
                insert so;
                System.debug('New <' + this.className() + '> created (' + so + ')');
            }else{           
                updateSO(so);          
                update so;
                System.debug('Existing <' + this.className() + '> updated (' + so + ')');
            }  
            
            return so;
        }
        
        public virtual Account createSO(){
            Account so = new Account();
            updateSO(so);
            so.RecordTypeId = this.RecordTypeId;
            return so;
        }
        public virtual void updateSO(Account so){
            so.Name = this.Name;
            updateCommonSO(so);          
        }
        public virtual void updateCommonSO(Account so){      
            if(CodeIntervGE != null)
                so.CodeIntervGE__c = this.CodeIntervGE;
            so.Phone = this.Phone;
            so.BillingStreet = this.BillingStreet;                    
            so.BillingPostalCode = this.BillingPostalCode;            
            so.BillingCity = this.BillingCity;   
            so.BillingCountry = this.BillingCountry;
            so.Titre__c = this.Titre;            
        }
    }
    global virtual class PersonalAccountBCA extends AccountBCA {
               
        public virtual override void updateSO(Account so){
            super.updateCommonSO(so);
            so.LastName = this.Name;            
        }
    }
    global virtual class ContactBCA extends DataObject{
        private Integer CodeIntervGE;        
        global String LastName;
        global String FirstName;
        global String Phone;
        global String RecordTypeId; 
        
        public virtual Contact find(){ 
            Contact so = findByBusinessKey();
            if(so == null && CodeIntervGE != null){
                so = findByLegacyCode();
            }
            return so;
        }
        
        public virtual Contact findByBusinessKey(){ 
            List<Contact> result = [SELECT Id FROM Contact WHERE RecordTypeId=:this.RecordTypeId AND (Phone=:this.Phone)]; 
            Contact so = null;
            if(!result.isEmpty()){
                so = result[0];   
            }
            return so;
        }
        
        public Contact findByLegacyCode(){ 
            List<Contact> result = [SELECT Id FROM Contact WHERE RecordTypeId=:this.RecordTypeId AND CodeIntervGE__c=:this.CodeIntervGE]; 
            Contact so = null;
            if(!result.isEmpty()){
                so = result[0];   
            }
            return so;
        }
        
        public virtual Contact save(){
            Contact so = null;
            so = find();
            if(so == null){
                so = createSO();
                insert so;
                System.debug('New <' + this.className() + '> created (' + so + ')');
            }else{           
                updateSO(so);          
                update so;
                System.debug('Existing <' + this.className() + '> updated (' + so + ')');
            }  
            
            return so;
        }
        
        public Contact createSO(){
            Contact so = new Contact();
            updateSO(so);
            so.RecordTypeId = this.RecordTypeId;
            return so;
        }
        public virtual void updateSO(Contact so){
            if(CodeIntervGE != null)
                so.CodeIntervGE__c = this.CodeIntervGE;
            so.FirstName = this.FirstName;
            so.LastName = this.LastName;
            so.Phone = this.Phone;          
        }
        
    }
    
    global virtual class AssetBCA extends DataObject{  
        global String name; 
        global String RecordTypeId; 
                
        public virtual Asset save(){
            Asset so = find();
            if(so == null){
                so = createSO();
                insert so;
                System.debug('New <' + this.className() + '> created (' + so + ')');
            }else{           
                updateSO(so);          
                update so;
                System.debug('Existing <' + this.className() + '> updated (' + so + ')');
            }           
            return so;
        }
        
        public virtual Asset find(){             
            return null;
        }
        
        public virtual Asset createSO(){
            Asset so = new Asset();
            updateSO(so);
            so.RecordTypeId = this.RecordTypeId;
            return so;
        }
        public virtual void updateSO(Asset so){
            
            so.name = this.name;           
        }
    }
    
    global class ClientAssureur extends AccountBCA{
        
        global String CodeSociete;    
        global String LibelleSociete; 
        
        public override void updateSO(Account so){
            super.updateSO(so);
            so.CodeSociete__c = this.CodeSociete;
            so.LibelleSociete__c = this.LibelleSociete;
        }
        
    }
    global class USC extends AccountBCA {
        public override Account findByBusinessKey(){
            return null;
        }
    }
    global class UniteExpert extends AccountBCA {
        public override Account findByBusinessKey(){
            return null;
        }
    }
    
    global class Emetteur extends AccountBCA{        
        global String TypeEmetteur;
        global String Fax;
        
        private OM om;
        private ClientAssureur clientAssureur;
        
        global void init(OM om, ClientAssureur clientAssureur){
            this.om = om;
            this.clientAssureur = clientAssureur;
        }
        public override Account save(){
            if(PACIFICA_CODE.equals(clientAssureur.CodeSociete)){                
                return findUGCPacifica();
            }else{                 
                return super.save();
            }
            
        }
        
        private Account findUGCPacifica(){
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
        
        public override void updateSO(Account so){
            super.updateSO(so);
            so.Fax = this.Fax;
            so.TypeEmetteur__c = this.TypeEmetteur;           
        }
    }
    global class GestionnaireDossierEmetteur extends ContactBCA {
        
        private Account emetteur;
        
        global void init(Account emetteur){
            this.emetteur = emetteur;
        }
        
        public override Contact save(){
            if(emetteur == null)
                return null;                     
            return super.save();
        }
        
        public override void updateSO(Contact so){
            super.updateSO(so);
            so.AccountId = emetteur.Id;            
        }
        public override String className(){
            return 'GestionnaireDossierEmetteur';
        }
    }
    global class Lese extends PersonalAccountBCA {
        global boolean AssureProprietaireVehicule;
        global String NPoliceAssure;
        global String AutreTelephone;
        global String RecordTypeId;
        
        public override Account findByBusinessKey(){ 
            List<Account> result = [SELECT Id, PersonContactId FROM Account WHERE RecordTypeId=:this.RecordTypeId AND (Phone = :this.Phone OR AutreTelephone__c = :this.AutreTelephone)]; 
            Account so = null;
            if(!result.isEmpty()){
                so = result[0];   
            }
            return so;
        }
        
        public override void updateSO(Account so){
            super.updateSO(so);
            so.AssureProprietaireVehicule__c = this.AssureProprietaireVehicule;
            so.NPoliceAssure__c = this.NPoliceAssure;            
            so.AutreTelephone__c = this.AutreTelephone; 
        }
    }
    
    global class Tiers extends AccountBCA{
        global String CodeSociete;    
        global String LibelleSociete; 
        global String LibelleMarqueVehiculeTiers;
        global String LibelleModeleVehiculeTiers;
        global String ImmatriculationVehiculeTiers;
        global String DommagesDeclaresTiers;
        global String ObservationsConstatTiers;
        
        public override void updateSO(Account so){
            super.updateSO(so);
            so.CodeSociete__c = this.CodeSociete;
            so.LibelleSociete__c = this.LibelleSociete;
            so.LibelleMarqueVehiculeTiers__c = this.LibelleMarqueVehiculeTiers;
            so.LibelleModeleVehiculeTiers__c = this.LibelleModeleVehiculeTiers;
            so.ImmatriculationVehiculeTiers__c = this.ImmatriculationVehiculeTiers;
            so.DommagesDeclaresTiers__c = this.DommagesDeclaresTiers;
            so.ObservationsConstatTiers__c = this.ObservationsConstatTiers;
        }
    }
    
    global class LieuExamen extends AccountBCA{  
        global String CodeLieuExamen;
		global Integer CodeBCALieuExamen;
       
        public boolean isTypeReparateur(){
            return 'R'.equals(CodeLieuExamen);
        }
        
    }
    
    global class Reparateur extends AccountBCA {  
        
        global LieuExamen lieuExamen;       
        
        public void init(LieuExamen lieuExamen){
            this.Name = lieuExamen.Name;
            this.Phone = lieuExamen.Phone;
            this.BillingStreet = lieuExamen.BillingStreet;      
            this.BillingPostalCode = lieuExamen.BillingPostalCode;
            this.BillingCity = lieuExamen.BillingCity;
            this.BillingCountry = lieuExamen.BillingCountry;
            this.Titre = lieuExamen.Titre;
        }
        public override Account findByBusinessKey(){ 
            List<Account> result = [SELECT Id FROM Account WHERE RecordTypeId=:this.RecordTypeId AND Phone=:this.Phone AND EstUnReparateur__c=true AND EstUnReparateurDePassage__c=true]; 
            Account so = null;
            if(!result.isEmpty()){
                so = result[0];   
            }
            return so;
        }
        public override Account createSO(){
            Account so = super.createSO();              
            so.EstUnReparateur__c = true;
            so.EstUnReparateurDePassage__c = true;
            return so;
        }
        
    }
    
    global class VehiculeOM extends AssetBCA {  
        
        global String ImmatriculationVehicule;
        global String LibelleMarqueVehicule;
        global String LibelleModeleVehicule;
        global boolean IndicateurVGAVE;
        global String NumeroSerie;
        global Date DateMiseCirculationReelle;
        global Date DatePremiereMiseCirculation;
        global String DommagesDeclares;
        global String ObservationsConstat;
        global Integer PuissanceReelle;
        global String VehiculeAExpertiser;
        global String CategorieMateriel;
        private Case dossier;
        private Account lese;
        
        public void init(Case dossier, Account lese){
            this.dossier = dossier;
            this.lese = lese;
        }
          
        public override void updateSO(Asset so){
            super.updateSO(so); 
            so.ImmatriculationVehicule__c = this.ImmatriculationVehicule;
            so.LibelleMarqueVehicule__c = this.LibelleMarqueVehicule;
            so.LibelleModeleVehicule__c = this.LibelleModeleVehicule;            
            so.IndicateurVGAVE__c= this.IndicateurVGAVE;
            so.NumeroSerie__c = this.NumeroSerie;
            so.DateMiseCirculationReelle__c = this.DateMiseCirculationReelle;
            //so.DatePremiereMiseCirculation__c = this.DatePremiereMiseCirculation;
            so.DommagesDeclares__c = this.DommagesDeclares;
            so.ObservationsConstat__c = this.ObservationsConstat;
            so.PuissanceReelle__c = this.PuissanceReelle;
            so.VehiculeAExpertiser__c = this.VehiculeAExpertiser;            
            so.CategorieMateriel__c = this.CategorieMateriel;
            so.dossier__c = this.dossier.Id;
            so.AccountId = this.lese.Id;
            so.ContactId = this.lese.PersonContactId;
        }
    }   
    
    global class OM extends DataObject {
        
        global String ClientCode;
        global String ClientName;
        global Date DateMission;
        global String TypeEmetteur;
        global String TitreEmetteur;
        global String Emetteur;
        global String AdresseEmetteur;
        global String CodePostalEmetteur;
        global String LocaliteEmetteur;
        global String PaysEmetteur;
        global String TelephoneEmetteur;
        global String NomGestionnaire;
        global String CodeSociete;
        global String NPoliceAssure;
        global String NumeroSinistre;
        global String NDossierEmetteur;
        global String VehiculeAExpertiser;
        global Date DateSinistre;
        global Integer TauxResponsabiliteAssure;
        global String CodePostalLieuSinistre;
        global String LocaliteSinistre;
        global String CirconstancesSinistre;
        global String TitreLese;
        global String Lese;
        global String AdresseLese;
        global String CodePostalLeseOuCodeDept;
        global String LocaliteLese;
        global String PaysLese;
        global String TelephoneLese;
        global String LibelleMarqueVehiculeAssure;
        global String LibelleModeleVehiculeAssure;
        global String ImmatriculationVehiculeAssure;
        global String NumeroSerieVehiculeAssure;
        global Date DateMiseCirculationReelle;
        global boolean IndicateurVGAVE;
        global String ZonesChoc;
        global String DommagesDeclares;
        global String ObservationsConstatLese ;
        global String TitreTiers;
        global String NomTiers;
        global String AdresseTiers;        
        global String PaysTiers;
        global String codePostalTiers;
        global String LocaliteTiers;
        global String CodeSocieteTiers;
        global String LibelleSocieteTiers;
        global String LibelleMarqueVehiculeTiers;
        global String LibelleModeleVehiculeTiers;
        global String ImmatriculationVehiculeTiers;
        global String DommagesDeclaresTiers;
        global String ObservationsConstatTiers;
        global String GarantieMiseEnJeu;
        global Date DateSouscriptionContrat;
        global String CodePlafondGarantie;
        global Integer MontantPlafondGarantie;
        global boolean PriseEnChargeAccessoires;
        global Integer LimiteAccessoires;
        global boolean GarantieRemorquage;
        global Integer MontantLimiteRemorquage;
        global String TypeFranchise;
        global String TextePrecisantTypeFranchiseD;
        global Integer MontantPlancheOuFixeFranchise;
        global Integer TauxFranchise;
        global Integer MontantPlafondFranchise;
        global String IndicateurReglementDirect;
        global Integer LimiteEventuelleReglementDirect;
        global String TVAPriseEnChargeParAssureur;
        global String SituationMaterielExpertiser;
        global String CodeLieuExamen;
        global String TitreExamen;
        global String NomExamen;
        global String AdresseLieuExamen;
        global String CodePostalLieuExamen;
        global String LocaliteLieuExamen;
        global String PaysLieuExamen;
        global Date DateDepotVehiculeExamen;
        global String DirectivesParticulieres ;
        global String CopieConstatAmiable     ;
        global String AutresPiecesAdressees   ;
        global Integer FaxEmetteur;
        global boolean RapportPapierNecessaire;
        global String NumeroMissionBCA;
        global String ConditionsAchatVehicule ;
        global String TelephoneLieuExamen;
        global Integer CodeBCALieuExamen ;
        // global String MarqueVehiculeAssure;
        // global String ModeleVehiculeAssure;
        global Date DatePremiereMiseCirculation;
        global String ListeCodesGarantiesAcquises;
        global String LibelleValeurConventionnelle;
        global String NumeroTelephoneGestionnaire;
        global String PrenomGestionnaire;
        global boolean AssureProprietaireVehicule;
        global Integer PuissanceReelle;
        global Integer TauxPriseEnCharge;
        global String InfoConstat;
        global String Commentaires;
        global Date DateTarif;
        global Double TarifT1;
        global Double TarifT2;
        global Double TarifT3;
        global Double TarifTP;
        global Double TarifI1;
        global Double TarifI2;
        global Double TarifI3;
        global String TypeRemise;
        global Integer PourcentageRemise;
        global String Clause1;
        global String Clause2;
        global String Clause3;
        global String Clause4;
        global String Clause5;
        global String NatureMission;        
        global String CategorieMateriel;
        global String GarantieMiseEnJeuDeux;
        private Case dossier;
        
        public void init(Case dossier){
            this.dossier = dossier;           
        }
        
        public Ordre_de_Mission__c save(){
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
        public Ordre_de_Mission__c find(){  
            //We create always the <Ordre de Mission>
            return null;
        }
        
        public Ordre_de_Mission__c createSO(){
            Ordre_de_Mission__c so = new Ordre_de_Mission__c();
            updateSO(so);
            return so;
        }
        public void updateSO(Ordre_de_Mission__c so){
            
            so.ClientCode__c = this.ClientCode;
            so.ClientName__c = this.ClientName;
            so.DateMission__c = this.DateMission;
            so.TypeEmetteur__c = this.TypeEmetteur;
            so.TitreEmetteur__c = this.TitreEmetteur;
            so.Emetteur__c = this.Emetteur;
            so.AdresseEmetteur__c = this.AdresseEmetteur;
            so.CodePostalEmetteur__c = this.CodePostalEmetteur;
            so.LocaliteEmetteur__c = this.LocaliteEmetteur;
            so.PaysEmetteur__c = this.PaysEmetteur;
            so.TelephoneEmetteur__c = this.TelephoneEmetteur;
            so.NomGestionnaire__c = this.NomGestionnaire;
            so.CodeSociete__c = this.CodeSociete;
            so.NPoliceAssure__c = this.NPoliceAssure;
            so.NumeroSinistre__c = this.NumeroSinistre;
            so.NDossierEmetteur__c = this.NDossierEmetteur;
            so.VehiculeAExpertiser__c = this.VehiculeAExpertiser;
            so.DateSinistre__c = this.DateSinistre;
            so.TauxResponsabiliteAssure__c = this.TauxResponsabiliteAssure;
            so.CodePostalLieuSinistre__c = this.CodePostalLieuSinistre;
            so.LocaliteSinistre__c = this.LocaliteSinistre;
            so.CirconstancesSinistre__c = this.CirconstancesSinistre;
            so.TitreLese__c = this.TitreLese;
            so.Lese__c = this.Lese;
            so.AdresseLese__c = this.AdresseLese;
            so.CodePostalLeseOuCodeDept__c = this.CodePostalLeseOuCodeDept;
            so.LocaliteLese__c = this.LocaliteLese;
            so.PaysLese__c = this.PaysLese;
            so.TelephoneLese__c = this.TelephoneLese;
 			so.LibelleMarqueVehiculeAssure__c = this.LibelleMarqueVehiculeAssure;
            so.LibelleModeleVehiculeAssure__c = this.LibelleModeleVehiculeAssure;
            so.ImmatriculationVehiculeAssure__c = this.ImmatriculationVehiculeAssure;
            so.NumeroSerieVehiculeAssure__c = this.NumeroSerieVehiculeAssure;
            so.DateMiseCirculationReelle__c = this.DateMiseCirculationReelle;
            so.IndicateurVGAVE__c = this.IndicateurVGAVE;
            so.ZonesChoc__c = this.ZonesChoc;
            so.DommagesDeclares__c = this.DommagesDeclares;
            so.ObservationsConstatLese__c = this.ObservationsConstatLese;
            so.TitreTiers__c = this.TitreTiers;
            so.NomTiers__c = this.NomTiers;
            so.AdresseTiers__c = this.AdresseTiers;
            so.PaysTiers__c = this.PaysTiers;
            so.CodePostalTiers__c = this.CodePostalTiers;
            so.LocaliteTiers__c = this.LocaliteTiers;
            so.CodeSocieteTiers__c = this.CodeSocieteTiers;
            so.LibelleSocieteTiers__c = this.LibelleSocieteTiers;
            so.LibelleMarqueVehiculeTiers__c = this.LibelleMarqueVehiculeTiers;
            so.LibelleModeleVehiculeTiers__c = this.LibelleModeleVehiculeTiers;
            so.ImmatriculationVehiculeTiers__c = this.ImmatriculationVehiculeTiers;
            so.DommagesDeclaresTiers__c = this.DommagesDeclaresTiers;
            so.ObservationsConstatTiers__c = this.ObservationsConstatTiers;
            so.GarantieMiseEnJeu__c = this.GarantieMiseEnJeu;
            so.DateSouscriptionContrat__c = this.DateSouscriptionContrat;
            so.CodePlafondGarantie__c = this.CodePlafondGarantie;
            so.MontantPlafondGarantie__c = this.MontantPlafondGarantie;
            so.PriseEnChargeAccessoires__c = this.PriseEnChargeAccessoires;
            so.LimiteAccessoires__c = this.LimiteAccessoires;
            so.GarantieRemorquage__c = this.GarantieRemorquage;
            so.MontantLimiteRemorquage__c = this.MontantLimiteRemorquage;
            so.TypeFranchise__c = this.TypeFranchise;
            so.TextePrecisantTypeFranchiseD__c = this.TextePrecisantTypeFranchiseD;
            so.MontantPlancheOuFixeFranchise__c = this.MontantPlancheOuFixeFranchise;
            so.TauxFranchise__c = this.TauxFranchise;
            so.MontantPlafondFranchise__c = this.MontantPlafondFranchise;
            so.IndicateurReglementDirect__c = this.IndicateurReglementDirect;
            so.LimiteEventuelleReglementDirect__c = this.LimiteEventuelleReglementDirect;
            so.TVAPriseEnChargeParAssureur__c = this.TVAPriseEnChargeParAssureur;
            so.SituationMaterielExpertiser__c = this.SituationMaterielExpertiser;
            so.CodeLieuExamen__c = this.CodeLieuExamen;
            //so.TitreExamen__c = this.TitreExamen;
            so.NomExamen__c = this.NomExamen;
            so.AdresseLieuExamen__c = this.AdresseLieuExamen;
            so.CodePostalLieuExamen__c = this.CodePostalLieuExamen;
            so.LocaliteLieuExamen__c = this.LocaliteLieuExamen;
            so.PaysLieuExamen__c = this.PaysLieuExamen;
            so.DateDepotVehiculeExamen__c = this.DateDepotVehiculeExamen;
            so.DirectivesParticulieres__c = this.DirectivesParticulieres;
            so.CopieConstatAmiable__c = this.CopieConstatAmiable;
            so.AutresPiecesAdressees__c = this.AutresPiecesAdressees;
            so.FaxEmetteur__c = this.FaxEmetteur;
            so.RapportPapierNecessaire__c = this.RapportPapierNecessaire;
            so.NumeroMissionBCA__c = this.NumeroMissionBCA;
            so.ConditionsAchatVehicule__c = this.ConditionsAchatVehicule;
            so.TelephoneLieuExamen__c = this.TelephoneLieuExamen;
            so.CodeBCALieuExamen__c = this.CodeBCALieuExamen;
            //so.MarqueVehiculeAssure__c = this.//MarqueVehiculeAssure;
            //so.ModeleVehiculeAssure__c = this.//ModeleVehiculeAssure;
            so.DatePremiereMiseCirculation__c = this.DatePremiereMiseCirculation;
            so.ListeCodesGarantiesAcquises__c = this.ListeCodesGarantiesAcquises;
            so.LibelleValeurConventionnelle__c = this.LibelleValeurConventionnelle;
            so.NumeroTelephoneGestionnaire__c = this.NumeroTelephoneGestionnaire;
            so.PrenomGestionnaire__c = this.PrenomGestionnaire;
            so.AssureProprietaireVehicule__c = this.AssureProprietaireVehicule;
            so.PuissanceReelle__c = this.PuissanceReelle;
            so.TauxPriseEnCharge__c = this.TauxPriseEnCharge;
            so.InfoConstat__c = this.InfoConstat;
            //so.Commentaires__c = this.Commentaires;
            so.DateTarif__c = this.DateTarif;
            so.TarifT1__c = this.TarifT1;
            so.TarifT2__c = this.TarifT2;
            so.TarifT3__c = this.TarifT3;
            so.TarifTP__c = this.TarifTP;
            so.TarifI1__c = this.TarifI1;
            so.TarifI2__c = this.TarifI2;
            so.TarifI3__c = this.TarifI3;
            so.TypeRemise__c = this.TypeRemise;
            so.PourcentageRemise__c = this.PourcentageRemise;
            so.Clause1__c = this.Clause1;
            so.Clause2__c = this.Clause2;
            so.Clause3__c = this.Clause3;
            so.Clause4__c = this.Clause4;
            so.Clause5__c = this.Clause5;
            so.NatureMission__c = this.NatureMission;
            so.CategorieMateriel__c = this.CategorieMateriel;
            so.GarantieMiseEnJeuDeux__c = this.GarantieMiseEnJeuDeux;
            
            //Update dependencies           
            so.Dossier__c = dossier.Id;
        }
        
    }
    
    global class Dossier extends DataObject {
        
        private Integer NumDossierGE;
        global String RecordTypeId;
        global OM om;
        global ClientAssureur clientAssureur; 
        global User conseillerClient;
        global User expert;
        global Account uniteExpert;
        global Account usc;
        global Account emetteur; 
        global Contact gestionnaireDossierEmetteur;
        global Account lese;
        global Account reparateur;
        global Account tiers;
        
        global void init(OM om, 
                         ClientAssureur clientAssureur, 
                         User conseillerClient,
                         User expert,
                         Account uniteExpert,
                         Account usc,
                         Account emetteur, 
                         Contact gestionnaireDossierEmetteur, 
                         Account lese, 
                         Account reparateur, 
                         Account tiers){
            this.om = om;
            this.conseillerClient = conseillerClient;
            this.expert = expert;
            this.uniteExpert = uniteExpert;
            this.usc = usc;                 
            this.clientAssureur = clientAssureur;
            this.emetteur = emetteur;
            this.gestionnaireDossierEmetteur = gestionnaireDossierEmetteur;
            this.lese = lese;
            this.reparateur = reparateur;
            this.tiers = tiers;
        }
        
        public Case save(){
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
        
        public Case find(){ 
			Case so = null;
			if(NumDossierGE != null){
				 List<Case> result = [SELECT Id FROM Case WHERE NumDossierGE__c=:this.NumDossierGE];             
				if(!result.isEmpty()){
					so = result[0];   
				}
			}           
            return so;
        }
        
        public Case createSO(){
            Case so = new Case();
            so.Origin = 'TE';           
            updateSO(so);
            return so;
        }
        
        public void updateSO(Case so){
            if(NumDossierGE != null)
                so.NumDossierGE__c = this.NumDossierGE;
            so.DateMission__c = om.DateMission;
            so.CodeSociete__c = om.CodeSociete;   
            so.NPoliceAssure__c = om.NPoliceAssure;
            so.NumeroSinistre__c = om.NumeroSinistre;
            so.NDossierEmetteur__c = om.NDossierEmetteur;
            so.VehiculeAExpertiser__c = om.VehiculeAExpertiser;
            so.DateSinistre__c = om.DateSinistre;
            so.TauxResponsabiliteAssure__c = om.TauxResponsabiliteAssure;
            so.CodePostalLieuSinistre__c = om.CodePostalLieuSinistre;
            so.LocaliteSinistre__c = om.LocaliteSinistre;
            so.CirconstancesSinistre__c = om.CirconstancesSinistre;
            //so.TitreLese__c = om.TitreLese;
            //so.Lese__c = om.Lese;
            //so.AdresseLese__c = om.AdresseLese;
            //so.CodePostalLeseOuCodeDept__c = om.CodePostalLeseOuCodeDept;
            //so.LocaliteLese__c = om.LocaliteLese;
            //so.PaysLese__c = om.PaysLese;
            //so.TelephoneLese__c = om.TelephoneLese;
            //so.LibelleMarqueVehiculeAssure__c = om.LibelleMarqueVehiculeAssure;
            //so.LibelleModeleVehiculeAssure__c = om.LibelleModeleVehiculeAssure;
            so.ImmatriculationVehiculeAssure__c = om.ImmatriculationVehiculeAssure;
            so.ZonesChoc__c = om.ZonesChoc;
            so.DommagesDeclares__c = om.DommagesDeclares;
            so.ObservationsConstatLese__c = om.ObservationsConstatLese;
            so.GarantieMiseEnJeu__c = om.GarantieMiseEnJeu;
            so.DateSouscriptionContrat__c = om.DateSouscriptionContrat;
            so.CodePlafondGarantie__c = om.CodePlafondGarantie;
            so.MontantPlafondGarantie__c = om.MontantPlafondGarantie;
            so.PriseEnChargeAccessoires__c = om.PriseEnChargeAccessoires;
            so.LimiteAccessoires__c = om.LimiteAccessoires;
            so.GarantieRemorquage__c = om.GarantieRemorquage;
            so.MontantLimiteRemorquage__c = om.MontantLimiteRemorquage;
            so.TypeFranchise__c = om.TypeFranchise;
            so.TextePrecisantTypeFranchiseD__c = om.TextePrecisantTypeFranchiseD;
            so.MontantPlancheOuFixeFranchise__c = om.MontantPlancheOuFixeFranchise;
            so.TauxFranchise__c = om.TauxFranchise;
            so.MontantPlafondFranchise__c = om.MontantPlafondFranchise;
            so.IndicateurReglementDirect__c = om.IndicateurReglementDirect;
            so.LimiteEventuelleReglementDirect__c = om.LimiteEventuelleReglementDirect;
            so.TVAPriseEnChargeParAssureur__c = om.TVAPriseEnChargeParAssureur;
            so.SituationMaterielExpertiser__c = om.SituationMaterielExpertiser;
            so.CodeLieuExamen__c = om.CodeLieuExamen;
            //so.TitreExamen__c = om.TitreExamen;
            so.NomExamen__c = om.NomExamen;
            so.AdresseLieuExamen__c = om.AdresseLieuExamen;
            so.CodePostalLieuExamen__c = om.CodePostalLieuExamen;
            //so.LocaliteLieuExamen__c = om.LocaliteLieuExamen;
            //so.PaysLieuExamen__c = om.PaysLieuExamen;
            //so.DateDepotVehiculeExamen__c = om.DateDepotVehiculeExamen;
            so.DirectivesParticulieres__c = om.DirectivesParticulieres;
            so.CopieConstatAmiable__c = om.CopieConstatAmiable;
            so.AutresPiecesAdressees__c = om.AutresPiecesAdressees;
            so.RapportPapierNecessaire__c = om.RapportPapierNecessaire;
            so.NumeroMissionBCA__c = om.NumeroMissionBCA;
            so.ConditionsAchatVehicule__c = om.ConditionsAchatVehicule;
            so.TelephoneLieuExamen__c = om.TelephoneLieuExamen;
            //so.CodeBCALieuExamen__c = om.CodeBCALieuExamen;
            //so.MarqueVehiculeAssure__c = om.//MarqueVehiculeAssure;
            //so.ModeleVehiculeAssure__c = om.//ModeleVehiculeAssure;
            so.ListeCodesGarantiesAcquises__c = om.ListeCodesGarantiesAcquises;
            so.LibelleValeurConventionnelle__c = om.LibelleValeurConventionnelle;
            //so.NumeroTelephoneGestionnaire__c = om.NumeroTelephoneGestionnaire;
            //so.PrenomGestionnaire__c = om.PrenomGestionnaire;
            //so.AssureProprietaireVehicule__c = om.AssureProprietaireVehicule;
            so.TauxPriseEnCharge__c = om.TauxPriseEnCharge;
            //so.CommentairesLigne1__c = om.Commentaires;
            so.DateTarif__c = om.DateTarif;
            so.TarifT1__c = om.TarifT1;
            so.TarifT2__c = om.TarifT2;
            so.TarifT3__c = om.TarifT3;
            so.TarifTP__c = om.TarifTP;
            so.TarifI1__c = om.TarifI1;
            so.TarifI2__c = om.TarifI2;
            so.TarifI3__c = om.TarifI3;
            so.TypeRemise__c = om.TypeRemise;
            so.PourcentageRemise__c = om.PourcentageRemise;
            so.Clause1__c = om.Clause1;
            so.Clause2__c = om.Clause2;
            so.Clause3__c = om.Clause3;
            so.Clause4__c = om.Clause4;
            so.Clause5__c = om.Clause5;
            so.NatureMission__c = om.NatureMission;
            so.GarantieMiseEnJeuDeux__c = om.GarantieMiseEnJeuDeux;            
            
            so.Origin = 'TE'; 
            so.RecordTypeId = this.RecordTypeId;
            
            //Update dependencies
            so.ClientAssureur__c = clientAssureur.Name;
            
            if(conseillerClient != null) so.OwnerId = conseillerClient.Id;
            if(expert != null) so.ExpertTitulaire__c = expert.Id;
            if(uniteExpert != null) so.UniteDexpert__c = uniteExpert.Id;
            if(usc != null) so.USC__c = usc.Id;                
            if(emetteur != null)so.Emetteur__c = emetteur.Id;
             
            if(gestionnaireDossierEmetteur != null) so.ContactId = gestionnaireDossierEmetteur.Id;
            if(tiers != null) so.tiers__c = tiers.Id;
            if(reparateur != null) so.reparateur__c = reparateur.Id;
            
            so.Lese__c = lese.Id;
            
        }
    }
}