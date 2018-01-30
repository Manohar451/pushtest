/**
* @Description GeneralUtility is the class used to build General utilities and all the reusable code resides here and responsibilities of this class include -->Build query for querying all queryable fields of the Sobject
                           																															         -->Fetch records of Account Object,SessionM user object,Transaction Object,
																																							 -->Make callouts to SessionM platform and get all the headers required for callouts
																																							 -->Handle HTTP errors that occured while performing callout to SessionM API
																																							 -->Sanitize the URL used to make Callouts
* @author Krunal Pala
* @date 20-12-2017
*/


public with sharing class GeneralUtility { 

  public static String [] accountFields = new String [] {'Id','Name','smsfsc__Loyalty_User__c' };
  public static String [] accountFieldsForPersonAccounts = new String [] {'Id','FirstName','LastName','smsfsc__Loyalty_User__c' };
  public static Map<String,Schema.SObjectField> accountFieldMap = Schema.SObjectType.Account.fields.getMap();
  public static Map<String,Schema.SObjectField> jsonMappingCustomMetaTypeMap = Schema.SObjectType.smsfsc__SessionM_Json_Mappings__mdt.fields.getMap();
  public static Integer HTTP_404 = 404;
  public static Map<String,smsfsc__SMPSettings__c> protectedAPIsettingsMap = smsfsc__SMPSettings__c.getAll();

  public static Integer maxSessionMTimeOut = smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME) != null &&  
                        smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME).smsfsc__SessionMTimeOut__c  != Null ?
                        Integer.valueOf(smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME).smsfsc__SessionMTimeOut__c) : 3500;
 
 
  // API EndPoint for Session M Platform
  public  static String API_END_POINT = protectedAPIsettingsMap.get(System.Label.smsfsc.Custom_Setings_Name) == null? null : protectedAPIsettingsMap.get(System.Label.smsfsc.Custom_Setings_Name).smsfsc__APIEndpoint__c;
  // API Key for Session M Platfrom
  public  static String API_KEY =protectedAPIsettingsMap.get(System.Label.smsfsc.Custom_Setings_Name) == null? null :protectedAPIsettingsMap.get(System.Label.smsfsc.Custom_Setings_Name).smsfsc__APIKey__c;
  // API Secreat for Sesion M Platform
  public  static  String API_SECRET =protectedAPIsettingsMap.get(System.Label.smsfsc.Custom_Setings_Name) == null? null :protectedAPIsettingsMap.get(System.Label.smsfsc.Custom_Setings_Name).smsfsc__APISecret__c;
  // API Version of Session M Platform
  public  static String API_VERSION = protectedAPIsettingsMap.get(System.Label.smsfsc.Custom_Setings_Name) == null? null :protectedAPIsettingsMap.get(System.Label.smsfsc.Custom_Setings_Name).smsfsc__APIVersion__c;
  
  public static Map<String, Schema.SObjectField> sessionMTransactionObjFieldMap = Schema.getGlobalDescribe().get('smsfsc__SessionM_Transaction__c').getDescribe().fields.getMap();
  
