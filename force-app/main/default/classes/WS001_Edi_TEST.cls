@isTest
public class WS001_Edi_TEST {

    static Map<String, String> recordTypes;
    static WS001_Edi.EdiRequest request;

   static void setup() {
        System.debug('setup');
        recordTypes = new Map<String, String>(); 
        for(RecordType rt : [SELECT Id, DeveloperName FROM RecordType])
           recordTypes.put(rt.DeveloperName, rt.Id);
        createSampleRequest();
        System.debug('setup ' + request);
    }

    static void createSampleRequest(){
         System.debug('recordTypes ' + recordTypes);
        request = new WS001_Edi.EdiRequest();
        OMTest om = new OMTest();
        DossierTest dossier = new DossierTest();
        LeseTest lese = new LeseTest();
        ClientAssureurTest clientAssureur = new ClientAssureurTest();
        EmetteurTest emetteur = new EmetteurTest();
        GestionnaireDossierEmetteurTest gestionnaireDossierEmetteur = new GestionnaireDossierEmetteurTest();
        ReparateurTest reparateur = new ReparateurTest();
        VehiculeOMTest vehiculeOM = new VehiculeOMTest();
        TiersTest tiers = new TiersTest();
        request.referenceId = '1';
        request.om = om.dto;
        request.dossier = dossier.dto;
        request.lese = lese.dto;
        request.clientAssureur = clientAssureur.dto;
        request.emetteur = emetteur.dto;
        request.gestionnaireDossierEmetteur = gestionnaireDossierEmetteur.dto;
        request.reparateur = reparateur.dto;
        request.vehiculeOM = vehiculeOM.dto;
        request.tiers = tiers.dto;

    }
    
    @IsTest
    static void importData(){
        setup();
        System.debug('before start request ' + request);
        Test.startTest();

        System.debug('after request : ' + request);
        WS001_Edi.EdiResponse response = WS001_Edi.importData(request);
        System.assertEquals(true, response.success);
        System.debug('message ' + response.message);

        Test.stopTest();
        
    } 

     virtual class DTOTest{
        WS001_Edi.DataObject dto;

        DTOTest(){
            initSimple();
        }
        public virtual void initSimple(){

        }
    }

    private class OMTest extends DTOTest{
        WS001_Edi.OM dto;

        OMTest(){
            super();
        }

