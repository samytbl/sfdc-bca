({
    doInit: function(component, event, helper) {
        helper.getLignes(component, event, helper);
        //component.find("accCiv0").set("v.value", 'KG');

    },
    onRender: function(component, event, helper) {
        console.log('######## RENDERED');
        helper.fetchPickListVal(component, 'Civilite__c', 'accCiv0');
    },
    doneRendering: function(component, event, helper) {
        if(!component.get("v.isDoneRendering")){
            component.set("v.isDoneRendering", true);
            console.log('#### DONE RENDERING');
          //do something after component is first rendered
        }
      },
    onPicklistChange: function(component, event, helper) {
        // get the value of select option
        //helper.fetchPickListVal(component, 'Civilite__c', 'accCiv0');
        alert(event.getSource().get("v.value"));
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
        const tableid = "bodytable-"+index;
        const arrowdownid = "arrowdown-"+index;
        const arrowupid = "arrowup-"+index;

        //var isVisible = $A.util.hasClass(component.find(tableid), 'bodytablevisible');
        var isVisible = document.getElementById(tableid).classList.contains('bodytablevisible');
        console.log(isVisible);

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

    }
        
})