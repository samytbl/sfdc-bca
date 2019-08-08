/** 
* @author: Adolphe SONKO
* @date : Creation 20/06/2019
* @date : Modification 20/06/2019
* @description : Test class for SM002_CaseTriggerHandler.
*/
@isTest(seeAllData=false)
public class SM002_CaseTriggerHandlerTEST {
  
  static User testUser;
  static Case doss ;
  static list<Case> listDossiers;
    
        
  static {
      
    system.debug('>>>>> START STATIC <<<<<');

    testUser = ObjectUtil.createAdminUser('TestUserTriggerXYZ', ObjectUtil.getProfileAdminId()); 
    testUser.ByPassValidationRules__c = true;
    insert  testUser;

    System.runAs(testUser){
        
        doss = new Case() ;
        doss.RecordTypeId = ObjectUtil.mapRecordTypeIdByDeveloperName('Case').get('Dossier');
        doss.ClientAssureur__c = 'PACIFICA ' ;
        doss.DateMission__c = Date.today() ;
        doss.Origin = 'TE' ;
        doss.DommagesDeclares__c = 'BOrNE suP = 0132586 (chiffre donné en exemple) avec des valeurs de tests VISITE TERRAIN' ;
        doss.CirconstancesSinistre__c = 'VISITE TERRAIN et d autres pour tester TITRE COncervatoire' ;
     //   doss.CommentairesLigne1__c = 'EXPERTISE A TITRE CONSERVATOIRE et d autres pour tester MISSION TERRAIN ou Choc avec animal ou CHASSE AU RECOURS ou RENDEZ VOUS LE 12/11/17 ou VEHICULE CALCINE '  ;
        doss.DateSinistre__c = Date.today() - 3 ;
        doss.ZonesChoc__c = '3;5' ;
        doss.GarantieMiseEnJeu__c = 'R;T;N' ;
        doss.TypeFranchise__c = 'N' ;
        doss.IndicateurReglementDirect__c = 'D' ;
        
        listDossiers = new list<Case> () ;
        listDossiers.add(doss) ;

    }
      
  }


 	static testMethod void testCreatePointsRemarquables() {
        system.debug('>>>TEST METHOD testCreatePointsRemarquables<<<');        
        System.runAs(testUser){  
           
            Test.startTest();
            
     			insert listDossiers ;
				
            Test.stopTest();  
            	
            System.assertEquals(listDossiers[0].DateMission__c  , Date.today());
        }
    }  

}