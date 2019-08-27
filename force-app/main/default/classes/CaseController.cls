/** 
* @author: Adolphe SONKO
* @date : Creation 05/08/2019
* @date : Modification 05/08/2019
* @description : This Class is a controller for case .
*/
public class CaseController {
    
	private static String  CLASS_NAME = CaseController.class.getName();
    /**
     * @author: Adolphe SONKO
     * @date : Création 05/08/2019
     * @date : Modification 05/08/2019
     * @description : Call the Doc Num WS in order to get documents linked to to numDos.
     * @param : List<Id> caseIds.
     * @return : -Non-
     */
    
    @auraEnabled
    public static List<File> getDocNumFilescallout(List<Id> caseIds){
      String methodName = 'getDocNumFilescallout'; 
      
      ObjectUtil.debugLogBegin(CLASS_NAME, methodName, ' [caseIds] : ' + caseIds);
      
      List<File> documentsToReturn = new List<File>();
	  List<TypeDocument__mdt> documentTypes = new List<TypeDocument__mdt>(); 
      Map<String, String> mapLibdocByDocType = new Map<String, String>() ;  
        
      //Savepoint sp = Database.setSavepoint();  
      try{  
           Case doss = DM002_Case.getListByIds(caseIds)[0];
           
           //Get the URL of the environment 
           DocNum__c param_setting = APU001_ConfigUtils.dnParameter;
          
           //Get the list type of document
           documentTypes = [ SELECT CodeQualifDoc__c,DeveloperName, LibQualifDoc__c FROM TypeDocument__mdt ] ;
           for(TypeDocument__mdt doc: documentTypes){
               mapLibdocByDocType.put(doc.CodeQualifDoc__c, doc.LibQualifDoc__c) ;
           }
           system.debug('ADBS param_setting     : ' + param_setting); 
                              
      //     for(Case  d: listDossiers){
           if( String.isNotEmpty(String.valueOf(doss.NumDossierGE__c))){
                //   HttpRequest request = EM002_Case.getDocNumFiles(param_setting, String.valueOf(doss.NumDossierGE__c) );
                  HttpRequest request = EM002_Case.getDocNumFiles(param_setting, '26345365' );
                  system.debug('ADBS request     : ' + request);
                  
                  //Send request 
                  HttpResponse respoDocNum = APU002_WebserviceUtils.sendRequest(request);
                  system.debug('ADBS response     : ' + respoDocNum);
                  system.debug('ADBS response body: ' + respoDocNum.getBody());
                  system.debug('ADBS response getStatus   : ' + respoDocNum.getStatus());
                  system.debug('ADBS response getStatusCode  : ' + respoDocNum.getStatusCode());
                  
                  if(respoDocNum != null && respoDocNum.getStatusCode() == 200){
                      String jsonDocNumDocuments = respoDocNum.getBody();
                      
                      if(!String.isEmpty(jsonDocNumDocuments)){
                          system.debug('$$$$$$$$$$$ JE SUIS ICI');
                           documentsToReturn = (List<File>)JSON.deserialize(jsonDocNumDocuments, List<File>.class);
                          system.debug('Result WS GET FILES FROM DOC NUM : '+documentsToReturn);
  						  
                          if(documentsToReturn != null && documentsToReturn.size() > 0){
                              for(File f: documentsToReturn){
                                  for(String t: mapLibdocByDocType.keySet()){
                                      if(f.nomFichier.startsWith(t) || f.nomFichier.contains(t)){
                                         f.nomFichier = f.nomFichier.substring(0,10) ;
                                         f.nomFichier = f.nomFichier.replace('_', ' - ')  ;
                                         f.nomFichier = f.nomFichier.replace(t, mapLibdocByDocType.get(t));
                                         
                                          if(t == 'PHO'){
                                             f.nomFichier = f.nomFichier.replace('s','') ;
                                          }
                                      //   f.nomFichier = f.nomFichier + 'aaaaaaaaaaaaaaaaa' ;
                                      }
                                  }                
                              }
                              system.debug('$$$$$$$$$$$ JE SUIS ICI 22');
                              system.debug('Result WS GET FILES FROM DOC NUM : '+documentsToReturn);
                          }
                          
                      }
                      
                  }else if(respoDocNum != null && respoDocNum.getStatusCode() != 200){
                      system.debug('Aucun fichier trouvé !!! ');
                  }//end   
       //    }
                  
                 if(documentsToReturn != null && documentsToReturn.size() > 0){
                    system.debug('Here are the successful returned Files : ' + documentsToReturn);
                    return documentsToReturn ;
                 }else{
                    return null ;
                 }
           }else{
               return null ;
           }
               
                    
      }catch(DmlException e){
          String erreurMessage = e.getMessage();
          System.debug('Erreur Documents DmlException :'+ erreurMessage ) ;
          return documentsToReturn ;
          //Database.rollback(sp);
      }catch(Exception e){
          String erreurMessage = e.getMessage();
          System.debug('Erreur Documents Exception :'+ erreurMessage ) ;
          return documentsToReturn ;
        //Database.rollback(sp);
      }   
                                                                              
    }
    

    public class File{
    
        @AuraEnabled public String numDos ;
        @AuraEnabled public Datetime dateCreation ;
        @AuraEnabled public String nomFichier ;
        @AuraEnabled public String codeQualification ;
        @AuraEnabled public String idDocNum  ;
        @AuraEnabled public String url ;
        @AuraEnabled public String typeDocument ;
        @AuraEnabled public String externalUrl ;
    }
    
}