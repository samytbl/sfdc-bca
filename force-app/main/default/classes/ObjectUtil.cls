/** 
* @author: Adolphe Sonko
* @date : Création 06/05/2019
* @date : Modification 06/05/2019
* @description : This class contains all the transverse utility methods .
*/
public class ObjectUtil {
    
    private static String CLASS_NAME = 'ObjectUtil';   
    public static final Map <String, Schema.SObjectType> schemaMap;
    
    public class Pair {
        public String key {get; set;}
        public String val {get; set;}
    }

    static {
        SchemaMap = Schema.getGlobalDescribe();
    }
    
    /** 
    * @author: Adolphe Sonko
    * @date : Création 06/05/2019
    * @date : Modification 06/05/2019
     * @description : This method allows to return a list of fields for a given object.
     * @param : String sObjectName This parameter is the name of sObject.
     * @return : List<String> The returned item is a list of the fields sObject parameter.
     */
    public static List<String> getFieldsListFor(String sObjectName) {
        System.debug('## sObject : ' + sObjectName);
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(sObjectName).getDescribe().fields.getMap();
        List<String> fieldsList = new List<String>();
        for (Schema.SObjectField sfield : fieldMap.Values()) {
            Schema.describefieldresult dfield = sfield.getDescribe();
            Pair field = new Pair();
            field.key = dfield.getname();
            fieldsList.add(field.key);
        }
        System.debug('## fieldsList : ' + fieldsList);
        return fieldsList;        
    }
    
    /** 
     * @author: Adolphe Sonko
     * @date : Création 06/05/2019
     * @date : Modification 06/05/2019
     * @description : This method allows to return a list of fields for a given object.
     * @param : String sObjectName This parameter is the name of sObject.
     * @return : String The returned item is a string of sObject the parameter fields.
     */
    public static String constructFieldListForQueryFrom(String sObjectName) {
        return constructFilteredFieldListForQueryFrom(sObjectName, '');
    }
    

    /** 
     * @author: Adolphe Sonko
     * @date : Création 06/05/2019
     * @date : Modification 06/05/2019
     * @description : This method used to return all fields EXCEPT those ending with a specified extension.
     * @param : String sObjectName This parameter is the name of sObject.
     * @param : String notEndingFilter Ce paramètre spécifie l'extension du nom api des champs à omettre.
     * @return : String The returned item is a string of sObject the parameter fields.
     */
    public static String constructFilteredFieldListForQueryFrom(String sObjectName, String notEndingFilter) {
        List<String> fieldsList = getFieldsListFor(sObjectName);
        String fieldsQuery = ' ';
        System.debug('## fieldsList : ' + fieldsList);
        for (String field : fieldsList) {
            if (String.isEmpty(notEndingFilter) || !field.endsWith(notEndingFilter) ){
                fieldsQuery = fieldsQuery + '' + field + ',';
            }
        }

        return fieldsQuery.replace(fieldsQuery, fieldsQuery.substring(0, fieldsQuery.length() - 1) + ' ');
    }    
    
    /** 
     * @author: Adolphe Sonko
     * @date : Création 06/05/2019
     * @date : Modification 06/05/2019
     * @description : This method provides the debug log some information in early method.
     * @param : String className This parameter is the name of the Apex class.
     * @param : String methodName This parameter is the name of the Apex method.
     * @param : String message This parameter represents the information to appear in the debug log.
     * @return : N/A
     */
     public static void debugLogBegin(String className, String methodName, String message){
        system.debug('### >> BEGIN ['+className+'] ['+methodName+'] [MESSAGE] : ' + message);
     }  
    
    /** 
     * @author: Adolphe Sonko
     * @date : Création 06/05/2019
     * @date : Modification 06/05/2019 
     * @description : This method provides the debug log on certain information to the method.
     * @param : String className This parameter is the name of the Apex class.
     * @param : String methodName This parameter is the name of the Apex method.
     * @param : String message This parameter represents the information to appear in the debug log.
     * @return : N/A
     */
     public static void debugLogEnd(String className, String methodName, String message){
        system.debug('### >> END ['+className+'] ['+methodName+'] [MESSAGE] : ' + message);
     }
    