/**
* @Description This method is used to fetch the reasoncode values from SessionM API
* @author Manohar Pandurangi
* @date 20-12-2017
* @return ReasonCodeResponse-->Wrapper object that holds all picklist values retrieved from the picklist field of Transaction Object
*/

    public static ReasonCodeResponse fetchReasonCodePickListValues()  {
       
       ReasonCodeResponse reasonCodeResp = null; 
       HttpResponse response = null;
       List<Message> postMsgs = new  List<Message>();
       APIResult postResultToReturn = new  APIResult(true, postMsgs); 
      
       Exception exp = null;
       
        
       try{
        
            response = makeCalloutToSessionM(getReasonCodeUrl(), GeneralConstants.CONST_GET_METHOD,
                                                                     getCommonHeadersForRequest(), null);
       }catch(Exception e){
           
          
          exp =e;
          system.debug('---exception is  ---'+e.getMessage() );
           
       }
        
        if(response != null && exp == null){
            
              if((response.getBody() !=null ) && !String.isEmpty(response.getBody())){
            
              
              System.debug('Received the following body :'+response.getBody());
            
              if((response.getStatusCode() == 200) && (response.getStatus() == GeneralConstants.CONST_STATUS_OK)) {
                
                   reasonCodeResp =(ReasonCodeResponse)JSON.deserialize(response.getBody(), ReasonCodeResponse.class);
                  
              }else{
    
                  System.debug('The status code returned was not expected: ' +
                  response.getStatusCode() + ' ' + response.getStatus());
                  
              } 
        
            }
        }
        
         if(reasonCodeResp != null){
            
             
             GeneralUtility.handleHttpErrors(response,reasonCodeResp.status, postResultToReturn,exp,GeneralConstants.CONST_SERVICE_TYPE_REASON_CODE);
             
          }else{
              
             reasonCodeResp = new ReasonCodeResponse();
              
             GeneralUtility.handleHttpErrors(response,null, postResultToReturn,exp,GeneralConstants.CONST_SERVICE_TYPE_REASON_CODE);
              
          }
        
         reasonCodeResp.apiResult =  postResultToReturn;
      
        return reasonCodeResp;
       
        
    }

/**
* @Description This method is used to get the SessionM Transaction Object count
* @author Oswin
* @date 19-12-2017
* @return AggregateResult-->That returns the aggregate count of transaction records
* @param accountId Id of Account record
*/

    public static AggregateResult  getTransactionCountForSessionMUser(Id accountId){

      Map <String, Schema.SObjectField> fieldMap = GeneralUtility.sessionMTransactionObjFieldMap;
      String commaSeparatedFields = '';

      if (fieldMap.get('Name').getDescribe().isAccessible()) {
          
         commaSeparatedFields +=  'count(Name) cnt,' ;
          
      }

     if (fieldMap.get('smsfsc__Account__c').getDescribe().isAccessible()) {
        
         commaSeparatedFields +=  'smsfsc__Account__c ';
       
     }

      Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        
      
    
     if(commaSeparatedFields.length() >0 && schemaMap.get('smsfsc__SessionM_Transaction__c').getDescribe().queryable  ) {

         String soqlQuery = 'Select ' + commaSeparatedFields + ' From smsfsc__SessionM_Transaction__c '+
                                            ' where smsfsc__Account__c = \''+String.escapeSingleQuotes(accountId) + '\'' +
                                            ' group by smsfsc__Account__c ';

         List<AggregateResult> agrResult = Database.query(soqlQuery);

         if(agrResult != null && agrResult.size() >0){

            return agrResult.get(0);

         }else{

            return null;
         }



     }else{
      
     
         return null;
     }
    
     
    }
    
/**
* @Description This method is used to fetch the url for reasoncode values
* @author Krunal
* @date 18-12-2017
* @return String-->URL for ReasonCode picklist values
*/

    
    private static String getReasonCodeUrl(){
        
        String endPointUrl = correctEndPointURL()+
                             GeneralConstants.CONST_PRIV_STRING_FOR_CALL_OUT+
                             API_VERSION+
                             GeneralConstants.CONST_APPS_STRING_FOR_CALL_OUT+
                             API_KEY+
                             GeneralConstants.CONST_REASON_CODE_URL_CONTEXT;
                             
        return endPointUrl;
    }  

/**
* @Description Method which sanitizes the URL and returns the correct Endpoint for SessionM platform
* @author Krunal
* @date 22-12-2017
* @return String-->URL which is used to make callouts to SessionM platform
*/
  
  public static String correctEndPointURL(){
    
         String correctEndPointUrl=null;
        
         if(API_END_POINT != null){
      
              if(!API_END_POINT.endsWith(GeneralConstants.CONST_FORWARD_SLASH)){
                
                   correctEndPointUrl= API_END_POINT+GeneralConstants.CONST_FORWARD_SLASH;
                   
                } else{
                    
                    correctEndPointUrl= API_END_POINT;
                }                          
         }
         
         return correctEndPointUrl;
  }
  
    
