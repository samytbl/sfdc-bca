@isTest
public class StatutDossierTest {

     @isTest
     private static void TestCaseInsert(){
		Case c = new Case(NumeroMissionBCA__c  = '00001797');
    	insert c;
		
        PointRemarquable__c pr =new PointRemarquable__c (Name =' test point remarquable',Statut__c ='Nouveau');
         insert pr;

         Task t = new Task (Subject ='Appeler / Rappeler', status='Open');
         insert t;
         
         List<Case> cc = [select NumeroMissionBCA__c from case where id = :pr.Dossier__c];
         System.assertEquals(c.NumeroMissionBCA__c,'00001797');
	}
    
}