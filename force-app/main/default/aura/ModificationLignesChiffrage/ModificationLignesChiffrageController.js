({
	 doInit : function(component, event, helper) {
        helper.getLignes(component, event, helper);
        //helper.fetchPickListVal(component, 'CodeAction__c', 'listCodeActionOptions');
        //helper.fetchPickListVal(component, 'CodeCote__c', 'listCodeCoteOptions');
     },

    
     sauvegarderUpdatedData : function(component, event, helper) {         
         helper.sauvegarderUpdatedData(component,event,helper);         
     },
 
    
     fieldUpdated : function(component, event, helper) {
          
        var selectedField = event.getSource().getLocalId(); 
        var selectedRecord = event.getSource().get("v.name");
        var selectedFieldValue = event.getSource().get("v.value") ;
        
      //  var checkedFlag = component.get("v.value");  
        var selectedId = selectedRecord['Id'];
        //var selectedIdTest = selectedRecord.Id;  
        
        console.log('selectedField ' + selectedField);
        console.log('selectedId ' + selectedId);
        //console.log('selectedIdTest ' + selectedIdTest);
        console.log('selectedRecord ' + selectedRecord); 
        console.log('selectedFieldValue ' + selectedFieldValue);
         

        var updatedData = component.get("v.updatedData"); 
        updatedData = helper.addRecordToList(updatedData, selectedRecord);
        component.set("v.updatedData", updatedData);
        console.log(' updatedData ' + updatedData);
       
    },
    
    massDeleteLignes : function(component,event,helper){
      var rec = component.find("checkbox-row");
      var listOfId = [];
      for(var i=0; i < rec.length; i++){
        var cond = rec[i].get("v.checked");
        console.log('##### Checkbox value   : '+cond);
        if( cond == true){
            console.log('rec[i] ' + component.find("checkbox-row")[i]);
          listOfId.push(rec[i].get("v.name"));
          }  
       console.log('selected LigneIds' + listOfId);
       } // for loop close 
        component.set("v.deletedLignes" , listOfId);       
        var delIdsPassInClass = component.get("v.deletedLignes");
        var action = component.get("c.massDeleteLignesChiffrage");
        action.setParams({ 
            "delIDs" :  delIdsPassInClass
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            alert(state);
            if (state === "SUCCESS") {    
                //Success message.
                helper.showSuccessToast(component, event, helper);
                
                //Reloads the view.
                $A.get('e.force:refreshView').fire();
                // window.location.href = 'lightning/r/Chiffrage__c/'+component.get("v.recordId")+'/view' ;
            }
        });
        $A.enqueueAction(action);
   
    },
    
    handleChange : function (component, event) {
            // This will contain the string of the "value" attribute of the selected option
            var selectedOptionValue = event.getParam("value");
            //Update the Selected Values  
           // component.set("v.options", selectedOptionValue);
            alert("Option selected with value: '" + selectedOptionValue + "'");
    },
    
    onPicklistChange : function(component, event, helper) {
        // get the value of select option
        alert(event.getSource().get("v.value"));
        //  alert(event.getSource().get("v.label"));
        
        var selectedRecord = event.getSource().get("v.label");
        var selectedId = selectedRecord['Id'];
      //  var checkedFlag = component.get("v.value");
      
        console.log('selectedRecord ' + selectedRecord);
        console.log('selectedId ' + selectedId);
        
        var updatedData = component.get("v.updatedData");
     //   console.log('Je suis ICI 11 ');
        updatedData = helper.addRecordToList(updatedData, selectedRecord);
     //   console.log('Je suis ICI 22 ');
        component.set("v.updatedData", updatedData);
        console.log(' updatedData ' + updatedData); 
        
    },
    
    
	sectionOne : function(component, event, helper) {
         var acc = component.find('SousTotalSection'); 
       //  $A.util.toggleClass(acc, 'slds-show');
         $A.util.toggleClass(acc, 'slds-hide');
    },
    
    manipTable: function(component, event, helper) {
        var isVisible = $A.util.hasClass(component.find("bodytable"), "bodytablevisible");
        if (isVisible){
            var cmpTarget = component.find('bodytable');
            $A.util.removeClass(cmpTarget, 'bodytablevisible');
            $A.util.addClass(cmpTarget, 'bodytablenonvisible');

            var cmpTarget = component.find('arrowdown');
            $A.util.removeClass(cmpTarget, 'bodytablevisible');
            $A.util.addClass(cmpTarget, 'bodytablenonvisible');

            var cmpTarget = component.find('arrowup');
            $A.util.removeClass(cmpTarget, 'bodytablenonvisible');
            $A.util.addClass(cmpTarget, 'bodytablevisible');
        }
        else{
            var cmpTarget = component.find('bodytable');
            $A.util.removeClass(cmpTarget, 'bodytablenonvisible');
            $A.util.addClass(cmpTarget, 'bodytablevisible');

            var cmpTarget = component.find('arrowup');
            $A.util.removeClass(cmpTarget, 'bodytablevisible');
            $A.util.addClass(cmpTarget, 'bodytablenonvisible');

            var cmpTarget = component.find('arrowdown');
            $A.util.removeClass(cmpTarget, 'bodytablenonvisible');
            $A.util.addClass(cmpTarget, 'bodytablevisible');
        }
    },

    showandhidetable: function(component, event, helper) {
        const index = event.currentTarget.id;
        console.log('index ' + index);
        const tableid = "bodytable-"+index;
        console.log('tableid ' + tableid);
        const arrowdownid = "arrowdown-"+index;
        const arrowupid = "arrowup-"+index;
        console.log('arrowdownid ' + arrowdownid);
        console.log('arrowupid ' + arrowupid);
	console.log('document.getElementById(tableid).classList : ' + document.getElementById(tableid).classList);
        //var isVisible = $A.util.hasClass(component.find(tableid), 'bodytablevisible');
        var isVisible = document.getElementById(tableid).classList.contains('bodytablevisible');
        console.log('document.getElementById(tableid).classList : ' + document.getElementById(tableid).classList);
        console.log('isVisible ' + isVisible);

        if (isVisible){
            //var cmpTarget = component.find(tableid);
            document.getElementById(tableid).classList.remove('bodytablevisible');
            document.getElementById(tableid).classList.add('bodytablenonvisible');
            //$A.util.removeClass(cmpTarget, 'bodytablevisible');
            //$A.util.addClass(cmpTarget, 'bodytablenonvisible');

            //var cmpTarget = component.find(arrowdownid);
            document.getElementById(arrowdownid).classList.remove('bodytablevisible');
            document.getElementById(arrowdownid).classList.add('bodytablenonvisible');
            //$A.util.removeClass(cmpTarget, 'bodytablevisible');
            //$A.util.addClass(cmpTarget, 'bodytablenonvisible');

            //var cmpTarget = component.find(arrowupid);
            document.getElementById(arrowupid).classList.add('bodytablevisible');
            document.getElementById(arrowupid).classList.remove('bodytablenonvisible');
            //$A.util.removeClass(cmpTarget, 'bodytablenonvisible');
            //$A.util.addClass(cmpTarget, 'bodytablevisible');
        }
        else{
            // var cmpTarget = component.find(tableid);
            // $A.util.removeClass(cmpTarget, 'bodytablenonvisible');
            // $A.util.addClass(cmpTarget, 'bodytablevisible');
            document.getElementById(tableid).classList.remove('bodytablenonvisible');
            document.getElementById(tableid).classList.add('bodytablevisible');

            // var cmpTarget = component.find(arrowupid);
            // $A.util.removeClass(cmpTarget, 'bodytablevisible');
            // $A.util.addClass(cmpTarget, 'bodytablenonvisible');
            document.getElementById(arrowupid).classList.remove('bodytablevisible');
            document.getElementById(arrowupid).classList.add('bodytablenonvisible');

            // var cmpTarget = component.find(arrowdownid);
            // $A.util.removeClass(cmpTarget, 'bodytablenonvisible');
            // $A.util.addClass(cmpTarget, 'bodytablevisible');
            document.getElementById(arrowdownid).classList.remove('bodytablenonvisible');
            document.getElementById(arrowdownid).classList.add('bodytablevisible');
        }

    },
    
    gotoRelatedList : function (component, event, helper) {
        var relatedListEvent = $A.get("e.force:navigateToRelatedList");
        relatedListEvent.setParams({
            "relatedListId": "Lignes_de_Chiffrage__r",
            "parentRecordId": component.get("v.recordId")
        });
        relatedListEvent.fire();
	},
    
    createRecord : function (component, event, domLigne) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "LigneChiffrage__c",
          /*  "defaultFieldValues": {
             //   'ImputationDommages__c' : domLigne,
                'Chiffrage__c ' : component.get("v.recordId")
            } */
        });
        createRecordEvent.fire();
    },

    showPicklist: function (component, event, domLigne) {
        alert('HELLO');
    }
    
})