/**
* @Description This method is used to get the commonheaders such as Authorization used for HTTP callouts
* @author Krunal
* @date 19-12-2017
* @return Map<String,String>--> Map that contains all headers used for HTTP callouts
*/

  public static Map<String,String> getCommonHeadersForRequest(){
        
        Map<String, String> returnRequestHeaders = new Map<String, String>();
        // Authorization Headers
        String username = '';
        HttpResponse response= null;
  
        Blob headerValue = Blob.valueOf(username + ':' + API_SECRET);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        
        returnRequestHeaders.put('Authorization',authorizationHeader);
        returnRequestHeaders.put('Content-Type', 'application/json');
        
        return returnRequestHeaders;
        
        
    
  }
 
/**
* @Description This method is used to make HTTPcallouts to SessionMAPI
* @author Krunal
* @date 19-12-2017
* @return HttpResponse-->Response which is returned from SessionM platform
* @param httpEndpoint Endpoint URL of SessionMAPI 
* @param httpMethod Name of HTTP method such as GET,POST,PUT 
* @param httpHeadersMap Common headers such as Key,Secret etc 
* @param httpBody JsonBody to make these callouts 
*/

  public static HttpResponse makeCalloutToSessionM(String httpEndpoint, String httpMethod,Map<String,String> httpHeadersMap,String httpBody) {
        
        Http http = new Http();
        
        HttpRequest request = new HttpRequest();
        
        for(String key : httpHeadersMap.keySet()){
            
           request.setHeader(key, httpHeadersMap.get(key));
        
        }
        request.setEndpoint(httpEndpoint);
        request.setMethod(httpMethod);
        request.setTimeout(maxSessionMTimeOut);
        
        if(httpBody != null){
            request.setBody(httpBody);  
        }
        
        
        HttpResponse response= http.send(request);
        
        system.debug('Response received in General Utility: '+response.getBody());
        
        if(response != null){
          
          // Parse the JSON response
          if (response.getStatusCode() != 200) {
            
              System.debug('The status code returned was not expected: ' +
                  response.getStatusCode() + ' ' + response.getStatus());
                  
          }
           
        }
        
        return response;
    }  


/**
* @Description This method is used to handle HTTP errors received from SessionM API
* @author Saptaswa
* @date 17-11-2017
* @param resp Response body received from the SessionMAPI 
* @param responseStatusFromParser Status received from response such as OK,ERROR etc
* @param apiResult APIResult class Object 
* @param exp Any CalloutException Occured
* @param serviceType Type of service for which we should handle errors eg EnrollService,CompingService,UpdateService etc
*/


    public static void handleHttpErrors(HttpResponse resp,String responseStatusFromParser, 
                                        APIResult apiResult,Exception exp,String serviceType){

                                           
       String errorCode= null;
       List<Message> postMsgs = apiResult !=null? apiResult.messages : null;
       String statusCode = null; 

       // There is an exception 
       if(exp != null){

         String exceptionMsg = exp.getMessage();
         String expType = exp.getTypeName();
          errorCode= ''+'#'+'_'+'$'+exceptionMsg;
          postMsgs.add( new  Message(GeneralConstants.CONST_ERROR_MSG, expType, errorCode));
          return;
       }

       if(resp != null){

           statusCode = String.valueOf(resp.getStatusCode());

           if(resp.getStatusCode() == 200){

                if( responseStatusFromParser ==  GeneralConstants.CONST_STATUS_OK){
                    apiResult.isSuccess=true;
                    getSuccessMessagesByServiceType(serviceType,postMsgs);
                }else{
                    apiResult.isSuccess=false;
                    getErrorOrValidationByServiceType(resp,serviceType,postMsgs);
                }


                
          }

           if(statusCode == '401'){

                
            
                errorCode = 'incorrect_api_params'+'#'+'_'+'$';
                apiResult.isSuccess=false;
                postMsgs.add(new  Message(GeneralConstants.CONST_ERROR_MSG, String.ValueOf(resp.getStatusCode()), errorCode));

           }else if(statusCode.startsWith('4')) {

              if(statusCode=='404'){
                
                  apiResult.isSuccess=false;
                  errorCode= ''+'#'+'_'+'$'+'Internal Server Error Occured : HTTP Error Code :404';
              }
              else{
                  apiResult.isSuccess=false;
                  //errorCode= 'internal_server_error'+'#'+'_'+'$';
                  errorCode= '#'+'_'+'$'+'Internal Server Error Occured : HTTP Error Code :'+statusCode;
              }

              postMsgs.add(new  Message(GeneralConstants.CONST_ERROR_MSG, String.ValueOf(resp.getStatusCode()), errorCode));

          }else{
            
             if(statusCode != '200')
             {
             errorCode= '#'+'_'+'$'+'Internal Server Error Occured: HTTP Error Code :'+statusCode;
             apiResult.isSuccess=false;
             postMsgs.add(new  Message(GeneralConstants.CONST_ERROR_MSG, String.ValueOf(resp.getStatusCode()), errorCode));
             }

          }

        }else{

             
             errorCode= 'internal_server_error'+'#'+'_'+'$';
             apiResult.isSuccess=false;
             postMsgs.add(new  Message(GeneralConstants.CONST_ERROR_MSG, String.ValueOf(resp.getStatusCode()), errorCode));

          } 

    }

