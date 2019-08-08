({
    fetchPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getselectPicklistOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": "Civilite__c"
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
 
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                console.log('###### '+component.get("v.mapDommageLignes").length);
                component.find(elementId).set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },
    
    getLignes : function(component, event, helper) {
        console.log('JE SUIS LA');
        var ChiffId = component.get("v.recordId");
        console.log('ChiffId :' + ChiffId); 
        var action = component.get("c.MapLigneChiffrage"); 
        action.setParams({"chiffrageId": component.get("v.recordId") });
        
        action.setCallback(this, function(response){
        var state = response.getState();
        var result = response.getReturnValue();
            
           //console.log('response getLignes : ' + JSON.stringify(result));
            if(state === "SUCCESS"){
                component.set("v.mapDommageLignes",result);
                console.log('####### FINAL ACTION' );
                console.log('##### $$$$$$$ '+component.find('accCiv'));
                //#####################################################################################
                var action = component.get("c.getselectPicklistOptions");
                action.setParams({
                    "objObject": component.get("v.objInfo"),
                    "fld": "Civilite__c"
                });
                var opts = [];
                action.setCallback(this, function(response) {
                    if (response.getState() == "SUCCESS") {
                        console.log('##### SUCCESS 22222 ');
                        var allValues = response.getReturnValue();
                        console.log('##### SUCCESS 22222 '+response.getReturnValue());
         
                        if (allValues != undefined && allValues.length > 0) {
                            opts.push({
                                class: "optionClass",
                                label: "--- None ---",
                                value: ""
                            });
                        }
                        for (var i = 0; i < allValues.length; i++) {
                            opts.push({
                                class: "optionClass",
                                label: allValues[i],
                                value: allValues[i]
                            });
                        }
                        var len = component.get("v.mapDommageLignes").length;
                        for (var i=0; i<len; i++){
                            component.find('accCiv')[i].set("v.options", opts);
                        }
                        console.log('##### $$$$$$ '+component.find('accCiv').length);
                        // component.find('accCiv')[0].set("v.options", opts);
                    }
                });
                $A.enqueueAction(action);
                //##################################################################################
            }else{
                
                 console.log('Erreur Get Lignes Chiffrage');
            }
        });
         
        $A.enqueueAction(action);
    
     }, 
})