    /** 
     * @author: Adolphe Sonko
     * @date : Création 06/05/2019
     * @date : Modification 06/05/2019
     * @description : This method provides the debug log some information in method.
     * @param : String className This parameter is the name of the Apex class.
     * @param : String methodName This parameter is the name of the Apex method.
     * @param : String message This parameter represents the information to appear in the debug log.
     * @return : N/A
     */
     public static void debugLog(String className, String methodName, String message){
        system.debug('### >> LOG ['+className+'] ['+methodName+'] [MESSAGE] : ' + message);
     }
    
    /** 
     * @author: Adolphe Sonko
     * @date : Création 06/05/2019
     * @date : Modification 06/05/2019
     * @description : his method provides picklist values.
     * @param : String sObjectAPI This parameter is the API name of the object.
     * @param : String Field This parameter is the name of the picklist field of the object.
     * @return : List<String> The returned element is a character string list containing all the values of picklist.
     */     
     public static List<String> getPicklistValues(String sObjectAPI, String Field){ 
        
             List<String> lstPickvals=new List<String>();
             Schema.sObjectType sobject_type = Schema.getGlobalDescribe().get(sObjectAPI).newSObject().getSObjectType(); 
             Map<String, Schema.SObjectField> field_map = sobject_type.getDescribe().fields.getMap();
             List<Schema.PicklistEntry> pick_list_values = field_map.get(Field).getDescribe().getPickListValues(); 
             for (Schema.PicklistEntry a : pick_list_values) { 
                  lstPickvals.add(a.getValue());
             }
             return lstPickvals;
     }      
    
    /** 
     * @author: Adolphe Sonko
     * @date : Création 11/06/2019
     * @date : Modification 11/06/2019
     * @description : This method provides the id of the record type from the name of the record type.
     * @param : String objectName This parameter is the API name of the object.
     * @param : String recordtypeName This parameter is the name of the recording of the object type.
     * @return : String The returned element is the record type developer name.
     */
    public static String getDeveloperName(String objectName, String recordtypeName){
        return schemaMap.get(objectName).getDescribe().getRecordTypeInfosByName().get(recordtypeName).getDeveloperName();
    }
    
    /** 
     * @author: Adolphe Sonko
     * @date : Création 06/05/2019
     * @date : Modification 06/05/2019
     * @description : This method provides the id of the record type from the name of the record type.
     * @param : String objectName This parameter is the API name of the object.
     * @param : String recordtypeName This parameter is the name of the recording of the object type.
     * @return : Id The returned element is the identifier of the record type.
     */
    public static Id getRecordTypeId(String objectName, String recordtypeName){
        return schemaMap.get(objectName).getDescribe().getRecordTypeInfosByName().get(recordtypeName).getRecordTypeId();
    }
    
    /** 
     * @author: Adolphe Sonko
     * @date : Création 06/05/2019
     * @date : Modification 06/05/2019
     * @description : This method checks if a string value is empty.
     * @param : sObject value This parameter is the value to evaluate.
     * @return : Boolean True if the value is empty or null
     */
     public static Boolean isEmpty(sObject value){
        return (value == null);
     }
    
    
    /** 
     * @author: Adolphe Sonko
     * @date : Création 06/05/2019
     * @date : Modification 06/05/2019
     * @description : This method checks if a string value is empty.
     * @param : Boolean value This parameter is the value to evaluate.
     * @return : Boolean True if the value is empty or null
     */
     public static Boolean isEmpty(Boolean value){
        return (value == null);
     }
    
    
    /** 
     * @author: Adolphe Sonko
     * @date : Création 06/05/2019
     * @date : Modification 06/05/2019 
     * @description : This method checks if a string value is empty.
     * @param : String stringValue This parameter is the name of the Apex class.
     * @return : Boolean True if the string is empty or null
     */
     public static Boolean isEmpty(String stringValue){
        return (stringValue == null || stringValue == '');
     }
    
    
    /** 
     * @author: Adolphe Sonko
     * @date : Création 06/05/2019
     * @date : Modification 06/05/2019
     * @description : This method insert records in Database.
     * @param : List<SObject> records This parameter is the records to insert.
     * @return : N/A
     */
     public static void insertRecords(List<SObject> records){
        insert records;
     }
    