/**
* @Description This method is used to display success message based on service type
* @author Saptastwa
* @date 19-12-2017
* @param serviceType Type of service for which we should handle successmessages eg EnrollService,CompingService,UpdateService etc
* @param postMsgs List of Messages 
*/


    private static void getSuccessMessagesByServiceType (String serviceType, List<Message> postMsgs){

        if(serviceType ==GeneralConstants.CONST_SERVICE_TYPE_ENROLL){
            postMsgs.add(new  Message(GeneralConstants.CONST_SUCCESS_MSG, GeneralConstants.CONST_SUCCESS_CODE, System.Label.smsfsc.User_Enrolled_Successfully));
        }
        if(serviceType ==GeneralConstants.CONST_SERVICE_TYPE_TIMELINE){
          postMsgs.add(new  Message(GeneralConstants.CONST_SUCCESS_MSG, GeneralConstants.CONST_SUCCESS_CODE, GeneralConstants.CONST_SUCCESS_MSG)); 
        }
        if(serviceType ==GeneralConstants.CONST_SERVICE_TYPE_VIEW){
          postMsgs.add(new  Message(GeneralConstants.CONST_SUCCESS_MSG, GeneralConstants.CONST_SUCCESS_CODE,  GeneralConstants.CONST_SUCCESS_MSG)); 
        }
        if(serviceType ==GeneralConstants.CONST_SERVICE_TYPE_COMP){
           postMsgs.add(new  Message(GeneralConstants.CONST_SUCCESS_MSG, GeneralConstants.CONST_SUCCESS_CODE, System.Label.smsfsc.SuccessMessage_PointsAPI));
        }
        if(serviceType ==GeneralConstants.CONST_SERVICE_TYPE_REASON_CODE){
           postMsgs.add(new  Message(GeneralConstants.CONST_SUCCESS_MSG, GeneralConstants.CONST_SUCCESS_CODE,''));
        }
        if(serviceType ==GeneralConstants.CONST_SERVICE_TYPE_UPDATE){
           postMsgs.add(new  Message(GeneralConstants.CONST_SUCCESS_MSG, GeneralConstants.CONST_SUCCESS_CODE, System.Label.smsfsc.User_Updated_Success));
        }

    }

