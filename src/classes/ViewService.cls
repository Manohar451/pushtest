/**
* @Description This class is the Service class which drives the functionality to View data of the user enrolled into the  SessionM platform
* @author Saptaswa
* @date 07-11-2017
*/

public with sharing class ViewService
{
    
 	public static  smsfsc__SMLSettings__c listCustomSettings = smsfsc__SMLSettings__c.getValues(System.Label.smsfsc.Custom_Setings_Name);
 
/**
* @Description This method is used to get URL(Context Path) for making get callout into SessionM platform
* @author Krunal
* @date 20-11-2017
* @return String-->EndpointURL which is used to perform callout
* @param accountId AccountId of the account record 
*/

     private static String getViewServiceUrl(String accountId){
        
        
        String endPointUrl = GeneralUtility.correctEndPointURL()+
                             GeneralConstants.CONST_PRIV_STRING_FOR_CALL_OUT+
                             GeneralUtility.API_VERSION+
                             GeneralConstants.CONST_APPS_STRING_FOR_CALL_OUT+
                             GeneralUtility.API_KEY+
                             GeneralConstants.CONST_VIEW_CONTEXT_PATH+
                             accountId+
                             GeneralConstants.CONST_VIEW_QUERY_STRING;
        
        return endPointUrl;
                      
    }
    

/**
* @Description Below method makes a get callout and updates the corresponding SessionM User record fields as per response received in the Get Callout
* @author Saptaswa
* @date 20-11-2017
* @return Message Message-->Message objects that holds msgtext,msgcode,msgtype
* @param accountId Id Account Id of the account record
*/

    public static Message getSessionMUser(String accountId){
        
        HttpResponse resp= null ;
        Map<String, Object> getCallOutResponseMap= new Map<String, Object>();
        Map<String, Object> getCallOutResponseUserProfileMap= new Map<String, Object>();
        Map<String, Object> deserializedJsonMap = new Map<String, Object>();

        List<Message> postMsgs = new  List<Message>();

        Exception exp = null;
        APIResult postResultToReturn = new  APIResult(true, postMsgs);
        Message messageToSend; 
        EnrollResponse enrolresp = null;
        String status='';
        
        try{
            resp = GeneralUtility.makeCalloutToSessionM(getViewServiceUrl(accountId), GeneralConstants.CONST_GET_METHOD,
        
                                                             GeneralUtility.getCommonHeadersForRequest(), null);
                                                             
             system.debug('Response received is : '+resp.getBody());
             
        }catch(Exception e){

            system.debug('Exception error is : '+e.getMessage());
            exp = e;
            
            postResultToReturn.isSuccess = false;
           
        }
        
        
                try {
                    if(exp ==null && resp!= null && resp.getBody() != null 
                        && !String.isEmpty(resp.getBody()) && resp.getBody().startsWith('{')){
                    
                            Account objAccount =  GeneralUtility.getAccountRecord(accountId);
                            
                            PermissionsWrapper sessionMUserPermissions =  new PermissionsWrapper(GeneralConstants.CONST_SESSIONM_USER_SOBJ_NAME);
                            PermissionsWrapper accountPermissions =  new PermissionsWrapper(GeneralConstants.CONST_ACCOUNT_OBJ_NAME);
                            PermissionsWrapper accountLoyaltyfieldPermsissions =  new PermissionsWrapper(Account.smsfsc__Loyalty_User__c);
                            PermissionsWrapper sessionMOptedInPermsissions =  new PermissionsWrapper(smsfsc__SessionMUser__c.smsfsc__OptedIn__c);
                                
                            deserializedJsonMap = (Map<String, Object>)JSON.deserializeUntyped(resp.getBody());
                            
                            if(deserializedJsonMap.containsKey('status'))
                            {
                              
                              status= String.ValueOf(deserializedJsonMap.get('status'));
                            }
                            
                            //If Callout Response status received is ok then update the SessionM User record with response received
                            if(status == 'ok')
                            {
                            
                                if(deserializedJsonMap.containsKey(GeneralConstants.CONST_USER)){
                                    
                                    getCallOutResponseMap = (Map<String, Object>)deserializedJsonMap.get(GeneralConstants.CONST_USER);
                                }
                                
                                if(getCallOutResponseMap.containsKey(GeneralConstants.CONST_USER_PROFILE)){
                                    
                                    getCallOutResponseUserProfileMap = (Map<String, Object>)getCallOutResponseMap.get(GeneralConstants.CONST_USER_PROFILE);
                                }
                                
                                //getCallOutResponseMap.putAll(getCallOutResponseUserProfileMap);
                                
                                smsfsc__SessionMUser__c sessionMuser = fetchuserDetails(getSmSfStandardCustomFieldMapFromJson(),
                                                                                      getFieldTypes(GeneralConstants.CONST_SESSIONM_USER_OBJ_NAME), 
                                                                                      getCallOutResponseMap,getCallOutResponseUserProfileMap, accountId);
                                                                                      
                                
                               //Check for necessary permissions before upserting the SessionMUser record
                                if(sessionMUserPermissions.isAccessible && 
                                   ((sessionMuser.Id == Null && sessionMUserPermissions.isCreateable) ||
                                   (sessionMuser.Id != Null && sessionMUserPermissions.isUpdateable))){
                                       
                                       upsert sessionMuser;
                                 }

                                
                                
                                //Check for necessary permissions on the corresponding Account record before updating the SessionMUser record
                                if(accountPermissions.isAccessible &&
                                   accountPermissions.isUpdateable &&
                                   EnrollService.accountObjFieldMap.get('smsfsc__Loyalty_User__c'.toLowerCase()).getDescribe().isUpdateable() &&
                                   EnrollService.accountObjFieldMap.get('smsfsc__Loyalty_User__c'.toLowerCase()).getDescribe().isAccessible() &&
                                   sessionMuser.smsfsc__OptedIn__c != objAccount.smsfsc__Loyalty_User__c){
                                       
                                       objAccount.smsfsc__Loyalty_User__c = sessionMuser.smsfsc__OptedIn__c;
                                       update objAccount;
                                   }

                                   

                                postResultToReturn.isSuccess = true;
                                
                            }
                            else if(status == 'error' && deserializedJsonMap.containsKey('errors')){
                                
                                Map<String, Object> errorsMap = (Map<String, Object>) deserializedJsonMap.get('errors');
                                /****If the response received is 'user_not_found' in that case update the Loyalty User Field as false and 
                                     so that Enroll Component is displayed *****/
                                if(String.ValueOf(errorsMap.get('code')) == 'user_not_found' &&
                                   accountPermissions.isAccessible &&
                                   accountPermissions.isUpdateable &&
                                   EnrollService.accountObjFieldMap.get('smsfsc__Loyalty_User__c'.toLowerCase()).getDescribe().isUpdateable() &&
                                   EnrollService.accountObjFieldMap.get('smsfsc__Loyalty_User__c'.toLowerCase()).getDescribe().isAccessible() &&
                                   objAccount.smsfsc__Loyalty_User__c != false){
                                    
                                       
                                       objAccount.smsfsc__Loyalty_User__c = false;
                                       update objAccount;
                                 }
                                 else{
                                    /***For any other error response received handle those errors and display in the UI****/ 
                                    if(String.ValueOf(errorsMap.get('code')) != 'user_not_found') 
                                    {
                                        
                                        String errorCode = String.ValueOf(errorsMap.get('code'))+'#'+'_'+'$';
                                        messageToSend = new  Message(GeneralConstants.CONST_STATUS_ERROR, GeneralConstants.CONST_UNHANDLED_ERROR_CODE, errorCode);
                                        postMsgs.add(messageToSend);
                                        return messageToSend;
                                    }
                                    
                                    
                                }
                                
                            }
                            else{
                                /***For any other error response received handle those errors and display in the UI****/ 
                                postResultToReturn.isSuccess = false;
                                GeneralUtility.handleHttpErrors(resp,GeneralConstants.CONST_STATUS_ERROR, postResultToReturn,exp,GeneralConstants.CONST_SERVICE_TYPE_VIEW);
                            }
                            
                    }
                }catch(Exception e){

                        system.debug('Exception error is : '+e.getMessage());
                        exp = e;
                        
                        postResultToReturn.isSuccess = false;
                }
        
          //This code block handles HTTP errors occured while performing viewing user data and displays corresponding error message either native or received from platform 

        if(status != null ){

            GeneralUtility.handleHttpErrors(resp,GeneralConstants.CONST_STATUS_OK, postResultToReturn,exp,GeneralConstants.CONST_SERVICE_TYPE_VIEW);

        }else{
            GeneralUtility.handleHttpErrors(resp,null, postResultToReturn,exp,GeneralConstants.CONST_SERVICE_TYPE_VIEW);
        }

        
        checkForCleanUp();
        
        
        return postResultToReturn.messages[0];
        
    }
    
    
    
        
/**
* @Description This method is used to cleanup/remove junk SessionMUser records
* @author Krunal Pala
* @date 15-11-2017
*/
    
    private static void checkForCleanUp(){
    	try{
    	
         smsfsc__SMLSettings__c objListSettings = smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME);
         smsfsc__SMPSettings__c objProtectedSettings = smsfsc__SMPSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME);
         
         if(objListSettings == null || objProtectedSettings == null || !objListSettings.smsfsc__CleanUpServiceEnable__c ){

         	return;
         }
         else {
         	
         	objListSettings.smsfsc__CleanUpServiceTimeFrame__c  = objListSettings.smsfsc__CleanUpServiceTimeFrame__c == Null  || 
         														  objListSettings.smsfsc__CleanUpServiceTimeFrame__c < 1 ||
         														  objListSettings.smsfsc__CleanUpServiceTimeFrame__c > GeneralConstants.CONST_MAX_TIMEFRAME
         														  ? GeneralConstants.CONST_TIMEFRAME : objListSettings.smsfsc__CleanUpServiceTimeFrame__c;

         	objListSettings.smsfsc__CleanUpServicesRecordsToDelete__c = objListSettings.smsfsc__CleanUpServicesRecordsToDelete__c == Null || 
         																objListSettings.smsfsc__CleanUpServicesRecordsToDelete__c < 1 ||
         																objListSettings.smsfsc__CleanUpServicesRecordsToDelete__c > GeneralConstants.CONST_MAX_RECORDS_TO_DELETE 
         																? GeneralConstants.CONST_MAX_RECORDS_TO_DELETE : objListSettings.smsfsc__CleanUpServicesRecordsToDelete__c;
         	
         	
			DateTime currentTime = Datetime.now();
			Integer cleanUpTimeFrame = Integer.valueOf(objListSettings.smsfsc__CleanUpServiceTimeFrame__c);
			DateTime paramDateTime = currentTime.addHours(-(cleanUpTimeFrame));

         	if(objProtectedSettings.smsfsc__CleanUpServiceLastTimeRun__c  != Null  &&
         	   currentTime > objProtectedSettings.smsfsc__CleanUpServiceLastTimeRun__c && 
         	   currentTime < objProtectedSettings.smsfsc__CleanUpServiceLastTimeRun__c.addHours(cleanUpTimeFrame)){

         		return;
         	}
         	else{
         		
         		if(smsfsc__SessionMUser__c.sObjectType.getDescribe().isDeletable() &&
                    smsfsc__SessionMUser__c.sObjectType.getDescribe().queryable){
                    	
                    	
                    	List<smsfsc__SessionMUser__c> seesionMUserToDel= GeneralUtility.getSesionMUserForCleanUp(paramDateTime,Integer.valueOf(objListSettings.smsfsc__CleanUpServicesRecordsToDelete__c));
         		
         				if(seesionMUserToDel!= null && seesionMUserToDel.size()>0  ){
         					
         						System.enqueueJob(new CleanupService(seesionMUserToDel));
         						
         				}
                    	
                    }
 	  			}
         }
    	}catch(Exception e){
    		
    		System.debug(e.getMessage());
    	
   		 }
    }
  
    
