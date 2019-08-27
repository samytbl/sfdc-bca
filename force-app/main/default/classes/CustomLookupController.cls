public with sharing class CustomLookupController {

    @AuraEnabled(cacheable=true)
    public static List<RecordsData> fetchRecords( String objectName, String filterField, String searchString ) {
        List<RecordsData> recordsDataList = new List<RecordsData>();

        try {
	        String query = 'SELECT Id, ' + filterField+
	                        ' FROM '+objectName+
	                        ' WHERE '+filterField+' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\'' + ' LIMIT 50000';

	        for(SObject s : Database.query(query)){
	            RecordsData recordsData = new RecordsData();
	            recordsData.value = String.valueOf(s.get('id'));
	            recordsData.label = String.valueOf(s.get(filterField));
	            recordsDataList.add(recordsData);
	        } 
	    } catch (Exception err) {
	    	if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                throw new AuraHandledException(err.getMessage());
            }
	    }
        
        return recordsDataList;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<RecordsData> fetchRecords( String objectName, String filterField1, String filterField2, String searchString ) {
        List<RecordsData> recordsDataList = new List<RecordsData>();

        try {
	        String query = 'SELECT Id, ' + filterField1+', '+filterField2+
	                        ' FROM '+objectName+
	                        ' WHERE '+filterField1+' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\'' +' OR '+filterField2+' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\'' + ' LIMIT 50000';

	        for(SObject s : Database.query(query)){
	            RecordsData recordsData = new RecordsData();
	            recordsData.value = String.valueOf(s.get('id'));
                if(String.valueOf(s.get(filterField1)) != null && String.valueOf(s.get(filterField2)) != null){
                    recordsData.label = String.valueOf(s.get(filterField1)) + '  -  ' + String.valueOf(s.get(filterField2));
                }else if(String.valueOf(s.get(filterField1)) != null){
                    recordsData.label = String.valueOf(s.get(filterField1)) ; 
                }else {
                    recordsData.label = String.valueOf(s.get(filterField2)) ; 
                }
	            
	         //   recordsData.label = String.valueOf(s.get(filterField1)) ; 
	            recordsDataList.add(recordsData);
	        } 
	    } catch (Exception err) {
	    	if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                throw new AuraHandledException(err.getMessage());
            }
	    }
        
        return recordsDataList;
    }


    public class RecordsData{
        @AuraEnabled public String label {get;set;}
        @AuraEnabled public String value {get;set;}
    }
}