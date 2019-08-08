/** 
* @author: Adolphe SONKO
* @date : Creation 07/06/2019
* @date : Modification 05/08/2019
* @description : This Class allows to handle trigger events in Vehicule (Asset) entity.
*/
public class SM001_VehiculeTriggerHandler {
        
    private static String  CLASS_NAME = SM001_VehiculeTriggerHandler.class.getName();
    public static boolean isExecuting = false;
    
    public static void onAfterInsert(List<Asset> vehicules){
  
        String methodName = 'onAfterInsert';  
        ObjectUtil.debugLogBegin(CLASS_NAME, methodName, ' [vehicules] : ' + vehicules);
        
        List<Id> vehiculesIds = new List<Id>();
        
        for(Asset  a: vehicules){
             if( !ObjectUtil.isEmpty(a.ImmatriculationVehicule__c) && ObjectUtil.mapDeveloperNameByRecordTypeId('Asset').get(a.RecordTypeId) == system.Label.VehiculeOMRecordTypeDeveloperName) { //Vérifie si le véhicule créé est un Véhicule OM
                  vehiculesIds.add(a.Id);  
              }
        }    
        
        if(vehiculesIds != null && vehiculesIds.size()>0){
            getVehiculeSivitcallout(vehiculesIds);
        } 
        
        ObjectUtil.debugLogEnd(CLASS_NAME, methodName, '') ;
              
    } // End method onAfterInsert
        
    
    /**
     * @author: Adolphe SONKO
     * @date : Création 07/06/2019
     * @date : Modification 13/06/2019
     * @description : Call the SIVIT WS in order to get official infos of the vehicule.
     * @param : String Immat.
     * @return : -Non-
     */
     
    @future(callout=true)
    public static void getVehiculeSivitcallout(List<Id> vehiculesIds){
      String methodName = 'getVehiculeSivitcallout'; 
      
      ObjectUtil.debugLogBegin(CLASS_NAME, methodName, ' [vehiculesIds] : ' + vehiculesIds);
      
      List<Asset> listVehiculesToInsert = new List<Asset>();

      //Savepoint sp = Database.setSavepoint();  
      try{  
           List<Asset> listVehicules = DM001_Vehicule.getListByIds(vehiculesIds);
          
           //Get the URL of the environment 
           SivitParameters__c param_setting = APU001_ConfigUtils.sParameter;
           system.debug('ADBS param_setting     : ' + param_setting); 
                              
           for(Asset  a: listVehicules){
              
                  HttpRequest request = EM001_Vehicule.getVehiculeSivit(param_setting, a.ImmatriculationVehicule__c);
                  system.debug('ADBS request     : ' + request);
                  
                  //Send request 
                  HttpResponse respoVehicule = APU002_WebserviceUtils.sendRequest(request);
                  system.debug('ADBS response     : ' + respoVehicule);
                  system.debug('ADBS response body: ' + respoVehicule.getBody());
                  system.debug('ADBS response getStatus   : ' + respoVehicule.getStatus());
                  system.debug('ADBS response getStatusCode  : ' + respoVehicule.getStatusCode());
                  
                  if(respoVehicule != null && respoVehicule.getStatusCode() == 200){
                      String jsonVehicSivit= respoVehicule.getBody();
                      
                      if(!String.isEmpty(jsonVehicSivit)){
                          
                          ResultImmat resultImmat = (ResultImmat)JSON.deserialize(JsonVehicSivit, ResultImmat.class);
                          system.debug('Result WS Sivit : '+resultImmat);
                          
                          // the SIVIT Vehicule
                          Asset vehicOfficiel = vehiculeSivit(resultImmat, a) ;
                          listVehiculesToInsert.add(vehicOfficiel) ;
                      }
                      
                  }else if(respoVehicule != null && respoVehicule.getStatusCode() != 200){
                      system.debug('Aucun véhicule trouvé !!! ');
                  }//end   
           }
                  
           if(listVehiculesToInsert != null && listVehiculesToInsert.size() > 0){
              insert listVehiculesToInsert;
              system.debug('Here the result After Insert :'+listVehiculesToInsert);
           } 
                    
      }catch(DmlException e){
          String erreurMessage = e.getMessage();
          System.debug('Erreur Vehicule DmlException :'+ erreurMessage ) ;
          //Database.rollback(sp);
      }catch(Exception e){
          String erreurMessage = e.getMessage();
          System.debug('Erreur Vehicule Exception :'+ erreurMessage ) ;
        //Database.rollback(sp);
      }   
                                                                              
    } 

    
    
