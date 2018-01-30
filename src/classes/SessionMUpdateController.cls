/**
* @Description Controller Class For SessionMUpdateCmp component that handles all the functionalities performed on Update page
* @author Saptaswa
* @date 22-12-2017
*/

public  with sharing class SessionMUpdateController {
    
/**
* @Description This method is called when page loads initially and projects all the existing data onto page
* @author Saptaswa
* @date 22-12-2017
* @See ServicesRouter.fetchSessionMUserRecord
* @return smsfsc__SessionMUser__c-->That is SessionM user record
* @param accId AccountId of the account record
*/

    @AuraEnabled
    public static smsfsc__SessionMUser__c  init(Id accId) {
        
        return ServicesRouter.fetchSessionMUserRecord(accId);
        
    }
    
    /**
* @Description This method is used to display UI messages for insufficient priviledges
* @author Saptaswa
* @date 1-16-2018
* @return boolean whether user has access or not , If it is then true is returned
*
*/

    @AuraEnabled
    public static Boolean checkAccess(){
        
        Map<String, Schema.SObjectField> fieldMap = EnrollService.sessinMUserObjFieldMap;
        
        if(fieldMap.get('smsfsc__SessionMID__c'.toLowerCase()).getDescribe().isAccessible() && 
               fieldMap.get('smsfsc__SessionMID__c'.toLowerCase()).getDescribe().isUpdateable() && 
               fieldMap.get('smsfsc__Email__c'.toLowerCase()).getDescribe().isAccessible() &&
               fieldMap.get('smsfsc__Email__c'.toLowerCase()).getDescribe().isUpdateable() &&
               fieldMap.get('smsfsc__ExternalID__c'.toLowerCase()).getDescribe().isAccessible() &&
               fieldMap.get('smsfsc__ExternalID__c'.toLowerCase()).getDescribe().isUpdateable() &&
               fieldMap.get('smsfsc__Account__c'.toLowerCase()).getDescribe().isAccessible() &&
               fieldMap.get('smsfsc__Account__c'.toLowerCase()).getDescribe().isAccessible())
            {
                return true;
            }else
            {
             return false;
            }
    }
    
    
/**
* @Description This method is used to display UI messages
* @author Saptaswa
* @date 22-12-2017
* @See ServicesRouter.modifySessionMUser
* @return Message-->Message objects that holds msgtext,msgcode,msgtype 
* @param sessionMUserObjId Id of SessionM user record
*/

    @AuraEnabled
    public static Message modifySessionMUser(Id sessionMUserObjId){
        
        return ServicesRouter.modifySessionMUser(sessionMUserObjId);
        
    }
    
/**
* @Description This method is used to remove the duplicate/junk record created when performing Update operation on user data
* @author Saptaswa
* @date 22-12-2017
* @See ServicesRouter.cleanUpForUpdateServices
* @param newSessionMUserObjId Id of SessionM user record
*/

    @AuraEnabled
    public static void cleanUpForUpdateServices(Id newSessionMUserObjId){
        
         ServicesRouter.cleanUpForUpdateServices(newSessionMUserObjId );
    }
}