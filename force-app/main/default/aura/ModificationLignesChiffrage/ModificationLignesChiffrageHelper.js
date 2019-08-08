({
    getLignes : function(component, event, helper) {
    var ChiffId = component.get("v.recordId");
    var action = component.get("c.MapLigneChiffrage"); 
    action.setParams({"chiffrageId": component.get("v.recordId") });
    
    action.setCallback(this, function(response){
        var state = response.getState();
        var result = response.getReturnValue();

        if(state === "SUCCESS"){
            component.set("v.mapDommageLignes",result);
            this.fetchPickListVal(component, 'CodeAction__c', 'CodeAction');
            //this.fetchPickListVal(component, 'CodeCote__c', 'CodeCote');

        }else{
            
             console.log('Erreur Get Lignes Chiffrage');
        }
    });
     
    $A.enqueueAction(action);

 }, 

  //Add Updated Record to List

  addRecordToList: function(List, record) {
    if (List != null && List.length > 0) {
        for (var i = 0; i < List.length; i++) {
            if (List[i]['Id'] === record['Id']) {
                List.splice(i, 1);
            }
        }
    }  
      
 //   if(checkedFlag ){
        List.push(record);   
 //   }
    return List;
},


  // Enregistrer les services

  sauvegarderUpdatedData : function(component, event, helper) {        
   
    var updatedData = component.get("v.updatedData");        
    var deletedLignes = component.get("v.deletedLignes");
    
    var action = component.get('c.sauvegarderLignes'); 
    action.setParams({"updatedData": updatedData ,
                      "deletedLignes": deletedLignes
                     });
    
    action.setCallback(this, function(response){
        
        var state  = response.getState();
        var result = response.getReturnValue();
        
        if(state === 'SUCCESS'){
            
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                'url': '/'+component.get("v.recordId")
            });
            urlEvent.fire(); 	
            
            //Success message.
            this.showSuccessToast(component, event, helper);
            
            //Reloads the view.
            $A.get('e.force:refreshView').fire();
          //  window.location.href = '/'+component.get("v.recordId") ;
          //  window.location.href = 'lightning/r/Chiffrage__c/'+component.get("v.recordId")+'/view' ;  
        }
        else{
             console.log('Erreur insert remplacement');
           
        }
        
    });
    
    $A.enqueueAction(action);
    },
    
    
    //Collapse Section => common reusable function for toggle sections
    
    toggleSection : function(component, event, helper) {
        //dynamically get aura:id name from 'data-auraId' attribute
        var sectionAuraId = event.target.getAttribute("data-auraId") ;

        //get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement() ;

        /* The search() method searches for 'slds-is-open' cclass, and returns the position of the match
         * This method returns -1 if no match is found */

        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open') ;

        //-1 if 'slds-is-open' class is missing... then set 'slds-is-open' class else set slds-is-close class to element
        if(sectionState == -1){
            sectionDiv.setAttribute('class','slds-section slds-is-open') ;
        }else{
            sectionDiv.setAttribute('class', 'slds-section slds-is-close') ;
        }

    },
    
    
    fetchPickListVal : function(component, fieldName, targetAttribute) {
        var action = component.get("c.getselectPicklistOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var allValues = response.getReturnValue();
 
                if (allValues != undefined && allValues.length > 0) {
                    //var currentVal = component.find(targetAttribute)[0].get("v.value");
                    var compnumber = component.find(targetAttribute).length;

                    for (var k=0; k<compnumber; k++){
                        var currentVal = component.find(targetAttribute)[k].get("v.value");
                        var myselectbox = component.find(targetAttribute)[k];
                        var opts = [];

                        // if (currentVal == null){
                        //     opts.push({
                        //         label: "--None--",
                        //         value: "",
                        //         selected: "true"
                        //     });
                        // } else {
                        //     opts.push({
                        //         label: "--None--",
                        //         value: "",
                        //         selected: "false"
                        //     });
                        // }
                        


                         for (var i = 0; i < allValues.length; i++) {
                            //var existingops = myselectbox.get("v.options");
                            //console.log('######### $$$$$$$$$$$$ '+JSON.stringify(existingops, null, 4));
                            if (allValues[i] == currentVal){
                                console.log('##### currentVal EQUAL'+currentVal);
                                console.log('##### allValues EQUAL'+allValues[i]);
                                // opts.push({
                                //     label: allValues[i],
                                //     value: allValues[i],
                                //     selected: "true"
                                // });
                            }
                            else {
                                console.log('##### currentVal '+currentVal);
                                console.log('##### allValues '+allValues[i]);
                                opts.push({
                                    label: allValues[i],
                                    value: allValues[i],
                                    selected: "false"
                                });
                            }
                            console.log('###### '+i);
                         }  
                        myselectbox.set("v.options", opts);
                        

                    }                    
                }
            }else{
             console.log('Erreur fetchPickListVal ');
           
            }
        });
        $A.enqueueAction(action);
    },
    
    showSuccessToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Le(s) modification(s) ont été bien enregistrée(s) ."
        });
        toastEvent.fire();
    }
    

})