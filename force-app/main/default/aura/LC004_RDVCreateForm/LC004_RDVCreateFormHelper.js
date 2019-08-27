({
	createRecord : function (component, event, domLigne) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "WorkOrder"
        });
        createRecordEvent.fire();
    }
})