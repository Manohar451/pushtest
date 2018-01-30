/**
* @Description  Service Class which drives the functionality which is used to update User data into SessionM platform
* @author Saptaswa
* @date 21-11-2017
*/

    public with sharing class UpdateServices {

        
        public static  smsfsc__SessionMUser__c smUserRecord= new smsfsc__SessionMUser__c();
        
        public static Map<String,Schema.SObjectField> jsonMappingCustomMetaTypeMap = Schema.SObjectType.smsfsc__SessionM_Json_Mappings__mdt.fields.getMap();
        
        public static Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('smsfsc__SessionMUser__c').getDescribe().fields.getMap();
        
        private static String getUrlForUpdate(String sessionMId){
            
             
            String endPointUrl = GeneralUtility.correctEndPointURL()+
                                 GeneralConstants.CONST_PRIV_STRING_FOR_CALL_OUT+
                                 GeneralUtility.API_VERSION+
                                 GeneralConstants.CONST_APPS_STRING_FOR_CALL_OUT+
                                 GeneralUtility.API_KEY+
                                 GeneralConstants.CONST_CONTEXT_PATH_UPDATE+
                                 sessionMId;
            

            
            return endPointUrl;
            
        }
        
        
        
/**
* @Description This method is main method that drives or handles the updation of user data available on SessionM platform
* @author Saptaswa
* @date 21-11-2017
* @return Message-->Message objects that holds msgtext,msgcode,msgtype
* @param sessionMUserObjId SessionM user Id 
*/

        //Newly Added During Refactor
        public static Message modifySessionMUser(Id sessionMUserObjId){
            
            String error = '';
          
            smsfsc__SessionMUser__c newSessionMUserObj = GeneralUtility.getSessionMUserById(sessionMUserObjId);
            Message messageToSend = null ;  

            String emailfieldName =   smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME) != null &&  
                                      String.isNotBlank(smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME).smsfsc__EmailFieldInAccounts__c) ?
                                      smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME).smsfsc__EmailFieldInAccounts__c:
                                      '';
             
            if(newSessionMUserObj !=null)
            {
                smsfsc__SessionMUser__c oldSessionMUserObj = GeneralUtility.getSessionMUserRecordByAccountId(newSessionMUserObj.smsfsc__Account__c);
                
                Account relatedAccountId= GeneralUtility.getAccountRecordWithEmail(newSessionMUserObj.smsfsc__Account__c,emailfieldName);

                Map<String,Object> updatedFieldValueMap= new Map<String,Object>();
                Map<String,String> SmToSfFieldMap= ViewService.getSmSfFieldMapFromJson();
                ViewService.SmSfFieldMappingWrapper mappingWrapper= ViewService.getSmSfStandardCustomFieldMapFromJson();
                
                Map<String, String> SmSfStandardFieldMapFromJson = mappingWrapper.standardProfileMap;
                Map<String, String> SmSfCustomFieldMapFromJson = mappingWrapper.customProfileMap;
                
                
                system.debug('SM to SF Field Map : '+SmToSfFieldMap);
                
                for(String apiNm: fieldMap.KeySet())
                {
                    if(newSessionMUserObj.get(apiNm) != oldSessionMUserObj.get(apiNm))
                    {
                      
                        if(newSessionMUserObj.get(apiNm) ==null)
                        {
                            updatedFieldValueMap.put(apiNm,'$#@');
                       
                        }
                        else{
                        updatedFieldValueMap.put(apiNm,newSessionMUserObj.get(apiNm));
                        }
                    
                    }
                }

                UpdateRequest updateRqst= new UpdateRequest();
                UpdateRequest.UpdateUserRequest user= new UpdateRequest.UpdateUserRequest();
                

                boolean isValid = true;
                String errorMsg = '';
                boolean isValidRequest = true;

                
                system.debug('Updated Fields are : '+updatedFieldValueMap);
                    
                    for(String key: updatedFieldValueMap.keySet())
                    {
                      
                        if(key == 'smsfsc__sessionmuserparent__c' || !fieldMap.get(key).getDescribe().isUpdateable()){
                                    
                                
                                    continue;
                        }
                        if(GeneralConstants.SESSIONM_USER_READONLY_FIELDS.contains(key))
                        {
                            
                                isValidRequest=false;
                                break;
                        }
                        if(SmToSfFieldMap.containsKey(key))
                        {
                            if(SmSfStandardFieldMapFromJson.containsKey(key))
                            {
                                if(SmToSfFieldMap.get(key)=='email')
                                {
                                    String email= String.ValueOf(updatedFieldValueMap.get(key));
                                    if(email != relatedAccountId.get(emailfieldName))
                                    {
                                        isValid = false;

                                        errorMsg=''+'#'+'_'+'$'+ System.Label.Email_Address_Update_Error;
                                        
                                        break;
                                    }
                                    else{
                                        user.email= email;
                                        isValidRequest = true;
                                    }
                                    
                                }
                                if(SmToSfFieldMap.get(key)=='first_name')
                                {
                                    String first_name= String.ValueOf(updatedFieldValueMap.get(key));
                                    user.first_name= first_name.toLowerCase();
                                    isValidRequest = true;
                                }
                                if(SmToSfFieldMap.get(key)=='last_name')
                                {
                                    String last_name= String.ValueOf(updatedFieldValueMap.get(key));
                                    user.last_name= last_name.toLowerCase();
                                    isValidRequest = true;
                                }
                                if(SmToSfFieldMap.get(key)=='gender')
                                {
                                    String gender= String.ValueOf(updatedFieldValueMap.get(key));
                                    user.gender= gender.toLowerCase();
                                    isValidRequest = true;
                                }
                                if(SmToSfFieldMap.get(key)=='city')
                                {
                                    String city= String.ValueOf(updatedFieldValueMap.get(key));
                                    user.city= city.toLowerCase();
                                    isValidRequest = true;
                                }
                                if(SmToSfFieldMap.get(key)=='state')
                                {
                                    String state= String.ValueOf(updatedFieldValueMap.get(key));
                                    user.state= state.toLowerCase();
                                    isValidRequest = true;
                                }
                                if(SmToSfFieldMap.get(key)=='zip')
                                {
                                    String zip= String.ValueOf(updatedFieldValueMap.get(key));
                                    user.zip= zip.toLowerCase();
                                    isValidRequest = true;
                                }
                                if(SmToSfFieldMap.get(key)=='country')
                                {
                                    String country= String.ValueOf(updatedFieldValueMap.get(key));
                                    user.country= country.toLowerCase();
                                    isValidRequest = true;
                                }
                                if(SmToSfFieldMap.get(key)=='account_status')
                                {
                                    String account_status= String.ValueOf(updatedFieldValueMap.get(key));
                                    user.account_status= account_status.toLowerCase();
                                    isValidRequest = true;
                                }
                                if(SmToSfFieldMap.get(key)=='dob')
                                {
                                    Date dob= date.valueOf(updatedFieldValueMap.get(key));
                                    user.dob= dob;
                                    isValidRequest = true;
                                }
                                if(SmToSfFieldMap.get(key)=='suspended')
                                {
                                    Boolean isSuspended= Boolean.valueOf(String.valueOf(updatedFieldValueMap.get(key)));
                                    user.suspended= isSuspended;
                                    isValidRequest = true;
                                }
                                 if(SmToSfFieldMap.get(key)=='opted_in')
                                {
                                    Boolean opted_in= Boolean.valueOf(updatedFieldValueMap.get(key));
                                    user.opted_in= opted_in;
                                }
                                if(SmToSfFieldMap.get(key)=='address')
                                {
                                    String address= String.valueOf(updatedFieldValueMap.get(key));
                                    user.address= address.toLowerCase();
                                    isValidRequest = true;
                                }
                                if(SmToSfFieldMap.get(key)=='dma')
                                {
                                    String dma= String.valueOf(updatedFieldValueMap.get(key));
                                    user.dma= dma.toLowerCase();
                                    isValidRequest = true;
                                }
                                if(SmToSfFieldMap.get(key)=='verification_method')
                                {
                                    String verificationMethd= String.valueOf(updatedFieldValueMap.get(key));
                                    user.verification_method= verificationMethd.toLowerCase();
                                    isValidRequest = true;
                                }
                                if(SmToSfFieldMap.get(key)=='profile_photo_url')
                                {
                                    String profile_photo_url= String.valueOf(updatedFieldValueMap.get(key));
                                    user.profile_photo_url= profile_photo_url.toLowerCase();
                                    isValidRequest = true;
                                }
                                if(SmToSfFieldMap.get(key)=='current_state')
                                {
                                    String current_state= String.valueOf(updatedFieldValueMap.get(key));
                                    user.current_state= current_state.toLowerCase();
                                    isValidRequest = true;
                                }
                                if(SmToSfFieldMap.get(key)=='current_country')
                                {
                                    String current_country= String.valueOf(updatedFieldValueMap.get(key));
                                    user.current_country= current_country.toLowerCase();
                                    isValidRequest = true;
                                }
                            }
                            if(SmSfCustomFieldMapFromJson.containsKey(key))
                            {   
                                if(user.user_profile == null)
                                {
                                 user.user_profile= new Map<String,Object>();
                                }
                                  user.user_profile.put(SmToSfFieldMap.get(key),
                                                        updatedFieldValueMap.get(key));

                                  isValidRequest = true;
                            }
                        }
                        else{
                                isValid = false;  
                                errorMsg=''+'#'+'_'+'$'+ System.Label.Missing_Fields_In_Json_Mapping_Error;
                                
                                break;    
                                
                        }
                    }

                    // added if there is no need to update at all.
                    if(!isValidRequest && isValid){
                        isValid = false;
                        errorMsg=''+'#'+'_'+'$'+ System.Label.Read_Only_Fields_Not_Updatable_Error;
                        return  new  Message(GeneralConstants.CONST_STATUS_ERROR, GeneralConstants.CONST_ERROR_CODE, errorMsg);
                    }
                    else if(!isValid)
                    {
                      return  new  Message(GeneralConstants.CONST_STATUS_ERROR, GeneralConstants.CONST_ERROR_CODE, errorMsg);
                    }
                    else{
                             updateRqst.user= user;
                        
                             string jsonBody = json.serializePretty(updateRqst,true);
                            jsonBody= jsonBody.replace(': "$#@"',':null');
                            system.debug('JSON Body for Update Is : '+jsonBody);
                            HttpResponse resp;
                            try{
                                resp = GeneralUtility.makeCalloutToSessionM(getUrlForUpdate(newSessionMUserObj.smsfsc__SessionMID__c), GeneralConstants.CONST_PUT_METHOD,
                                                                                         GeneralUtility.getCommonHeadersForRequest(),jsonBody );
                                
                                system.debug('Response received : '+resp.getBody());
                                
                            }catch(Exception ex){

                                system.debug('Exception Is : '+ex.getTypeName() + ex.getMessage() + ex.getCause());
                                return  new  Message(GeneralConstants.CONST_STATUS_ERROR, GeneralConstants.CONST_ERROR_CODE, ex.getMessage());  
                            }
                            
                            
                             try{
                                    if((resp.getBody() !=null ) && !String.isEmpty(resp.getBody()) && resp.getBody().startsWith('{')){
                                        
                                        String status='';
                                         Map<String, Object> deserializedJsonMap = new Map<String, Object>();
                                         
                                         deserializedJsonMap = (Map<String, Object>)JSON.deserializeUntyped(resp.getBody());
                                            
                                        if(deserializedJsonMap.containsKey('status'))
                                        {
                                          
                                          status= String.ValueOf(deserializedJsonMap.get('status'));
                                        }
                                        
                                        if((status == GeneralConstants.CONST_STATUS_OK)) {

                                            Map<String, Schema.SObjectField> fieldMapSMUser = EnrollService.sessinMUserObjFieldMap;
                                            for(String fieldName: updatedFieldValueMap.KeySet()){
                                                if(fieldName == 'smsfsc__sessionmuserparent__c' || !fieldMapSMUser.get(fieldName).getDescribe().isUpdateable() || (GeneralConstants.SESSIONM_USER_READONLY_FIELDS.contains(fieldName))){
                                                    continue;
                                                }
                                                
                                                if(updatedFieldValueMap.get(fieldName) =='$#@')
                                                {
                                                    oldSessionMUserObj.put(fieldName,null);
                                               
                                                }
                                                else{
                                                oldSessionMUserObj.put(fieldName,updatedFieldValueMap.get(fieldName)) ;
                                                }
                                            }
                                            
                                            update oldSessionMUserObj;
                                            
                                            messageToSend = new  Message(GeneralConstants.CONST_SUCCESS_MSG, GeneralConstants.CONST_SUCCESS_CODE, System.Label.smsfsc.User_Updated_Success);
                                            
                                            
                                            cleanUpForUpdateServices(newSessionMUserObj.id);

                                        }
                                        else if(status == GeneralConstants.CONST_STATUS_ERROR)
                                        {

                                            String errorCode = '';
                                            
                                            Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(resp.getBody());
                                            
                                            Map<String, Object> errorMap = (Map<String, Object>)responseMap.get(GeneralConstants.CONST_ERROR_FIELD);
                                            
                                            errorCode = (String)errorMap.get(GeneralConstants.CONST_ERROR_CODE);
                                            
                                            if(errorMap.containsKey(GeneralConstants.CONST_USER_SECTION) && errorCode=='validation')
                                            {
                                                Map<String, Object> errorFieldsMap = (Map<String, Object>)errorMap.get(GeneralConstants.CONST_USER_SECTION);
                                                Map<String, Object> userProfileErrorMap = new Map<String, Object>();
                                                if(errorFieldsMap.containsKey(GeneralConstants.CONST_USER_PROFILE)){
                                                    
                                                    userProfileErrorMap = (Map<String, Object>)errorFieldsMap.get(GeneralConstants.CONST_USER_PROFILE);
                                                }
                                
                                                    for(String field: errorFieldsMap.KeySet()){
                                                        
                                                        if(userProfileErrorMap!= null)
                                                        {
                                                            for(String usrProfileField: userProfileErrorMap.KeySet())
                                                            {
                                                             errorMsg += usrProfileField+' Value :'+' '+String.ValueOf(userProfileErrorMap.get(usrProfileField))+', ';
                                                            }
                                                        }
                                                        if(field != GeneralConstants.CONST_USER_PROFILE)
                                                        {
                                                        errorMsg += field+' Value :'+' '+String.ValueOf(errorFieldsMap.get(field))+', ';
                                                        }
                                                    }
                                                    
                                                    errorMsg= errorMsg.removeEnd(', ');

                                                errorCode= ''+'#'+'_'+'$'+errorMsg;
                                                
                                                
                                            } 
                                            else{
                                             
                                             errorCode += '#'+'_'+'$';
                                                
                                            }
                                            
                                            system.debug('Error Message Is : '+errorCode);
                                            messageToSend = new  Message(GeneralConstants.CONST_STATUS_ERROR, String.ValueOf(resp.getStatusCode()), errorCode);  
                              
                                        }
                                        
                                    }
                                    else{
                                        
                                        messageToSend = new  Message(GeneralConstants.CONST_STATUS_ERROR, GeneralConstants.CONST_ERROR_CODE, System.Label.smsfsc.SessionM_Internal_Error);
                                    }
                                }catch(Exception ex){

                                    system.debug(ex.getTypeName() + ex.getMessage() + ex.getCause());
                                    return  new  Message(GeneralConstants.CONST_STATUS_ERROR, GeneralConstants.CONST_ERROR_CODE, ex.getMessage());  
                                }

                            
                        }

                
            }
            else{
                return  new  Message(GeneralConstants.CONST_STATUS_ERROR, GeneralConstants.CONST_ERROR_CODE, System.Label.smsfsc.SessionM_Internal_Error);
            }
            
            return messageToSend;
        }
    
        
        
