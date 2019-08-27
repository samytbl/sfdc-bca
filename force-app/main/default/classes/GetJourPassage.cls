/** 
* @author: Adolphe Sonko
* @date : Creation 12/08/2019
* @date : Modification 14/08/2019
* @description : Récuperer le jour de passage correspondant.
*/
global class GetJourPassage {
    
	@InvocableMethod(label='GetJourPassage' description='Returns the list of jour de Passage corresponding to the input Postal Code .')
    global static List<JourPassageResult> GetJourPassage(List<JourPassageRequest> requests) {
        
    JourPassageResult res = new JourPassageResult() ;
    List<JourPassageResult> listResults = new List<JourPassageResult>() ;
        
    JourPassageRequest req = requests[0] ;
  //  decimal tempPostalCode = decimal.valueOf(req.postalCode.deleteWhitespace()) ; 
    List<JourPassage__c> jrsPassage = [SELECT AdresseAgence2__c,AdresseAgence3__c,AdresseAgence__c,CodePE__c,CodePostalAgence__c,CodeUSC__c,Jeudi__c,Lundi__c,Mardi__c,Mercredi__c,Reference__c,USCPoleExpertise__c,Vendredi__c,VilleAgence__c,VillePassage__c FROM JourPassage__c WHERE Reference__c =: req.postalCode ];
    
    if(jrsPassage != null && jrsPassage.size() > 0){
        
        res.jrPassage = jrsPassage[0] ;

    }else {
        JourPassage__c jrPass = new JourPassage__c() ;
        jrPass.Reference__c = req.postalCode ;
        jrPass.VillePassage__c = null ;
        jrPass.Lundi__c = true ;
        jrPass.Mardi__c = true ;
        jrPass.Mercredi__c = true ;
        jrPass.Jeudi__c = true ;
        jrPass.Vendredi__c = true ;
                
        res.jrPassage = jrPass ;
    } 
    
    String jours = '' ;
    if(res.jrPassage.Lundi__c ){
        if(String.isEmpty(jours)){
            jours = 'Lundi' ;
        }else{
            jours = jours + ',  ' + 'Lundi' ;
        }
    }
    if(res.jrPassage.Mardi__c){
        if(String.isEmpty(jours)){
            jours = 'Mardi' ;
        }else{
            jours = jours + ',  ' + 'Mardi' ;
        }
    }
    if(res.jrPassage.Mercredi__c){
        if(String.isEmpty(jours)){
            jours = 'Mercredi' ;
        }else{
            jours = jours + ',  ' + 'Mercredi' ;
        }
    }
    if(res.jrPassage.Jeudi__c){
        if(String.isEmpty(jours)){
            jours = 'Jeudi' ;
        }else{
            jours = jours + ',  ' + 'Jeudi' ;
        }
    }
    if(res.jrPassage.Vendredi__c){
        if(String.isEmpty(jours)){
            jours = 'Vendredi' ;
        }else{
            jours = jours + ',  ' + 'Vendredi' ;
        }
    }
        
    res.jours = jours ;  
    listResults.add( res) ;
    return listResults;
       
  }
    
    
    class week{
        List<Jour> jours ;
    }
    class Jour{
        Boolean jour;
        String name;
    }
    
   global class JourPassageRequest {
        @InvocableVariable(required=true)
        global Decimal postalCode;
   }
    
   global class JourPassageResult {
        @InvocableVariable
        global JourPassage__c jrPassage;
       
        @InvocableVariable
        global String jours;
   }
}