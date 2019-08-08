/** 
* @author: Adolphe SONKO
* @date : Creation 07/06/2019
* @date : Modification 15/07/2019
* @description : Test class for SM001_VehiculeTriggerHandler.
*/
@isTest(seeAllData=false)
public class SM001_VehiculeTriggerHandlerTEST {
    
  static User testUser;
  static Asset testVehicSivit ;
  static list<Asset> vehiculeList;
  static Account acc;
  static Contact con;
  static SivitParameters__c param_setting ;
    
    
  static {
      
    system.debug('>>>>> START STATIC <<<<<');

    testUser = ObjectUtil.createAdminUser('TestUserTriggerXYZ', ObjectUtil.getProfileAdminId()); 
    testUser.ByPassValidationRules__c = true;
    insert  testUser;

    System.runAs(testUser){
        
		acc = ObjectUtil.createAccount('Test Account Sivit');
        acc.RecordTypeId = ObjectUtil.mapRecordTypeIdByDeveloperName('Account').get('Emetteur');
     	insert acc ;
        
        con = ObjectUtil.createContact('Test Contact Sivit');
        con.RecordTypeId = ObjectUtil.mapRecordTypeIdByDeveloperName('Contact').get('Contacts_Externes');
        con.AccountId = acc.Id ;
     	insert con ;
        
        param_setting = new SivitParameters__c() ;
        param_setting.Name = Label.TECH_SIVIT_PARAMETERS_NAME ;
        param_setting.BaseURL__c = 'www.testsivit.com' ;
        
        insert param_setting ;
    }
      
  }


 	static testMethod void testInsertVehiculeSivit() {
        system.debug('>>>TEST METHOD testInsertVehiculeSivit<<<');        
        System.runAs(testUser){  
           
            Test.startTest();
            	Test.setMock(HttpCalloutMock.class, new MCK001_SivitHttpResponse());
            
                testVehicSivit = new Asset (
                    RecordTypeId = ObjectUtil.mapRecordTypeIdByDeveloperName('Asset').get(system.Label.VehiculeOMRecordTypeDeveloperName),
                    Name = 'Test Vehic Sivit',
                    AccountId = acc.Id,
                    ContactId = con.Id,
                    ImmatriculationVehicule__c = 'DX-497-LB'
                ) ;
				
            	insert testVehicSivit ;
 
            Test.stopTest();  
            	
            System.assertEquals(testVehicSivit.ImmatriculationVehicule__c ,'DX-497-LB');
        }
    }    

}