/**
* @Description Below method updates the details received in response to the related Session M User record 
* @author Saptaswa
* @date 20-11-2017
* @return smsfsc__SessionMUser__c-->SessionM record
* @param fieldAPIName API name of field
* @param SmSfFieldMapFromJson SessionM to Salesforce FieldMap JSON
* @param SMUserFieldAPINameFieldTypeMap SessionMUser Field APIName and Field Type Map
* @param getCallOutResponseMap Callout Response from SessionMAPI
* @param accountId Account Id of the account record
*/

    public static smsfsc__SessionMUser__c fetchuserDetails(SmSfFieldMappingWrapper SmSfFieldMapWrapper, Map<String, Schema.DisplayType> SMUserFieldAPINameFieldTypeMap, 
     Map<String, Object> getCallOutResponseMap,Map<String, Object> getCallOutResponseUserProfileMap, String accountId){
        
       
        smsfsc__SessionMUser__c sessionM;
        
        
        
        sessionM = GeneralUtility.getSessionMUserRecordByAccountId(accountId);
        
        if(sessionM == null){
            sessionM = new smsfsc__SessionMUser__c();
        }

        if(sessionM !=null){
            
            
            updateSMUserRecord(getCallOutResponseMap,SmSfFieldMapWrapper.standardProfileMap,sessionM,SMUserFieldAPINameFieldTypeMap, accountId,true);
            updateSMUserRecord(getCallOutResponseUserProfileMap,SmSfFieldMapWrapper.customProfileMap,sessionM,SMUserFieldAPINameFieldTypeMap, accountId,false);
           
        }
        
        system.debug('Updated SM User record : '+sessionM);
        
        return sessionM;
    }
    