  public static Asset vehiculeSivit(ResultImmat resultImmat, Asset vehic){
  
    Asset vehicOfficiel = null ;
      
    if( resultImmat != null ){
        
     	vehicOfficiel = new Asset() ;
  
        vehicOfficiel.Name = vehic.Name;
        vehicOfficiel.dossier__c = vehic.dossier__c;
        vehicOfficiel.AccountId = vehic.AccountId;
        vehicOfficiel.ContactId = vehic.ContactId;
     	vehicOfficiel.RecordTypeId = ObjectUtil.mapRecordTypeIdByDeveloperName('Asset').get(system.Label.VehiculeSIVITRecordTypeDeveloperName) ;
        
        vehicOfficiel.LibelleCarrosserie__c  = resultImmat.carrosserie ;
        vehicOfficiel.LibelleCarrosserieCarteGrise__c  = resultImmat.carrosserieCG ;
        vehicOfficiel.EmissionCO2__c  = resultImmat.co2 ;
        vehicOfficiel.VIN__c  = resultImmat.codifVin ;
        vehicOfficiel.LibelleCouleur__c  = resultImmat.couleurVehic ;
        vehicOfficiel.CylindreeEnCm3__c  = resultImmat.cylindree ;
        vehicOfficiel.DateMiseCirculationReelle__c  = resultImmat.date1ErCir ;
        vehicOfficiel.DateCarteGrise__c  = resultImmat.dateDCG ;
        vehicOfficiel.LibelleDispositifDepollution__c  = resultImmat.depollution ;
        vehicOfficiel.EmpattementEnCm__c  = resultImmat.empat ;
        vehicOfficiel.LibelleEnergie__c  = resultImmat.energie ;
        vehicOfficiel.LibelleGenre__c  = resultImmat.genreV ;
        vehicOfficiel.AbreviationGenreCarteGrise__c  = resultImmat.genreVCG ;
        vehicOfficiel.HauteurEnCm__c  = resultImmat.hauteur ;
        vehicOfficiel.ImmatriculationVehicule__c  = transformeImmat(resultImmat.immatSiv) ;
        vehicOfficiel.LargeurEnCm__c  = resultImmat.largeur ;
        vehicOfficiel.LongueurEnCm__c  = resultImmat.longueur ;
     //   vehicOfficiel.LibelleMarqueVehiculeAssure__c  = resultImmat.marque ;
        vehicOfficiel.LibelleMarqueVehicule__c  = resultImmat.marque ;
        vehicOfficiel.MarqueCarrosserieVehicule__c  = resultImmat.marqueCarros ;
        vehicOfficiel.LibelleModeleInjection__c  = resultImmat.modeInject ;
        vehicOfficiel.LibelleModeleRedresseAPRF__c  = resultImmat.modele ;
        vehicOfficiel.LibelleModeleUsageCommun__c  = resultImmat.modeleEtude ;
        vehicOfficiel.LibelleModeleCarteGrise__c  = resultImmat.modelePrf ;
        vehicOfficiel.NumeroSerie__c  = resultImmat.nSerie ;
        vehicOfficiel.NumeroSIREN__c  = resultImmat.nSiren ;
        vehicOfficiel.NombreCylindres__c  = resultImmat.nbCylind ;
        vehicOfficiel.NombrePlaces__c  = resultImmat.nbPlAss ;
        vehicOfficiel.NombrePortes__c  = resultImmat.nbPortes ;
        vehicOfficiel.NombreSoupapes__c  = resultImmat.nbSoupape ;
        vehicOfficiel.NombreVitesse__c  = resultImmat.nbVitesse ;
        vehicOfficiel.NombreVolume__c  = resultImmat.nbVolume ;
        vehicOfficiel.PoidsVide__c  = resultImmat.poidsVide ;
        vehicOfficiel.DescriptionTypePropulsion__c  = resultImmat.propulsion ;
        vehicOfficiel.PoidsTotalChargeKg__c  = resultImmat.ptr  ;
        vehicOfficiel.LibellePoidsTotalRoulantCG__c  = resultImmat.ptrPrf  ;
        vehicOfficiel.PuissanceReelle__c  = resultImmat.puisCh ;
        vehicOfficiel.PuissanceFiscaleChevauxFiscaux__c  = resultImmat.puisFisc ;
        vehicOfficiel.DescriptifTypeBoiteVitesse__c  = resultImmat.tpBoiteVit ;
        vehicOfficiel.DescriptifPresenceTurbo__c  = resultImmat.turboCompr ;
        vehicOfficiel.TypeMinesOrVDS__c  = resultImmat.type ;
        vehicOfficiel.TypeVINCarteGrise__c  = resultImmat.typeVinCG ;
        vehicOfficiel.LibelleVersionVehicule__c  = resultImmat.version ;
        
    }
    
    system.debug('Vehicule Officiel :'+vehicOfficiel);
    return vehicOfficiel ;
  }



