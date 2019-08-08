/** 
* @author: Adolphe SONKO
* @date : Creation 17/06/2019
* @date : Modification 20/06/2019
* @description : This Class allows to handle trigger events in Case entity.
*/
public class SM002_CaseTriggerHandler {
    private static String  CLASS_NAME = SM002_CaseTriggerHandler.class.getName();
    public static boolean isExecuting = false;
    
    public static void onAfterInsert(List<Case> cases){
  
        String methodName = 'onAfterInsert';  
        ObjectUtil.debugLogBegin(CLASS_NAME, methodName, ' [cases] : ' + cases);
        
        if(cases != null && cases.size() > 0){
			  createPointsRemarquables( cases) ;
        } 
        
        ObjectUtil.debugLogEnd(CLASS_NAME, methodName, '') ;
              
    } // End method onAfterInsert

    
    /**
     * @author: Adolphe SONKO
     * @date : Création 18/06/2019
     * @date : Modification 20/06/2019
     * @description : This method creates points remarquables for the cases.
     * @param : List<Case> dossiers.
     * @return : -Non-
     */
    public static void createPointsRemarquables(List<Case> dossiers){
        
        String methodName = 'createPointsRemarquables';
        
        List<PointRemarquable__c > listPointsRemarToInsert = new List<PointRemarquable__c >() ;
        
        for(Case c: dossiers){
            if(String.isNotEmpty(c.DommagesDeclares__c) || String.isNotEmpty(c.CirconstancesSinistre__c) || String.isNotEmpty(c.Commentaires__c)){
                String input = '' ;
                String[] com = null;
                
                if(String.isNotEmpty(c.Commentaires__c)){
                    com = String.valueOf(c.Commentaires__c).split('\r\n') ;     //CommentairesLigne1__c is a long text area field
                	input = String.join(com, ' ')  ;
                }
                
                input = String.valueOf(c.DommagesDeclares__c) + ' ' + String.valueOf(c.CirconstancesSinistre__c)+ ' ' + input ;
				system.debug('Regex input search : '+ input );
                if( Pattern.matches('(.*?\\b|.*?)(?i)ter{1,2}ain.*?\\b.*?', input) ){
                       
                       PointRemarquable__c  ptRem = new PointRemarquable__c ( 
                       Name = system.label.TECH_Point_Remarq_Expertise_Terrain ,
                       Dossier__c = c.Id,
                       Statut__c = 'Nouveau') ;
                       listPointsRemarToInsert.add(ptRem) ;
                }
                           
                if( Pattern.matches('(.*?\\b|.*?)(?i)con[s,c]ervatoir.*?\\b.*?', input) ){
                       
                       PointRemarquable__c  ptRem2 = new PointRemarquable__c ( 
                       Name = system.label.TECH_Point_Remarq_Titre_Conservatoire ,
                       Dossier__c = c.Id,
                       Statut__c = 'Nouveau') ;
                       listPointsRemarToInsert.add(ptRem2) ;
                }
                
                if( Pattern.matches('(.*?\\b|.*?)(?i)((borne (km|ki|sup)|(kilom|km (inf|sup)))|(si km)).*?\\b.*?', input ) ){
                       
                       PointRemarquable__c  ptRem3 = new PointRemarquable__c ( 
                       Name = system.label.TECH_Point_Remarq_Borne_Kilometrique,  
                       Dossier__c = c.Id,
                       Statut__c = 'Nouveau') ;
                       listPointsRemarToInsert.add(ptRem3) ;
                }           
             //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
             /**
     * @author: Menad CHABI
     * @date : Modification 05/07/2019
     * @description : This method creates points remarquables for the cases.
     * @param : List<Case> dossiers.
     * @return : -Non-
     */
                 if( Pattern.matches('(.*?\\b|.*?)(?i)(rendez|rdv).{1,20}[0-9]{1,2}.*?\\b.*?', input ) ){
                       
                       PointRemarquable__c  ptRem4 = new PointRemarquable__c ( 
                       Name = system.label.TECH_Point_Remarq_Rendez_Vous ,  
                       Dossier__c = c.Id,
                       Statut__c = 'Nouveau') ;
                       listPointsRemarToInsert.add(ptRem4) ;
                }      
                
                if( Pattern.matches('(.*?\\b|.*?)(?i)(recour(e|s)|(chasse.{1,10}recour)|(gr(é|e).{1,3}gr(é|e))).*?\\b.*?', input ) ){
                  
                       PointRemarquable__c  ptRem5 = new PointRemarquable__c ( 
                       Name = system.label.TECH_Point_Remarq_chasse_au_recours
 ,  
                       Dossier__c = c.Id,
                       Statut__c = 'Nouveau') ;
                       listPointsRemarToInsert.add(ptRem5) ;
                }  
             
                 if( Pattern.matches('(.*?\\b|.*?)(?i)(chien|lapin|animal|sanglier|chevreuil|biche|marcassin|cerf|li(e|ê|è)vre|vache|cheval|anima(u|l)).*?\\b.*?', input ) ){
                       
                       PointRemarquable__c  ptRem6 = new PointRemarquable__c ( 
                       Name = system.label.TECH_Point_Remarq_choc_avec_un_animal ,  
                       Dossier__c = c.Id,
                       Statut__c = 'Nouveau') ;
                       listPointsRemarToInsert.add(ptRem6) ;
                }     
                
                 if( Pattern.matches('(.*?\\b|.*?)(?i)((INCENDI(E|É)?E?S?)|(CALCIN)).*?\\b.*?', input ) ){
                       
                       PointRemarquable__c  ptRem7 = new PointRemarquable__c ( 
                       Name = system.label.TECH_Point_Remarq_incendie ,  
                       Dossier__c = c.Id,
                       Statut__c = 'Nouveau') ;
                       listPointsRemarToInsert.add(ptRem7) ;
                }     
                //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            }
        }
        
        if(listPointsRemarToInsert != null && listPointsRemarToInsert.size() > 0){
            insert listPointsRemarToInsert ;
            system.debug('Here are the point remarquable record (s) inserted :'+listPointsRemarToInsert);
        }
        
        ObjectUtil.debugLogEnd(CLASS_NAME, methodName, '[listPointsRemarToInsert] : ' + listPointsRemarToInsert);

    }
    
    
    
    
    
}