        public override void initSimple(){

            dto = new WS001_Edi.OM();       
            dto.ClientAssureur = 'PACIFICA';
            dto.DateMission = Date.today();
            dto.TypeEmetteur = 'C';
            dto.TitreEmetteur = 'SOC';
            dto.Emetteur = 'PACIFICA';
            dto.AdresseEmetteur = 'TSA 40442';
            dto.CodePostalEmetteur = '92883';
            dto.LocaliteEmetteur = 'NANTERRE CEDEX 9';
            dto.PaysEmetteur = '';
            dto.NomGestionnaire = 'PENOUTY';
            dto.NPoliceAssure = '8947016907';
            dto.NumeroSinistre = '5223488907/S03PTY';
            dto.NDossierEmetteur = '87284641907';
            dto.VehiculeAExpertiser = 'A';
            dto.DateSinistre = Date.today();
            dto.TauxResponsabiliteAssure = 0;
            dto.CodePostalLieuSinistre = '92250';
            dto.LocaliteSinistre = 'ALLEMAGNE';
            dto.CirconstancesSinistre = 'ASS RECUPERE SON VEH DS PARKING EN ALLEMAGNE';
            dto.TitreLese = 'M';
            dto.Lese = 'FOUQUET';
            dto.AdresseLese = 'SYLVAIN 28 RUE KAMM';
            dto.CodePostalLeseOuCodeDept = '67000';
            dto.LocaliteLese = 'STRASBOURG';
            dto.PaysLese = '';
            dto.TelephoneLese = '';
            dto.ImmatriculationVehiculeAssure = 'EF-340-AY';
            dto.ZonesChoc = '8';
            dto.DommagesDeclares = 'ASS. BOUCLIER AVANT';
            dto.ObservationsConstatLese = '';
            dto.GarantieMiseEnJeu = 'T';
            dto.DateSouscriptionContrat = Date.today();
            dto.CodePlafondGarantie = 'E';
            dto.MontantPlafondGarantie = 0;
            dto.PriseEnChargeAccessoires = true;
            dto.LimiteAccessoires = 0;
            dto.GarantieRemorquage = true;
            dto.MontantLimiteRemorquage = 20000;
            dto.TypeFranchise = 'A';
            dto.TextePrecisantTypeFranchiseD = '';
            dto.MontantPlancheOuFixeFranchise = 50000;
            dto.TauxFranchise = 0;
            dto.MontantPlafondFranchise = 0;
            dto.IndicateurReglementDirect = 'T';
            dto.LimiteEventuelleReglementDirect = 0;
            dto.TVAPriseEnChargeParAssureur = 'O';
            dto.SituationMaterielExpertiser = 'C';
            dto.CodeLieuExamen = 'R';
            dto.TitreExamen = 'GAR';
            dto.NomExamen = 'INTER-CARROSSERIE';
            dto.AdresseLieuExamen = '5 RUE EMILE MATHIS';
            dto.CodePostalLieuExamen = '67800';
            dto.LocaliteLieuExamen = 'BISCHHEIM';
            dto.PaysLieuExamen = '';
            dto.DateDepotVehiculeExamen = Date.today();
            dto.DirectivesParticulieres = '';
            dto.CopieConstatAmiable = '';
            dto.AutresPiecesAdressees = '';
            dto.RapportPapierNecessaire = false;
            dto.NumeroMissionBCA = '87284641';
            dto.ConditionsAchatVehicule = '';
            dto.TelephoneLieuExamen = '388342767';
            dto.CodeBCALieuExamen = 87005;
            dto.LibelleMarqueVehiculeAssure = 'AUDI';
            dto.LibelleModeleVehiculeAssure = 'A6 AVANT V';
            dto.ListeCodesGarantiesAcquises = 'LBNTIVR';
            dto.LibelleValeurConventionnelle = '';
            dto.NumeroTelephoneGestionnaire = '559629991';
            dto.PrenomGestionnaire = 'GERALD';
            dto.AssureProprietaireVehicule = false;
            dto.TauxPriseEnCharge = 0;
            dto.CommentairesLigne1 = '';
            dto.DateTarif = Date.today();
            dto.TarifT1 = 0;
            dto.TarifT2 = 0;
            dto.TarifT3 = 0;
            dto.TarifTP = 0;
            dto.TarifI1 = 0;
            dto.TarifI2 = 0;
            dto.TarifI3 = 0;
            dto.TypeRemise = '';
            dto.PourcentageRemise = 14;
            dto.Clause1 = '';
            dto.Clause2 = '';
            dto.Clause3 = '';
            dto.Clause4 = '';
            dto.Clause5 = '';
            dto.NatureMission = '';
        }

    }
    private class DossierTest extends DTOTest{
        WS001_Edi.Dossier dto;

        DossierTest(){
            super();
        }

        public override void initSimple(){

            dto = new WS001_Edi.Dossier();  
            dto.RecordTypeId = recordTypes.get('Dossier');         
        
        }

    }

    private class ClientAssureurTest extends DTOTest{
        WS001_Edi.ClientAssureur dto;

        ClientAssureurTest(){
            super();
        }

        public override void initSimple(){

            dto = new WS001_Edi.ClientAssureur();         
            dto.CodeSociete = '446';
            dto.Name = 'PACIFICA';
            dto.LibelleSociete = 'PACIFICA';
            dto.RecordTypeId = recordTypes.get('Client');         
        
        }

    }

    private class EmetteurTest extends DTOTest{
        WS001_Edi.Emetteur dto;

        EmetteurTest(){
            super();
        }

