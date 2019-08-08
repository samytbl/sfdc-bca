/** 
* @author: Adolphe Sonko
* @date : Création 07/06/2019
* @date : Modification 07/06/2019
* @description : This trigger.
*/
trigger VehiculeTrigger on Asset (before insert, after insert) {
        
    	if(PAD.canTrigger('SM001_VehiculeTriggerHandler')){
            // after insert
            if(Trigger.isInsert && Trigger.isAfter){
                SM001_VehiculeTriggerHandler.onAfterInsert(Trigger.new);
            }
        }
            

}