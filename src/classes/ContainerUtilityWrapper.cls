/**
* @Description Utility class which is used by Conatiner component that performs necessary permission checks reuqired to perfom enroll,view,update and comp
* @author Oswin
* @date 18-12-2017
*/


public with sharing class ContainerUtilityWrapper {
    private static String customSettingsLabelName =  GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME;
    @AuraEnabled 
    public String theme = UserInfo.getUiThemeDisplayed();
    @AuraEnabled 
    public String networkId = Network.getNetworkId();
    @AuraEnabled 
    public Boolean isSufficientPrivilege{get;set;}
    @AuraEnabled 
    public Boolean isConfigured =  (smsfsc__SMLSettings__c.getValues(customSettingsLabelName) != Null) 
                                && (smsfsc__SMPSettings__c.getValues(customSettingsLabelName) != Null);
    @AuraEnabled 
    public Boolean isAccount{get;set;}
    @AuraEnabled 
    public Boolean isSessionMuser{get;set;}
    @AuraEnabled 
    public  Boolean hasEditAccess{get;set;}
    @AuraEnabled 
    public  Boolean hasNoAccess{get;set;}
    @AuraEnabled
    public Message responseMsg{get;set;}

    
 /**
* @Description Constructor class for ContainerUtilityWrapper class that takes account record Id as input and initializes all the variables of the class
* @author Oswin
* @date 18-12-2017
* @param accountId AccountId of the account record
*/

    public ContainerUtilityWrapper(Id accountId) {
        
        HttpResponse resp= null ;
        String status='';
        isAccount = String.valueOf(accountId.getsobjecttype()) == GeneralConstants.CONST_ACCOUNT_OBJ_NAME;
        isSessionMuser = false;
        hasNoAccess = false;
        hasEditAccess = false;
        isSufficientPrivilege = false;
        Map<String, Schema.SObjectField> fieldMap = EnrollService.sessinMUserObjFieldMap;
        
        if(isAccount){ 
        
            if(fieldMap.get('smsfsc__SessionMID__c'.toLowerCase()).getDescribe().isAccessible() && 
               fieldMap.get('smsfsc__SessionMID__c'.toLowerCase()).getDescribe().isUpdateable() && 
               fieldMap.get('smsfsc__Email__c'.toLowerCase()).getDescribe().isAccessible() &&
               fieldMap.get('smsfsc__Email__c'.toLowerCase()).getDescribe().isUpdateable() &&
               fieldMap.get('smsfsc__ExternalID__c'.toLowerCase()).getDescribe().isAccessible() &&
               fieldMap.get('smsfsc__ExternalID__c'.toLowerCase()).getDescribe().isUpdateable() &&
               fieldMap.get('smsfsc__Account__c'.toLowerCase()).getDescribe().isAccessible() &&
               fieldMap.get('smsfsc__Account__c'.toLowerCase()).getDescribe().isAccessible())
            {
                isSufficientPrivilege = true;
            //callout - get call 
                responseMsg = ServicesRouter.getSessionMUser(accountId);
               
                if(responseMsg != Null && responseMsg.msgType == 'success'){
                    
                    Account objAccount =  GeneralUtility.getAccountRecord(accountId);
                   
                    isSessionMuser = objAccount.smsfsc__Loyalty_User__c &&  GeneralUtility.getSessionMUserRecordByAccountId(accountId) != Null;
                    
                    PermissionsWrapper objPermsissions =  new PermissionsWrapper(GeneralConstants.CONST_SESSIONM_USER_SOBJ_NAME);
                    PermissionsWrapper fieldPermsissions =  new PermissionsWrapper(Account.smsfsc__Loyalty_User__c);
          PermissionsWrapper transactionPermissions = new PermissionsWrapper(GeneralConstants.CONST_SESSIONM_TRANSACTION_SOBJ_NAME);
        
        
                    if(objPermsissions.isUpdateable && objPermsissions.isAccessible 
                            && objPermsissions.isCreateable && fieldPermsissions.isUpdateable
                            && fieldPermsissions.isAccessible ){
                         
                         if(this.networkId != Null && isConfigured && smsfsc__SMLSettings__c.getValues(customSettingsLabelName).smsfsc__EnableEnrollInCommunity__c){
                            this.hasEditAccess = true;
                         }
                         else if(this.networkId == Null && transactionPermissions.isAccessible && transactionPermissions.isCreateable){
                            this.hasEditAccess = true;
                         }     
                    }
                    else if(objPermsissions.isAccessible && objPermsissions.isCreateable){
                        this.hasEditAccess = false;
                    }   
                    else {
                        this.hasNoAccess = true;
                    }
                }    
            }
            else{
                isSufficientPrivilege = false;
                responseMsg= new Message(GeneralConstants.CONST_STATUS_ERROR, null,System.Label.smsfsc.Insufficient_Priviledges);
            }
            system.debug('Access privilege is : '+isSufficientPrivilege);
        }
    } 
}