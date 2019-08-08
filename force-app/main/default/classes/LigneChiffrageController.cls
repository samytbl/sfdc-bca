/** 
* @author: Adolphe Sonko
* @date : Création 05/07/2019
* @date : Modification 30/07/2019
* @description : Server side Controller of ModificationLigneschiffrage component.
*/
public class LigneChiffrageController {
	@auraEnabled 
    public static List<LigneChiffrage__c> listLignesChiffrage( String chiffrageId){
        
    	List<LigneChiffrage__c> ligneChiffrages = new List<LigneChiffrage__c>();
        
        ligneChiffrages =  [SELECT Id, Name, CodeAction__c ,CodeCote__c, CodePiece__c,CodeTVA__c,IndicateurApplicationRemisesGlobales__c,IndicateurPQE__c,IndicateurPRE__c,IndicateurVE__c,Libelle__c,LibelleLigne__c,Matiere__c,NomFournisseur__c,NumeroLigne__c,
        					OrigineLigne__c,OrigineProvenance__c,PrixHT__c,QuantitePiece__c,ReferencePieceConstructeur__c,ReferencePieceFournisseur__c,TempsT1__c,TempsT2__c,TempsT3__c,TempsTP__c, Chiffrage__c, Chiffrage__r.Name, Chiffrage__r.MontantACL__c, Chiffrage__r.PourcentageRemise__c,
                            ImputationDommages__c,ImputationDommages__r.Name,ImputationDommages__r.NumeroChoc__c, ImputationDommages__r.ImputabiliteChoc__c
                     		FROM LigneChiffrage__c where Chiffrage__c =:chiffrageId ORDER BY ImputationDommages__r.ImputabiliteChoc__c ASC];
        return ligneChiffrages;
        
    }

  //  @AuraEnabled public Chiffrage__c chiffrage;
    @AuraEnabled public ImputationDommages__c imputDom;
    @AuraEnabled public List<LigneChiffrage__c> lignesChiffrage;
    
    
    
     //MAP les lignes de-chiffrages-avec les dommages
    @auraEnabled 
    public static List<LigneChiffrageController> MapLigneChiffrage(String chiffrageId){
        
        Map<ImputationDommages__c , List<LigneChiffrage__c>> MapLigneDom = new  Map<ImputationDommages__c , List<LigneChiffrage__c>>();   
        List<LigneChiffrage__c> lignes = new List<LigneChiffrage__c>();
        MAP<Id, ImputationDommages__c> MapDommage = new Map<Id,ImputationDommages__c>();
        Set<Id> dommageIds = new Set<Id>();
        
    //    Chiffrage__c chiff = [select id , name FROM Chiffrage__c where Id =:chiffrageId] ;
        

        //Lignes Associées
        lignes =  listLignesChiffrage(chiffrageId);
        system.debug('Lignes de Chiffrage : '+lignes);
        //Dommages Associés
        for (LigneChiffrage__c l:lignes){
            dommageIds.add(l.ImputationDommages__c);
        }

        //Map Inputation Dommage
         
        for ( ImputationDommages__c imp: [Select Id, Name, NumeroChoc__c, ImputabiliteChoc__c, JustificationImputabilite__c FROM ImputationDommages__c where Id in :dommageIds]){
            MapDommage.put(imp.id, imp);
        }
        
        for (LigneChiffrage__c li: lignes){
            ImputationDommages__c inputDom = MapDommage.get(li.ImputationDommages__c);
            if(MapLigneDom.containsKey(inputDom)){
                MapLigneDom.get(inputDom).add(li);
            }else{
              /*  List<LigneChiffrage__c> ListservicesMap = new List<LigneChiffrage__c>();
                ListservicesMap.add(li);
                MapLigneDom.put(inputDom, ListservicesMap);  */
                MapLigneDom.put(inputDom, new List<LigneChiffrage__c>{li});
            }
        }
         
        List<LigneChiffrageController> itemList = new List<LigneChiffrageController>();
        for(ImputationDommages__c dom: MapLigneDom.keySet()){
            LigneChiffrageController item = new LigneChiffrageController();
          //  Item.chiffrage = chiff;
            item.imputDom = dom;
            item.lignesChiffrage = MapLigneDom.get(dom);
            itemList.add(item);
        }
        
        system.debug('itemList : ' + itemList);
        return itemList;
        
    }
    
    
    //=============== Sauvegarde de données ======
    
      @auraEnabled
      public  static void  sauvegarderLignes(List<LigneChiffrage__c> updatedData, List<string> deletedlignes ){

		  //Delete Lignes   
		  List<LigneChiffrage__c> lignesToDelete = new List<LigneChiffrage__c>();
          Chiffrage__c  parentChiffrageToUpdate = new Chiffrage__c(); 
          
          lignesToDelete = [select id from LigneChiffrage__c where id in : deletedlignes]; 
          if (lignesToDelete != null && lignesToDelete.size()>0 ){
              delete lignesToDelete;
              system.debug('Heree are the deleted lignes : ' + lignesToDelete);
          }
          
          //Upsert Lignes
          if (updatedData != null && updatedData.size()>0 ){
              parentChiffrageToUpdate = updatedData[0].Chiffrage__r ;
             
              //Upsert Lignes
              upsert updatedData;
              //Update Chiffrage
              update parentChiffrageToUpdate;
           
              system.debug('Here are the updatedData : ' + updatedData);
              system.debug('Here are the updated parent Chiffrage : ' + parentChiffrageToUpdate);
          }

       
      } 
    
    
    //=============== Suppression de données ======
    @AuraEnabled 
    public static void massDeleteLignesChiffrage(List<String> delIDs){
       
     List<LigneChiffrage__c> lstOfDeleteLignes =  new List<LigneChiffrage__c>();
         for(String st: delIDs){
             LigneChiffrage__c lg = new LigneChiffrage__c();
             lg.Id = (Id)st ;
             lstOfDeleteLignes.add(lg); 
          }
          
        if(lstOfDeleteLignes != null && lstOfDeleteLignes.size() > 0){
            Delete lstOfDeleteLignes;
            system.debug('Here are the Deleted Lignes Chiffrage : ' + lstOfDeleteLignes);
        }
          
 
    }
    
    //=============== method for fetch picklist values dynamic ======

    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
  //  public static Map <String, List<String> > getselectOptions(sObject objObject, List<String> listFields) {
        system.debug('objObject --->' + objObject);
        system.debug('fld --->' + fld);
     //   system.debug('listFields --->' + listFields);
        List < String > allOpts = new list < String > ();
     //   Map <String, List<String> > mapValuesByField = new Map <String, List<String> >();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();  
        
    /*    for (String fld: listFields) {
            // Get the list of picklist values for this field.
            list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
            // Add these values to the selectoption list.
            for (Schema.PicklistEntry a: values) {
                if(mapValuesByField.get(fld) != null){
                    mapValuesByField.get(fld).add(a.getValue());
                }else{
                    mapValuesByField.put(fld, new List<String>{a.getValue()});
                }
            }
        }*/
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        } 
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
    
    /** 
    * @author: Samy TOUBAL
    * @date : Création 29/08/2019
    * @description : fetch Picklist values from sObject
    */
    @AuraEnabled
    public static List <String> getselectPicklistOptions(sObject objObject, string fld) {
        system.debug('objObject --->' + objObject);
        system.debug('fld --->' + fld);
        List <String> allOpts = new list <String> ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list <Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
        allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }

}