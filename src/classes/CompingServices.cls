/**
* @Description This class is the Service class which drives the functionality to add/remove points to the user enrolled into the  SessionM platform
* @author Manohar Pandurangi
* @date 11-11-2017
*/


public with sharing class CompingServices {
    
/**
* @Description This method retrieves the endpoint for performing callouts
* @author Manohar Pandurangi
* @date 11-11-2017
* @See GeneralUtility
* @return String-->URL string which is used to make callouts to SessionM platform
* @param sessionMId SessionMId of the User
*/

    public static String getUrlForComping(String sessionMId){
    
              
        String endPointUrl = GeneralUtility.correctEndPointURL()+
                             GeneralConstants.CONST_PRIV_STRING_FOR_CALL_OUT+
                             GeneralUtility.API_VERSION+
                             GeneralConstants.CONST_APPS_STRING_FOR_CALL_OUT+
                             GeneralUtility.API_KEY+
                             GeneralConstants.CONST_POINTS_CONTEXT_POINTS+
                             sessionMId+
                             GeneralConstants.CONST_POINTS_CONTEXT_POINTS1;
        
        return endPointUrl;
        
    }
    
/**
* @Description This method is used to update points for the user enrolled into SessionM platform
* @author Manohar Pandurangi
* @date 11-11-2017
* @return Message-->Message object that holds messagetype,messagetext and messagecode
* @param compingWrapper SessionMCompingWrapperClass object that holds all the data to be updated after adding/removing points to the user
*/

    public static Message computePoints(SessionMCompingWrapperClass compingWrapper){
            
       PointsResponse reasonCodeResp = null; 
       HttpResponse response = null;
       List<Message> postMsgs = new  List<Message>();
       APIResult postResultToReturn = new  APIResult(true, postMsgs); 
       String jsonBodyForPoints=null;
       Exception exp = null;
       smsfsc__SessionMUser__c sessionMUserObj= null;
       
       String freeformAPIname = null;
        Long points = null;

        try{
            
             points= Double.valueOf(compingWrapper.transactobj.smsfsc__LoyaltyPoints__c).longValue();
            
            Map<String,String> reasonCodeMap = GeneralUtility.getMapforReasonCodes();
            freeformAPIname= reasonCodeMap.get(compingWrapper.transactobj.smsfsc__ReasonCodes__c);
            
            if(compingWrapper.accountId !=null ){
            
               sessionMUserObj= GeneralUtility.getSessionMUserRecordByAccountId(compingWrapper.accountId);
                       
               
                if(sessionMUserObj != null){
                	
                	jsonBodyForPoints = PointsRequestJSONGenerator.generatePointsJsonRequest(points,sessionMUserObj.smsfsc__SessionMID__c,freeformAPIname);
                    
                    System.debug('jsonbody'+jsonBodyForPoints);
        
       
                    response = GeneralUtility.makeCalloutToSessionM(getUrlForComping(sessionMUserObj.smsfsc__SessionMID__c), GeneralConstants.CONST_POST_METHOD, GeneralUtility.getCommonHeadersForRequest(), jsonBodyForPoints);
                    System.debug('response body is before http errors  '+response.getBody());
                   System.debug('status code is   '+response.getStatusCode());
                }
                            }           
            }catch(Exception e){
           
              exp =e;
              system.debug('---exception is  ---'+e.getMessage() );
              postResultToReturn.isSuccess = false;

           
            }

            try{
            
              if(response != null){
                
                  if((response.getBody() !=null ) && !String.isEmpty(response.getBody())){
                
                      if(response.getBody().startsWith('{'))
                      {
                          reasonCodeResp =(PointsResponse)JSON.deserialize(response.getBody(), PointsResponse.class);}
                      else
                      {
                             reasonCodeResp=null;                       
                      }
                      //If user is succesfully added/removed points then create a new SessionM Transaction record and insert Points added and Reasoncode into the record
                        if(reasonCodeResp != null && 
                         reasonCodeResp.status ==  GeneralConstants.CONST_STATUS_OK && 
                         response.getStatusCode() == 200  &&
                         response.getStatus() == GeneralConstants.CONST_STATUS_OK) {
                        
                           
                          smsfsc__SessionM_Transaction__c smTransactionObj = new smsfsc__SessionM_Transaction__c();
                        
                          Map<String, Schema.SObjectField> sessionMTransactionObjFieldMap = GeneralUtility.sessionMTransactionObjFieldMap;
                          
                          //This code block checks if user has necessary permissions to create a new transaction record    
                          if(Schema.getGlobalDescribe().get('smsfsc__SessionM_Transaction__c').getDescribe().isAccessible() &&
                            Schema.getGlobalDescribe().get('smsfsc__SessionM_Transaction__c').getDescribe().isCreateable() ){
                            
                            smTransactionObj = new smsfsc__SessionM_Transaction__c();   
                          
                            if(sessionMTransactionObjFieldMap.get('smsfsc__CumulativeAvailablePoints__c'.toLowerCase()).getDescribe().isAccessible() &&
                              sessionMTransactionObjFieldMap.get('smsfsc__CumulativeAvailablePoints__c'.toLowerCase()).getDescribe().isCreateable()){
                                 smTransactionObj.smsfsc__CumulativeAvailablePoints__c =reasonCodeResp.user.available_points;
                          
                            }
                            
                            if(sessionMTransactionObjFieldMap.get('smsfsc__LoyaltyPoints__c'.toLowerCase()).getDescribe().isAccessible() &&
                              sessionMTransactionObjFieldMap.get('smsfsc__LoyaltyPoints__c'.toLowerCase()).getDescribe().isCreateable()){
                                 smTransactionObj.smsfsc__LoyaltyPoints__c = points.intValue();
                          
                            }
                            if(sessionMTransactionObjFieldMap.get('smsfsc__ReasonCodes__c'.toLowerCase()).getDescribe().isAccessible() &&
                              sessionMTransactionObjFieldMap.get('smsfsc__ReasonCodes__c'.toLowerCase()).getDescribe().isCreateable()){
                                
                                  smTransactionObj.smsfsc__ReasonCodes__c =String.valueOf(freeformAPIname);
                          
                            }
                            if(sessionMTransactionObjFieldMap.get('smsfsc__Status__c'.toLowerCase()).getDescribe().isAccessible() &&
                              sessionMTransactionObjFieldMap.get('smsfsc__Status__c'.toLowerCase()).getDescribe().isCreateable()){
                                 smTransactionObj.smsfsc__Status__c =GeneralConstants.CONST_APPROVED;
                          
                            }
                            
                            if(sessionMTransactionObjFieldMap.get('smsfsc__Account__c'.toLowerCase()).getDescribe().isAccessible() &&
                              sessionMTransactionObjFieldMap.get('smsfsc__Account__c'.toLowerCase()).getDescribe().isCreateable()){
                                 
                                  smTransactionObj.smsfsc__Account__c =compingWrapper.accountId;
                          
                            }
                            
                            insert smTransactionObj;

                            postResultToReturn.isSuccess = true;
                            
                          }
                           
                        }else{
                
                              postResultToReturn.isSuccess = false;
                        } 
            
                }
              
            }
            }catch(Exception e){
                exp =e;
                postResultToReturn.isSuccess = false;
            }
            
                //This code block handles HTTP errors occured while performing comp operation and displays corresponding error message either native or received from platform 

             if(reasonCodeResp != null ){
                
                 System.debug('Manohar   '+response.getBody());
                 GeneralUtility.handleHttpErrors(response,reasonCodeResp.status, postResultToReturn,exp,GeneralConstants.CONST_SERVICE_TYPE_COMP);
                 
              }else{
                  
                 reasonCodeResp = new PointsResponse();
                  
                 GeneralUtility.handleHttpErrors(response,null, postResultToReturn,exp,GeneralConstants.CONST_SERVICE_TYPE_COMP);
                  
              }
        
        

        System.debug('failure or not is '+postResultToReturn.messages[0].msgText);
        
       
        return postResultToReturn.messages[0];
       
             
    }

    
}