/**
* @Description This method is used to process the error received from the response and displays appropriate error message
* @author Saptaswa
* @date 20-12-2017
* @param resp HTTP response received from SessionM API 
* @param serviceType Type of services such as EnrollService,CompingService,UpdateService etc
* @param postMsgs List of Messages 
*/
 

    private static void getErrorOrValidationByServiceType(HttpResponse resp, String serviceType, List<Message> postMsgs){

        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(resp.getBody());
            
        Map<String, Object> errorMap = (Map<String, Object>)responseMap.get(GeneralConstants.CONST_ERROR_FIELD);
            
        
        String errorCode = null;
        String errorMsg = null;
        if(errorMap.containsKey('message')){
            errorMsg = (String)errorMap.get('message');
        }
        
        errorCode = (String)errorMap.get(GeneralConstants.CONST_ERROR_CODE)+'#'+'_'+'$'+errorMsg;

        if(serviceType == GeneralConstants.CONST_SERVICE_TYPE_COMP && errorMap.containsKey('transaction'))
        {
             Map<String, Object> transactionMap = (Map<String, Object>) errorMap.get('transaction');
             
             if(transactionMap.containsKey('base')){
                 
                 errorCode = '#_$'+String.valueOf(transactionMap.get('base'));
             }
            else if(transactionMap.containsKey('points')){
                errorCode = '#_$'+String.valueOf(transactionMap.get('points'));
            }
             
        }
        
        postMsgs.add(new  Message(GeneralConstants.CONST_ERROR_MSG, String.ValueOf(resp.getStatusCode()), errorCode));

           
            
            
    }
    

    
   

 /**
* @Description queryBuilder generic method to get all the queryable fields from given sObject names
* @author Saptaswa
* @date 11-11-2017
* @return String-->Final query string
* @param SobjectApiName API name of sobject which we want to query
*/

  public static String queryBuilder(String SobjectApiName){

        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
      
        // TODO - && !fieldMap.get(fieldName).getDescribe().isQueryable()
        String commaSeparatedFields = '';
        for(String fieldName : fieldMap.keyset()){
          
             if (!fieldMap.get(fieldName).getDescribe().isAccessible()) {
                
                
                continue;
               
             }
    
            if(commaSeparatedFields == null || commaSeparatedFields == ''){
              
                commaSeparatedFields = fieldName;
                
            }else{
              
                commaSeparatedFields = commaSeparatedFields + ', ' + fieldName;
            }
        }
 
       String  queryStr = 'select ' + commaSeparatedFields + ' from ' + SobjectApiName ;
       
       system.debug('Query String is : '+queryStr);
       
       return queryStr;
      
    }
    
/**
* @Description This method is used to get sessionM record by Id
* @author Saptaswa
* @date 11-11-2017
* @return smsfsc__SessionMUser__c-->SessionM record
* @param sessionMUserObjId ExternalId of the user in SessionM platform
*/

    public static smsfsc__SessionMUser__c getSessionMUserById(Id sessionMUserObjId){
        
        

        String soqlQuery = queryBuilder('smsfsc__SessionMUser__c');
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        
        system.debug('Is smsfsc__SessionMUser__c queryable : '+schemaMap.get('smsfsc__SessionMUser__c').getDescribe().queryable);
        
        if(soqlQuery != null && !String.isEmpty(soqlQuery) && (schemaMap.get('smsfsc__SessionMUser__c').getDescribe().queryable) ){

          List<smsfsc__SessionMUser__c> sessionMUserList = Database.query(soqlQuery+' where Id=\''+String.escapeSingleQuotes(sessionMUserObjId) + '\'');
      
          
          
          if(sessionMUserList != null && sessionMUserList.size()>0){
            
            return sessionMUserList.get(0);
            
          }else{
            
            return null;
          }
        }else{
          return null;
        }

        
        
        
    }
    
/**
* @Description This method is used to get List of sessionM record by account record Id
* @author Saptaswa
* @date 11-11-2017
* @return  List<smsfsc__SessionMUser__c>-->List of sessionM records
* @param accountId AccountId of the account record
*/

    public static List<smsfsc__SessionMUser__c> getSessionMUserListByAccountId(Id accountId){
        
       

        String soqlQuery =queryBuilder('smsfsc__SessionMUser__c');
        List<smsfsc__SessionMUser__c> sessionMUserList  = null;
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        

        if(soqlQuery != null && !String.isEmpty(soqlQuery) && (schemaMap.get('smsfsc__SessionMUser__c').getDescribe().queryable)){

            sessionMUserList = Database.query(soqlQuery+' where Account__c=\''+String.escapeSingleQuotes(accountId) + '\'');
        }
                
          return sessionMUserList;
        
    }

    
