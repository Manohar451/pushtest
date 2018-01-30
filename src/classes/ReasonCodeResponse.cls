/**
* @Description Parser Class for ReasonCodeResponse json string which is sent by SessionM platform when user performs callouts to SessionM API
* @author Manohar
* @date 20-11-2017
*/

public with sharing class ReasonCodeResponse {
    @AuraEnabled
    public string status{get;set;}
    @AuraEnabled
    public List<ReasonsPickListValues> reasons {get;set;}
    @AuraEnabled
    public APIResult apiResult;
    
    
/**
* @Description Inner Class of ReasonCodeResponse class that contains all the data received from SessionM API Response as its member variables
* @author Manohar
* @date 20-11-2017
*/
    
    public class ReasonsPickListValues {
        
        @AuraEnabled
        public Integer  id {get;set;}
        @AuraEnabled
        public String  text {get;set;}
        @AuraEnabled
        public String target_type {get;set;}
     
    }
  
    
/**
* @Description Method that parses the json string received as response from SessionM API on performing callout
* @author Manohar
* @date 20-11-2017
* @return type ReasonCodeResponse-->Deserialized json response that is received from SessionM platform
* @param json JSON String received from the Response
*/
   
    public static ReasonCodeResponse parse(String json) {
        return (ReasonCodeResponse) System.JSON.deserialize(json, ReasonCodeResponse.class);
    }

}