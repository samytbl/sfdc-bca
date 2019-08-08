({
	doInit : function(component, event, helper) { 
        var listIds = [] ;
        listIds.push(component.get("v.recordId")) ;
        component.set("v.listIds",listIds);
        console.log('listIds : ' + component.get("v.listIds")); 
 	},
    
    getDocuments : function(component, event, helper) {         
         helper.getDocuments(component,event,helper);         
    }
    
})