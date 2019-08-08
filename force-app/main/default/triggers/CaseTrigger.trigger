/** 
* @author: Adolphe Sonko
* @date : Création 19/06/2019
* @date : Modification 19/06/2019
* @description : This trigger.
*/
trigger CaseTrigger on Case (before insert, after insert) {
    
      if(PAD.canTrigger('SM002_CaseTriggerHandler')){
            // after insert
            if(Trigger.isInsert && Trigger.isAfter){
                SM002_CaseTriggerHandler.onAfterInsert(Trigger.new);
            }
        }

}