/**
* @Description This method is used to get the Fields that can be queried on Account Object
* @author Saptaswa
* @date 12-11-2107
* @return String-->Query string for account object queryable fields
* @param emailFieldToAppend EmailField of the Account Object
*/

    private static String getAccountQueryFields(String emailFieldToAppend){


      String[] fieldsToCheck = null;
      String queryStr = '';

      if(!accountFieldMap.containsKey('IsPersonAccount')){

           fieldsToCheck = accountFields;
      }
      else{

          fieldsToCheck =accountFieldsForPersonAccounts;
        
      }

      for (String fieldToCheck : fieldsToCheck) {
        
            if (!accountFieldMap.get(fieldToCheck).getDescribe().isAccessible()) {

                
                continue;
            
            }else{
              queryStr+=fieldToCheck+',';
            }
        }

        if(emailFieldToAppend != null){

           if(!String.isEmpty(queryStr) && queryStr.endsWith(',') &&
               accountFieldMap.get(emailFieldToAppend) != null &&
               accountFieldMap.get(emailFieldToAppend).getDescribe().isAccessible()){

                queryStr+=emailFieldToAppend;

            }
        }

        return queryStr;

  
    }
    
    
/**
* @Description This method is used to get AccountRecord by AccountId
* @author Krunal
* @date 22-12-2017
* @return Account-->Account object 
* @param accountId AccountId of the accountrecord that is to be fetched
*/

    public static Account getAccountRecord(Id accountId){
      
      

        String queryStr = getAccountQueryFields(null);  
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
      
        if(!String.isEmpty(queryStr) && queryStr.endsWith(',')){

             queryStr = queryStr.substring(0,queryStr.length() -1);

             
             if(queryStr != null && !String.isEmpty(queryStr) && (schemaMap.get('Account').getDescribe().queryable)){

                String queryString='SELECT  '+queryStr +'  FROM Account where Id=\''+String.escapeSingleQuotes(accountId) + '\'';
                
                system.debug('Fields getting queried :'+queryString);
                
                
               List<Account> accList = Database.query(queryString);
      
               system.debug('Account record returned :'+accList);
          
               if(accList != null && accList.size()>0){
            
                    return accList.get(0);
            
               }else{
                
                 return null;
               }

             }else{

                return null;
             }
        
             
        }else{

          return null;

        }
        
       
      
    }
    
    
    /**
* @Description This method is used to get list of sessionM records for clean up service.
* @author Krunal
* @date 1-16-2018
* @return List<smsfsc__SessionMUser__c> List of SessionM record to delete
* @param deleteTimeRange Delete Time frame
* @param limitNumberOfRecords Limit for Soql Query for limiting the records.
*/

    public static List<smsfsc__SessionMUser__c>  getSesionMUserForCleanUp(DateTime deleteTimeRange,
    																	  Integer limitNumberOfRecords){
      
      Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
      List<smsfsc__SessionMUser__c> sessionMUserList = null;
      
      limitNumberOfRecords = limitNumberOfRecords - Limits.getDmlRows(); 
      
     
      
      system.debug(deleteTimeRange + ' deleteTimeRange ');      
      system.debug(limitNumberOfRecords + ' limitNumberOfRecords ');
      if(schemaMap.get('smsfsc__SessionMUser__c').getDescribe().queryable){

          sessionMUserList = Database.query('Select Id '+
 								            ' From smsfsc__SessionMUser__c '+  
 											' Where  Createddate <=: deleteTimeRange '+
 										    ' Order By CreatedDate ASC '+
										    ' LIMIT '+ limitNumberOfRecords);
    
       }
      
      
      return sessionMUserList;
      
    }
    
    