/**
* @Description Below method returns a Map of all the accessible field API names and data types for the SObjectType passed in Argument
* @author Manohar
* @date 11-11-2107
* @return Map<String, Schema.DisplayType>-->Map of field and their types
* @param SobjectType Type of the sobject
*/
   
    public static Map<String, Schema.DisplayType> getFieldTypes(String SObjectType){
        
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(SObjectType).getDescribe().fields.getMap();
        
        Map<String, Schema.DisplayType> SMUserFieldAPINameFieldTypeMap = new  Map<String, Schema.DisplayType>();
        
        for(String fieldName: fieldMap.keySet()){
            
            if(fieldMap.get(fieldName).getDescribe().isAccessible()){
                
                SMUserFieldAPINameFieldTypeMap.put(fieldName, fieldMap.get(fieldName).getDescribe().getType());
            }
        }
        
        
        return SMUserFieldAPINameFieldTypeMap;
    }
    
/**
* @Description Below method returns a Map of all the SF and SessionM API Names mapped in the JSON String provided in the Custom Metadata Type
* @author Saptaswa
* @date 20-12-2107
* @return Map<String, String>-->Map that contains fields from SessionM and Salesforce
*/
    public static Map<String, String> getSmSfFieldMapFromJson(){
        
        smsfsc__SessionM_Json_Mappings__mdt mappingRcrd =  GeneralUtility.getJsonMappingCustomMetadataTypes(listCustomSettings.smsfsc__SessionMtoSalesforceMappingsAPIName__c);
        
        Map<String, String> SmSfFieldMapFromJson = new  Map<String, String>();
        SmToSfFieldJsonParser jsonMap = (SmToSfFieldJsonParser)System.JSON.deserialize(mappingRcrd.smsfsc__FieldMappingsJson__c, 
                                                                                    SmToSfFieldJsonParser.class);
                                                                                    
        for(Integer counter = 0; counter < jsonMap.SmToSfFieldMappings.Mappings.size(); counter++)  {
            
            SmSfFieldMapFromJson.put(jsonMap.SmToSfFieldMappings.Mappings[counter].sfApiName.toLowerCase(), 
                                jsonMap.SmToSfFieldMappings.Mappings[counter].smApiName.toLowerCase());
                            
        }
        
        
        return SmSfFieldMapFromJson;
    }
    
    /**
* @Description Below method returns a Wrapper which contains Two Maps for all the standard & Custom SF and SessionM attributes mapped in the JSON String provided in the Custom Metadata Type
* @author Saptaswa
* @date 20-12-2107
* @return SmSfFieldMappingWrapper-->Wrapper instance which contains Two Maps for all the standard & Custom SF and SessionM attributes mapped in the JSON String provided in the Custom Metadata Type
*/
    public static SmSfFieldMappingWrapper getSmSfStandardCustomFieldMapFromJson(){
        
        smsfsc__SessionM_Json_Mappings__mdt mappingRcrd =  GeneralUtility.getJsonMappingCustomMetadataTypes(listCustomSettings.smsfsc__SessionMtoSalesforceMappingsAPIName__c);
        
        Map<String, String> SmSfStandardFieldMapFromJson = new  Map<String, String>();
        Map<String, String> SmSfCustomFieldMapFromJson = new  Map<String, String>();
        SmToSfFieldJsonParser jsonMap = (SmToSfFieldJsonParser)System.JSON.deserialize(mappingRcrd.smsfsc__FieldMappingsJson__c, 
                                                                                    SmToSfFieldJsonParser.class);
        
        SmSfFieldMappingWrapper mappingWrapper=null;
                                                                                    
        for(Integer counter = 0; counter < jsonMap.SmToSfFieldMappings.Mappings.size(); counter++)  {
            
            
            if(jsonMap.SmToSfFieldMappings.Mappings[counter].attributeType.equalsIgnoreCase(GeneralConstants.CONST_JSON_MAP_ATTRIBUTE_TYPE_STANDARD))
            {
                SmSfStandardFieldMapFromJson.put(jsonMap.SmToSfFieldMappings.Mappings[counter].sfApiName.toLowerCase(), 
                                jsonMap.SmToSfFieldMappings.Mappings[counter].smApiName.toLowerCase());
                
            }
            else if(jsonMap.SmToSfFieldMappings.Mappings[counter].attributeType.equalsIgnoreCase(GeneralConstants.CONST_JSON_MAP_ATTRIBUTE_TYPE_STANDARD))
            {
                SmSfCustomFieldMapFromJson.put(jsonMap.SmToSfFieldMappings.Mappings[counter].sfApiName.toLowerCase(), 
                                jsonMap.SmToSfFieldMappings.Mappings[counter].smApiName.toLowerCase());
                
            }
             


            mappingWrapper= new SmSfFieldMappingWrapper(SmSfStandardFieldMapFromJson,SmSfCustomFieldMapFromJson);
        }
        
        
        return mappingWrapper;
    }
    
    /**
* @Description This method is used to update SessionM user record
* @author Saptaswa
* @date 22-12-2017
* @param getCallOutResponseMap Map that has all data from response 
* @param SmSfFieldMapFromJson SessionM to Salesforce field Map of all standard and custom attributes
* @param sessionM SessionM user Object
* @param SMUserFieldAPINameFieldTypeMap SessionM user field type Map
* @param accountId Account Id of the account record
* @param isStandard Boolean which checks if user is standard or not
*/

    public static void updateSMUserRecord(Map<String, Object> getCallOutResponseMap, Map<String, String> SmSfFieldMapFromJson,smsfsc__SessionMUser__c sessionM,
                                            Map<String, Schema.DisplayType> SMUserFieldAPINameFieldTypeMap,String accountId, Boolean isStandard){
        
            
            Map<String, Schema.SObjectField> fieldMap = EnrollService.sessinMUserObjFieldMap;
            for(String sfapi: SmSfFieldMapFromJson.KeySet()){
                
                system.debug('Key Value Is : '+sfapi);
                if(getCallOutResponseMap.containsKey(SmSfFieldMapFromJson.get(sfapi))){
                    
                    
                    String sessionMValue = String.ValueOf(getCallOutResponseMap.get(SmSfFieldMapFromJson.get(sfapi)));
                   
                    /***Check if all the fields received in Get Callout response are updatable***/
                    if(fieldMap.get(sfapi).getDescribe().isUpdateable()){
                        
                        sessionM.put(GeneralConstants.CONST_ACCOUNT_LOOKUP, accountId);
                     
                       /***Check the datatype of each field in callout response in Salesforce  and convert the value
                        	received to corresponding data type before updating***/
                        if(SMUserFieldAPINameFieldTypeMap.get(sfapi) == Schema.DisplayType.String){
                            
                             
                            sessionM.put(sfapi, String.ValueOf(sessionMValue));
                            
                            
                        }
                        else if((SMUserFieldAPINameFieldTypeMap.get(sfapi) == Schema.DisplayType.Double) || 
                           (SMUserFieldAPINameFieldTypeMap.get(sfapi) == Schema.DisplayType.Currency) || 
                           (SMUserFieldAPINameFieldTypeMap.get(sfapi) == Schema.DisplayType.Percent)){
                               
                            
                            sessionM.put(sfapi, double.valueOf(sessionMValue));
                        
                        }else if(SMUserFieldAPINameFieldTypeMap.get(sfapi) == Schema.DisplayType.Integer){
                            
                            
                            sessionM.put(sfapi, Integer.valueOf(sessionMValue));
                            
                        }else if(SMUserFieldAPINameFieldTypeMap.get(sfapi) == Schema.DisplayType.Boolean){
                            
                           
                            sessionM.put(sfapi, Boolean.valueOf(sessionMValue));
                            
                        } else if(SMUserFieldAPINameFieldTypeMap.get(sfapi) == Schema.DisplayType.Date){
                            
                            
                            sessionM.put(sfapi, Date.valueOf(sessionMValue));
                            
                        }else if(SMUserFieldAPINameFieldTypeMap.get(sfapi) == Schema.DisplayType.DateTime){
                            
                            
                            sessionM.put(sfapi, DateTime.ValueOf(sessionMValue));
                        
                        }
                        else{
                            sessionM.put(sfapi, sessionMValue);
                        }
                        
                    }
                }
            }
    
    
    }
    
/**
* @Description inner wrapper class that contains two Maps as its member variable: One having SessionM & Salesforce standard attributes mapped with each other
																				: The other having SessionM &  Salesforce custom attributes mapped with each other
* @author Saptaswa
* @date 22-12-2017
*/

    public class SmSfFieldMappingWrapper {
    
    public Map<String, String> standardProfileMap;
    public Map<String, String> customProfileMap;
   
    
 /**
* @Description Constructor Method for SmSfFieldMappingWrapper class that sets the member variables(which are maps) of the class
* @author Saptaswa
* @date 22-12-2017
* @param standardProfileMap Standard Fields Map
* @param customProfileMap Custom Fields Map
*/

    public SmSfFieldMappingWrapper(Map<String, String> standardProfileMap,Map<String, String> customProfileMap){
   
           this.standardProfileMap=standardProfileMap;
           this.customProfileMap=customProfileMap;
  
        }
    
    }
    
 
  
}