        public override void initSimple(){

            dto = new WS001_Edi.Emetteur();        
            dto.TypeEmetteur = '';
            dto.Civilite = 'MLLE';
            dto.Name = 'BENESSY';
            dto.BillingStreet = 'FLORIANE LIEU DIT LA REPUBLIQUE CHEZ BENESSY BERNARD';
            dto.BillingPostalCode = '42660';
            dto.BillingCity = 'ST GENEST MALIFAUX';
            dto.BillingCountry = '';
            dto.Phone = '329368181';
            dto.Fax = '';      
            dto.RecordTypeId = recordTypes.get('Emetteur');
        
        }

    }

    private class GestionnaireDossierEmetteurTest extends DTOTest{
        WS001_Edi.GestionnaireDossierEmetteur dto;

        GestionnaireDossierEmetteurTest(){
            super();
        }

        public override void initSimple(){

            dto = new WS001_Edi.GestionnaireDossierEmetteur();        
            dto.LastName = 'PENOUTY';
            dto.Phone = '06123456789';
            dto.FirstName = 'GERALD';       
            dto.RecordTypeId = recordTypes.get('Contacts_Externes'); 
        }

    }

    private class LeseTest extends DTOTest{
        WS001_Edi.Lese dto;

        LeseTest(){
            super();
        }

        public override void initSimple(){

            dto = new WS001_Edi.Lese();
            dto.NPoliceAssure = '6644922906';
            dto.Civilite = 'MLLE';
            dto.Name = 'BENESSY';
            dto.BillingStreet = 'FLORIANE LIEU DIT LA REPUBLIQUE CHEZ BENESSY BERNARD';
            dto.BillingPostalCode = '42660';
            dto.BillingCity = 'ST GENEST MALIFAUX';
            dto.BillingCountry = '';
            dto.Phone = '';
            dto.AssureProprietaireVehicule = false;
            dto.AutreTelephone = '677593554';
            dto.RecordTypeId = recordTypes.get('Lese'); 

        }

    }

    private class ReparateurTest extends DTOTest{
        WS001_Edi.Reparateur dto;

        ReparateurTest(){
            super();
        }

        public override void initSimple(){

            dto = new WS001_Edi.Reparateur();
            dto.Civilite = 'Z';
            dto.Name = 'FOURRIERE DE PARIS';
            dto.BillingStreet = '32 QUAI DE CLICHY';
            dto.BillingPostalCode = '92110';
            dto.BillingCity = 'LEVALLOIS PERRET';
            dto.BillingCountry = 'France';
            dto.Phone = '147312215';
            dto.CodeIntervGE = 27928504;
            dto.RecordTypeId = recordTypes.get('ProfessionnelsAutomobile');       
        }

    }

    private class TiersTest extends DTOTest{
        WS001_Edi.Tiers dto;

        TiersTest(){
            super();
        }

        public override void initSimple(){

            dto = new WS001_Edi.Tiers();
            dto.Civilite = '';
            dto.Name = 'GUERROUMI';
            dto.BillingStreet = '';
            dto.BillingCountry = '';
            dto.BillingPostalCode = '42100';
            dto.BillingCity = '';
            dto.CodeSociete = '369';
            dto.LibelleSociete = 'MACIF';
            dto.RecordTypeId = recordTypes.get('Tiers'); 
        }

    }

     private class VehiculeOMTest extends DTOTest{
        WS001_Edi.VehiculeOM dto;

        VehiculeOMTest(){
            super();
        }

        public override void initSimple(){

            dto = new WS001_Edi.VehiculeOM();
            dto.Name = 'RENAULT';
            dto.NumeroSerie = '';
            dto.IndicateurVGAVE = false;
            dto.DommagesDeclares = '';
            dto.ObservationsConstat = 'NUMERO CONTRAT TIERS : 8268102';
            dto.LibelleMarqueVehiculeAssure = 'RENAULT';
            dto.LibelleModeleVehiculeAssure = '';
            dto.DatePremiereMiseCirculation = Date.today();
            dto.PuissanceReelle = 106;
            dto.RecordTypeId = recordTypes.get('VehiculeOM'); 
        }

    }   

}