/**
* @Description This method is used to get sessionM record by AccountId
* @author Krunal
* @date 20-12-2017
* @return smsfsc__SessionMUser__c-->SessionM record
* @param accountId AccountId of account record
*/

    public static smsfsc__SessionMUser__c  getSessionMUserRecordByAccountId(Id accountId){
      
      Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
      
      String soqlQuery = queryBuilder('smsfsc__SessionMUser__c');
      if(soqlQuery!= null && !String.isEmpty(soqlQuery) && (schemaMap.get('smsfsc__SessionMUser__c').getDescribe().queryable)){

         List<smsfsc__SessionMUser__c> sessionMUserList = Database.query(soqlQuery+' where smsfsc__Account__c=\''+String.escapeSingleQuotes(accountId) + '\'' + ' and smsfsc__SessionMUserParent__c = null ');
    
          
          
          if(sessionMUserList != null && sessionMUserList.size()>0){
            
            return sessionMUserList.get(0);
            
          }else{
            
            return null;
          }
      }else{
        return null;
      }
     
  
    }
    
    
/**
* @Description This method is used to get the Account Record with Email and account record Id
* @author Krunal
* @date 20-12-2017
* @return Account-->Account object
* @param accountId AccountId of the account record
* @param emailfieldName Name of Email field in Account Object 
*/

    public static Account getAccountRecordWithEmail(Id accountId, String emailfieldName){
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        String fields = getAccountQueryFields(emailfieldName) ;
        String querySoql = null;
        if(fields!= null && !String.isEmpty(fields)&&(schemaMap.get('Account').getDescribe().queryable)){

            querySoql ='SELECT  '+ getAccountQueryFields(emailfieldName) +'  FROM Account where Id=\''+String.escapeSingleQuotes(accountId) + '\'';
            return Database.query( querySoql);

        }else{

          return null;

        }
                     
        
        
        
    }
    
    
/**
* @Description This method is used to get JSON map for custommetadata types
* @author Krunal
* @date 20-12-2017
* @return smsfsc__SessionM_Json_Mappings__mdt-->Custom metadata object that holds all the json mappings
* @param FIELD_MAP_MDT_NAME API name of custommetadata field 
*/

    public static  smsfsc__SessionM_Json_Mappings__mdt  getJsonMappingCustomMetadataTypes(String FIELD_MAP_MDT_NAME){
      
        String mapping = String.valueOf('\'') +FIELD_MAP_MDT_NAME+String.valueOf('\'');
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        
        smsfsc__SessionM_Json_Mappings__mdt jsonMpgCustMdt = null;
        
        if (!jsonMappingCustomMetaTypeMap.get('smsfsc__FieldMappingsJson__c').getDescribe().isAccessible() ) {

              
              throw new System.NoAccessException();
              return null;
        }
        
        if(schemaMap.get('smsfsc__SessionM_Json_Mappings__mdt').getDescribe().queryable)
        {
            List<smsfsc__SessionM_Json_Mappings__mdt> jsonMapingCustMdtList = Database.query('SELECT smsfsc__FieldMappingsJson__c from'+
                                                                                            ' smsfsc__SessionM_Json_Mappings__mdt  where QualifiedApiName =  '+mapping);
        
            if(jsonMapingCustMdtList != null && jsonMapingCustMdtList.size()>0){
                 jsonMpgCustMdt= jsonMapingCustMdtList.get(0);
            }
        }
        
        return jsonMpgCustMdt;
        
    }

/**
* @Description This method is used to get map of reasoncodes having apiname and label
* @author Manohar
* @date 20-12-2017
* @return Map<String,String>-->Map that holds labelName and apiName as key-value pairs
*/
    
public static  Map<String,String> getMapforReasonCodes()
{
        Map<String,String> mapofApi = new Map<String,String>();
        // Get a map of fields for the SObject
        Map <String, Schema.SObjectField> fieldMap = GeneralUtility.sessionMTransactionObjFieldMap;
       
        // Get the list of picklist values for this field.

        if(fieldMap.get('smsfsc__ReasonCodes__c').getDescribe().isAccessible()){
            list <Schema.PicklistEntry> values =
            fieldMap.get('smsfsc__ReasonCodes__c').getDescribe().getPickListValues();
        
            // Add these values to the selectoption list.
            for (Schema.PicklistEntry a: values) {
                
                
                mapofApi.put(a.getLabel(),a.getValue());
               
            }
        }
        
        
       return mapofApi;
       
}
    
   
      
}