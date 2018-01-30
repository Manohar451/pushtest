/**
* @Description This class is the Service class which drives the functionality to enroll user into the  SessionM platform
* @author Krunal
* @date 07-11-2017
*/

public with sharing class EnrollService{
    
    public static Map<String, Schema.SObjectField> sessinMUserObjFieldMap = Schema.getGlobalDescribe().get(GeneralConstants.CONST_SESSIONM_USER_SOBJ_NAME).getDescribe().fields.getMap();
    public static Map<String, Schema.SObjectField> accountObjFieldMap = Schema.getGlobalDescribe().get(GeneralConstants.CONST_ACCOUNT_OBJ_NAME).getDescribe().fields.getMap();
    
    
/**
* @Description This method is used to get url for callouts into SessioM Platform
* @author Saptaswa
* @date 07-11-2017
* @See GeneralUtility
* @return String-->URL which is used to make post callout on SessionM platform
*/

    private static String getEnrollServiceUrl(){
        
          
        String endPointUrl = GeneralUtility.correctEndPointURL()+
                             GeneralConstants.CONST_PRIV_STRING_FOR_CALL_OUT+
                             GeneralUtility.API_VERSION+
                             GeneralConstants.CONST_APPS_STRING_FOR_CALL_OUT+
                             GeneralUtility.API_KEY+
                             GeneralConstants.CONST_ENROLL_SERVICE_CONTEXT;
                             
        return endPointUrl;
    }
    
/**
* @Description This is the method used to enroll user into SessionM platform
* @author Saptaswa
* @date 07-11-2017
* @See GeneralUtility.makeCalloutToSessionM
* @return APIResult-->Wrapper Class object which indicates the Success/Failure of callout and its corresponding message
* @param emailId EmailId of the user 
* @param accountId AccountId of the account record
*/

    public static APIResult enrollUser(String emailId, Id accountId){
        
        HttpResponse resp= null ;
        List<Message> postMsgs = new  List<Message>();
        Exception exp = null;
        Message messageToSend = null;
        APIResult postResultToReturn = new  APIResult(true, postMsgs);
        EnrollResponse enrolresp = null;      
        
        EnrollRequest enwrap = new  EnrollRequest(String.ValueOf(accountId), emailId, null, 
                                                null, null, null, null, null, null, null);
                                                
        String jsonBody = null;
        
        try{
             jsonBody = json.serialize(enwrap);
             
             resp = GeneralUtility.makeCalloutToSessionM(getEnrollServiceUrl(), GeneralConstants.CONST_POST_METHOD,
                                                                     GeneralUtility.getCommonHeadersForRequest(), jsonBody);
                                                                     
              system.debug('Response received in enrolservice is  : '+resp.getBody());
            
        }catch(Exception e){

            system.debug('Exception error is : '+e.getMessage());
            exp = e;
            postResultToReturn.isSuccess = false;
           
        }

        try{

                if(exp ==null && resp!= null && resp.getBody() != null 
                    && !String.isEmpty(resp.getBody()) && resp.getBody().startsWith('{'))
                {
                    String statusCode= String.ValueOf(resp.getStatusCode());
                    
                    if(statusCode == GeneralConstants.CONST_SUCCESS_CODE)
                    {
                        enrolresp= EnrollResponse.parse(resp.getBody());                                                   
                      
                        if(enrolresp.status == GeneralConstants.CONST_STATUS_OK) {
                            Account accountObj = GeneralUtility.getAccountRecord(accountId);
                        
                            //Account Update-->Checking if user has enough permissions to update the record
                            if(accountObjFieldMap.get('smsfsc__Loyalty_User__c'.toLowerCase()).getDescribe().isUpdateable() &&
                               accountObjFieldMap.get('smsfsc__Loyalty_User__c'.toLowerCase()).getDescribe().isAccessible()){
                                
                                accountObj.smsfsc__Loyalty_User__c = true;
                            }
                            
                            //SessionM User Inserts 
                            smsfsc__SessionMUser__c smUsrObject = Generalutility.getSessionMUserRecordByAccountId(accountId);
                            //If the SessionM User record doesnt exist and proper object level and field level  permissions are there then SessionM User record is inserted with mandatory/necessary fields to enroll
                            if(smUsrObject ==null && Schema.getGlobalDescribe().get('smsfsc__SessionMUser__c').getDescribe().isCreateable() ){

                                 smsfsc__SessionMUser__c smUsrObj = new  smsfsc__SessionMUser__c();

                                 if(enrolresp.user != null){

                                    if((enrolresp.user.id != null) && sessinMUserObjFieldMap.get('smsfsc__SessionMID__c'.toLowerCase()).getDescribe().isCreateable()){
                                        smUsrObj.smsfsc__SessionMID__c = enrolresp.user.id ;
                                    }
                                    if((enrolresp.user.email != null) && sessinMUserObjFieldMap.get('smsfsc__Email__c'.toLowerCase()).getDescribe().isCreateable()){
                                        smUsrObj.smsfsc__Email__c = enrolresp.user.email;
                                    }
                                    if((enrolresp.user.identifiers != null ) && sessinMUserObjFieldMap.get('smsfsc__ExternalID__c'.toLowerCase()).getDescribe().isCreateable()){
                                        smUsrObj.smsfsc__ExternalID__c = enrolresp.user.identifiers[0].external_id;
                                    }
                                    if(sessinMUserObjFieldMap.get('smsfsc__Account__c'.toLowerCase()).getDescribe().isCreateable())
                                    {
                                    smUsrObj.smsfsc__Account__c = accountObj.Id;
                                    }

                                 }
                                                               
                                 insert smUsrObj;
                                 system.debug('SM User Object Opted In flag is : '+smUsrObj.smsfsc__OptedIn__c);
                            }
                            //if SessionM User record already exists and object and field level permssions are there in that case SessionM User record is updated
                            else
                            { 
                                 if(sessinMUserObjFieldMap.get('smsfsc__SessionMID__c'.toLowerCase()).getDescribe().isUpdateable() && 
                                   sessinMUserObjFieldMap.get('smsfsc__SessionMID__c'.toLowerCase()).getDescribe().isAccessible() &&
                                   sessinMUserObjFieldMap.get('smsfsc__SessionMID__c'.toLowerCase()).getDescribe().isCreateable() &&
                                   enrolresp.user.id != null) {
                                
                                        smUsrObject.smsfsc__SessionMID__c = enrolresp.user.id;
                                
                                    }
                                    if(sessinMUserObjFieldMap.get('smsfsc__Email__c'.toLowerCase()).getDescribe().isUpdateable() && 
                                       sessinMUserObjFieldMap.get('smsfsc__Email__c'.toLowerCase()).getDescribe().isAccessible() &&
                                       sessinMUserObjFieldMap.get('smsfsc__Email__c'.toLowerCase()).getDescribe().isCreateable() &&
                                       enrolresp.user.email != null) {
                                        
                                        smUsrObject.smsfsc__Email__c = enrolresp.user.email;
                                    }
                                    
                                    if(sessinMUserObjFieldMap.get('smsfsc__ExternalID__c'.toLowerCase()).getDescribe().isUpdateable() &&
                                       sessinMUserObjFieldMap.get('smsfsc__ExternalID__c'.toLowerCase()).getDescribe().isAccessible() &&
                                       sessinMUserObjFieldMap.get('smsfsc__ExternalID__c'.toLowerCase()).getDescribe().isCreateable() &&
                                       enrolresp.user.identifiers != null ){
                                        
                                        smUsrObject.smsfsc__ExternalID__c = enrolresp.user.identifiers[0].external_id;
                                    }
                                    
                                    if(sessinMUserObjFieldMap.get('smsfsc__Account__c'.toLowerCase()).getDescribe().isUpdateable() &&
                                       sessinMUserObjFieldMap.get('smsfsc__Account__c'.toLowerCase()).getDescribe().isAccessible() &&
                                       sessinMUserObjFieldMap.get('smsfsc__Account__c'.toLowerCase()).getDescribe().isCreateable()) {
                                        
                                        smUsrObject.smsfsc__Account__c = accountObj.Id;
                                    }
                                    
                                  
                                    update smUsrObject;
                                                    
                         
                            }

                            update accountObj;
                           
                            postResultToReturn.isSuccess = true;
                            
                            
                        }
                    
                   
                    }
                    
                }

            }catch(Exception e){

                    system.debug('Exception error is : '+e.getMessage());
                    exp = e;
                    postResultToReturn.isSuccess = false;
            }
            
        //This code block handles HTTP errors occured while performing enroll operation and displays corresponding error message either native or received from platform 
            if(enrolresp != null){
                
                GeneralUtility.handleHttpErrors(resp,enrolresp.status, postResultToReturn,exp,GeneralConstants.CONST_SERVICE_TYPE_ENROLL);

            }else{
                GeneralUtility.handleHttpErrors(resp,null, postResultToReturn,exp,GeneralConstants.CONST_SERVICE_TYPE_ENROLL);
            }
           
        
        
        return postResultToReturn;                                                             
        
        
    }
    
  
    
}