/**
* @Description This method is called when page loads initially and projects all the existing data onto page
* @author Saptaswa
* @date 21-11-2017
* @return smsfsc__SessionMUser__c-->SessionM user record
* @param accountId AccountId of account record 
*/

        public static smsfsc__SessionMUser__c fetchSessionMUserRecord(Id accountId) {
            
            List<smsfsc__SessionMUser__c> smUserObjList = GeneralUtility.getSessionMUserListByAccountId(accountId);
            
            
            
            smsfsc__SessionMUser__c smUserObjClone = null;
            smsfsc__SessionMUser__c smUserObj = null;
                
            if(smUserObjList != null && smUserObjList.size() ==1){
                
                smUserObj = smUserObjList.get(0);
                
                
            }else{
                
                List<smsfsc__SessionMUser__c> smUserObjListToDelete = new List<smsfsc__SessionMUser__c>();
                
                for(smsfsc__SessionMUser__c smUser :smUserObjList ){
                    
                    if(smUser.smsfsc__SessionMUserParent__c != null){
                        
                        smUserObjListToDelete.add(smUser);
                        
                    }else{
                        
                        smUserObj = smUser;
                    }
                }
                
                
                
                if(smUserObjListToDelete.size() >0){
                    delete smUserObjListToDelete;
                }
            }
            
            smUserObjClone=smUserObj.clone(false,true,false,false);
            smUserObjClone.smsfsc__SessionMUserParent__c = smUserObj.id;
            insert smUserObjClone;
            
            return smUserObjClone;
        }
    
        
        
/*
* @Description This method is used to remove extra/junk records when user clicks on Back button of update page
* @author Saptaswa
* @date 21-12-2017
* @See GeneralUtility.getSessionMUserById
* @param newSessionMUserObjId SessionM user record 
*/

        public static void cleanUpForUpdateServices(Id newSessionMUserObjId){
            
            smsfsc__SessionMUser__c newUserToDelete = GeneralUtility.getSessionMUserById(newSessionMUserObjId);
            
            if(newUserToDelete != null){
                delete newUserToDelete;    
            }
            
                
            
        }
        
    }