    /** 
     * @author: Adolphe Sonko
     * @date : Création 06/05/2019
     * @date : Modification 06/05/2019
     * @description : This method update existing records in Database.
     * @param : List<SObject> records This parameter is the records to update.
     * @return : N/A
     */
     public static void updateRecords(List<SObject> records){
        update records;
     }
    
    
    /** 
     * @author: Adolphe Sonko
     * @date : Création 06/05/2019
     * @date : Modification 06/05/2019
     * @description : This method delete existing records in Database.
     * @param : List<SObject> records This parameter is the records to delete.
     * @return : N/A
     */
     public static void deleteRecords(List<SObject> records){
        delete records;
     }
    
    
    /** 
     * @author: Adolphe Sonko
     * @date : Création 06/05/2019
     * @date : Modification 06/05/2019
     * @description : This method return a map of RecordTypeId By Name.
     * @param : String ObjectName This parameter is the Object Name.
     * @return : Map<string,ID>
     */
    //method returns map of recordtype.developername => recordtypeId
    public static Map<string,ID> mapRecordTypeIdByDeveloperName(String ObjectName){
     
         List<RecordType> lstRecordType = new List<RecordType>();
         
         lstRecordType = [Select ID,SobjectType,Name,DeveloperName from RecordType where SobjectType=:ObjectName];
         
         Map<String,ID> MapRecordTypeIdByDeveloperName = new Map<String,ID>();
         
         for(RecordType rec:lstRecordType)
         {
            MapRecordTypeIdByDeveloperName.put(rec.DeveloperName,rec.ID);
         }
         
         return MapRecordTypeIdByDeveloperName;
        
    } 
   
    /** 
     * @author: Adolphe Sonko
     * @date : Création 06/05/2019
     * @date : Modification 06/05/2019
     * @description : This method return the Developer Name By RecordTypeId.
     * @param : String paramName This parameter is the Object Name.
     * @return : Map<ID, string>
     */
        //method returns map of recordtypeId => recordtype.developername 
    public static Map<ID, string> mapDeveloperNameByRecordTypeId (String ObjectName){
     
         List<RecordType> lstRecordType = new List<RecordType>();
         
         lstRecordType = [Select ID,SobjectType,Name,DeveloperName from RecordType where SobjectType=:ObjectName];
         
         Map<ID, string> MapDeveloperNameByRecordTypeId = new Map<ID, string>();
         
         for(RecordType rec:lstRecordType)
         {
            MapDeveloperNameByRecordTypeId.put(rec.ID,rec.DeveloperName);
         }
         
         return MapDeveloperNameByRecordTypeId;
        
    } 
    
    
        //method returns random unique string 
    public static String randomizeString(String name){        
        String charsForRandom = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < 6) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), charsForRandom.length());
           randStr += charsForRandom.substring(idx, idx+1);
        }
        return name+randStr;
    }

    //create admin user
    public static User createAdminUser(String name, Id profId){
        return new User(
            Username = ObjectUtil.randomizeString(Name) +'@test.com',
            LastName = 'Sonko',
            FirstName = 'Ado',
            Email = 'Ado@test.com',
            Alias = 'asonk',
            LanguageLocaleKey = 'en_US',
            TimeZoneSidKey = 'Europe/Paris',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = profId
        );
    }

    //get for system administrator profile id
    public static id getProfileAdminId(){
        return ([Select Id From Profile 
                Where name = 'Administrateur système' 
                    OR name = 'System Administrator'].Id);
    }
    
    //method creates account
    public static Account createAccount(string name){
        return new Account(Name = name);
    }
    
    //method creates contact
    public static Contact createContact(string name){
        return new Contact(Lastname = name);
    }
                       
}