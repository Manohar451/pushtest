/**
* @Description Utility Class for ViewServices that checks the user level permissions on various functionalities on View Page like Update,Comp
* @author Oswin
* @date 22-12-2017
*/


public with sharing class ViewUtilityWrapper {
    
    @AuraEnabled 
    public String networkId = Network.getNetworkId();

    @AuraEnabled
    public Boolean hasAllAccess;

    @AuraEnabled
    public Boolean hasCompAccess;

    @AuraEnabled
    public Boolean hasUpdateAccess;

    @AuraEnabled
    public smsfsc__SessionMUser__c objSessionMUser;

    
    
/**
* @Description Constructor Class for ViewUtilityWrapper which takes Id of account record as input and initializes all the attributes of class
* @author Oswin
* @date 22-12-2017
* @param accountId AccountId of the account record
*/

    public ViewUtilityWrapper(Id accountId) {

        objSessionMUser = GeneralUtility.getSessionMUserRecordByAccountId(accountId);
        hasAllAccess = false;
        hasCompAccess = false;
        hasUpdateAccess = false; 
        
        if(objSessionMUser != Null){
            
            PermissionsWrapper sessionMUserPermissions = new PermissionsWrapper(GeneralConstants.CONST_SESSIONM_USER_SOBJ_NAME);
            PermissionsWrapper  sessionMTransactionsPermissions = new PermissionsWrapper(GeneralConstants.CONST_SESSIONM_TRANSACTION_SOBJ_NAME);
            PermissionsWrapper loyaltyFieldPermissions = new PermissionsWrapper(Account.smsfsc__Loyalty_User__c);
            
            //checks if user has necessary permissions on SessionM user record to acess,update and delete the record
            Boolean hasAccessOnSessionMUser = sessionMUserPermissions.isAccessible && 
                                              sessionMUserPermissions.isCreateable &&
                                              sessionMUserPermissions.isUpdateable &&
                                              sessionMUserPermissions.isDeletable;
            
             //checks if user has necessary permissions on SessionM transaction record to acess,update and delete the record
            Boolean hasAccessOnSessionMTransaction = sessionMTransactionsPermissions.isAccessible &&
                                                     sessionMTransactionsPermissions.isCreateable;
            

            hasAllAccess =  hasAccessOnSessionMUser &&
                            hasAccessOnSessionMTransaction &&
                            loyaltyFieldPermissions.isAccessible &&
                            loyaltyFieldPermissions.isUpdateable;

            if(!hasAllAccess){
                hasUpdateAccess =   hasAccessOnSessionMUser &&
                                    loyaltyFieldPermissions.isAccessible &&
                                    loyaltyFieldPermissions.isUpdateable;

                hasCompAccess =     hasAccessOnSessionMUser &&
                                    hasAccessOnSessionMTransaction &&
                                    loyaltyFieldPermissions.isAccessible;
            }
        }
        
    }
}