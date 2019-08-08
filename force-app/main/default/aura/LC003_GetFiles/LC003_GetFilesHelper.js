({
	getDocuments : function(component, event, helper) {
        var action = component.get("c.getDocNumFilescallout"); 
        action.setParams({"caseIds": component.get("v.listIds") });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('getDocuments result '+result);
            if(state === "SUCCESS"){
                console.log('$$$$$$$$$$$ JE SUIS ICI 22');
                component.set("v.documents",result);
             //   console.log('documents : ' + component.get("v.documents"));
                
                var docs = component.get("v.documents") ;
                
                if(docs != null && docs.length > 0) {
                    console.log('myBool : ' + component.get("v.myBool"));
                    
                    this.applyFileTypeIconNames( component, docs );
                    
                    for (var i = 0; i < docs.length; i++) {
                      /*  console.log('doc['+i+'] :' + docs[i]);*/
                        console.log('numDos : ' + docs[i].numDos);
                        console.log('codeQualification : ' + docs[i].codeQualification);
                        console.log('url : ' + docs[i].externalUrl); 
                        console.log('FileTypeIconName : ' + docs[i].FileTypeIconName);
                        console.log('################################## ');
                    }
                }else{
                    component.set("v.myBool","false");
                    console.log('myBool : ' + component.get("v.myBool"));
                }
                
            }else{
                
                 console.log('Erreur Get documents');
            }
    });
     
    $A.enqueueAction(action);

 	},
    
    
    applyFileTypeIconNames : function( component, files ) {

        for ( var i = 0; i < files.length; i++ ) {

            var iconName = 'doctype:attachment';
            var file = files[i];

            if ( /.*?(POWER_POINT|PP(T|TX))/i.test( file.externalUrl ) ) {
                iconName = 'doctype:ppt';
            }
            else if ( /.*?(EXCEL|XL(S|SX|SM|SB))/i.test( file.externalUrl ) ) {
                iconName = 'doctype:excel';
            }
            else if ( /.*?WORD/i.test( file.externalUrl ) ) {
                iconName = 'doctype:word';
            }
            else if ( /.*?(MP3|WAV|M4A)/i.test( file.externalUrl ) ) {
                iconName = 'doctype:audio';
            }
            else if ( /.*?MP4/i.test( file.externalUrl ) ) {
                iconName = 'doctype:mp4';
            }
            else if ( /.*?CSV/i.test( file.externalUrl ) ) {
                iconName = 'doctype:csv';
            }
            else if ( /.*?(TEXT|TXT)/i.test( file.externalUrl ) ) {
                iconName = 'doctype:txt';
            }
            else if ( /.*?PDF/i.test( file.externalUrl ) ) {
                iconName = 'doctype:pdf';
            }
            else if ( /.*?XML/i.test( file.externalUrl ) ) {
                iconName = 'doctype:xml';
            }
            else if ( /.*?ZIP/i.test( file.externalUrl ) ) {
                iconName = 'doctype:zip';
            }
            else if ( /.*?(PNG|GIF|JPG|JPEG|TIFF|BMP)/i.test( file.externalUrl ) ) {
                iconName = 'doctype:image';
            }
            else if ( /.*?PACK/i.test( file.externalUrl ) ) {
                iconName = 'doctype:pack';
            }
            else if ( /.*?(MOV|WMV|M4V)/i.test( file.externalUrl ) ) {
                iconName = 'doctype:movie';
            }
            else if ( /.*?LINK/i.test( file.externalUrl ) ) {
                iconName = 'doctype:link';
            }
            else if ( /.*?HTML/i.test( file.externalUrl ) ) {
                iconName = 'doctype:html';
            }
            else if ( /.*?SNOTE/i.test( file.externalUrl ) ) {
                iconName = 'doctype:stypi';
            }

            file.FileTypeIconName = iconName;

        }

    }
    
})