   private class ResultImmat{
    
        private String cAliLoca;
        private String cApe;
        private String cCreditBail;
        private String canton;
        private String carrosserie;
        private String carrosserieCG;
        private String catClient;
        private String catClientVO;
        private String catVendeur;
        private Integer co2;
        private String codifVin;
        private String consExurb;
        private String consMixte;
        private String consUrb;
        private String couleurVehic;
        private String cstrVinCG;
        private Integer cylindree;
        private Datetime date1ErCir;
        private Datetime dateDCG;
        private Date dateDCGAchat;
        private Date dateDCGPr;
        private Date dateDCGPrAchat;
        private String depart;
        private String departement;
        private String depollution;
        private Integer empat;
        private String empreinteSol;
        private String codEnergie;
        private String energie;
        private String gammeMarche;
        private String genreV;
        private String genreVCG;
        private Integer hauteur;
        private String immatSiv;
        private Integer largeur;
        private Integer longueur;
        private String marque;
        private String marqueCarros;
        private String modeInject;
        private String modeRefroid;
        private String modele;
        private String modeleEtude;
        private String modelePrf;
        private String mouvmt;
        private String nSerie;
        private String nSiren;
        private Integer nbCylind;
        private String nbDecibels;
        private String nbMain;
        private Integer nbPlAss;
        private Integer nbPortes;
        private Integer nbPropriet;
        private Integer nbSoupape;
        private Integer nbVitesse;
        private Integer nbVolume;
        private String nuanceCouleur;
        private Decimal poidsVide;
        private String prixVehic;
        private String propulsion;
        private Decimal ptr;
        private String ptrPrf;
        private Integer puisCh;
        private Integer puisFisc;
        private String rapPuisPoids;
        private String regionAdmin;
        private String regmDecibels;
        private String statutImmat;
        private String temoinCession;
        private String tpBoiteVit;
        private String transmiss;
        private String turboCompr;
        private String type;
        private String typeVinCG;
        private String version;
        private String voieAr;
        private String voieAv;
        private Integer puisKW;
    
   }
   
   
  	public static String transformeImmat (String immat) {
		
		String newImmat = null;
					
		if ( Pattern.matches('[A-Z]{2}-[0-9]{3}-[A-Z]{2}', immat))
			return immat;
		
		if ( Pattern.matches('[1-9]{1,4}[A-Z]{2,3}[1-9]{2,3}', immat))
			return immat;
		
		if (immat.length() < 7 || immat.length() > 7)
			return immat;
		
		newImmat = immat.substring(0, 2)+'-'+immat.substring(2, 5)+'-'+immat.substring(5, 7);
		
		return newImmat;
	}
    
    
}