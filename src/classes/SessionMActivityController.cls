/**
* @Description Controller Class For Activities Page that handles all the functionalities performed by  the user on Activities page
* @author Saptaswa
* @date 22-12-2107
*/



public with sharing class SessionMActivityController {
    
/**
* @Description This method is called when page loads initially and projects all the existing data onto page
* @author Saptaswa
* @date 22-12-2017
* @return ActivityUtilityWrapper-->wrapper object that has the intial values to be loaded on page
* @param accountId AccountId of the account record 
*/

    @AuraEnabled
    public static ActivityUtilityWrapper  init(Id accountId){
        
        Integer maxActivitySize = smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME) != null &&  
        smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME).smsfsc__MaxActivityRecords__c != Null ?
        Integer.valueOf(smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME).smsfsc__MaxActivityRecords__c) : 500;
                                  
        return ServicesRouter.fetchActivities(accountId,maxActivitySize);
    }
}