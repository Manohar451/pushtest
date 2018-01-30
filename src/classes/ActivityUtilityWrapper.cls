/**
* @Description  Utility Class for Activity Service that conatins page size,maximum number of records to be fetched from callout and UI messages
* @author Saptaswa
* @date 22-12-2017
*/


public with sharing class ActivityUtilityWrapper {
    
    @AuraEnabled
    public List<TimeLineWrapperDetails> activityList;
    
    @AuraEnabled
    public Message msg;
    
    @AuraEnabled
    public Integer pageSize = smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME) != null &&  
                              smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME).smsfsc__PageSize__c  != null ?
                              Integer.valueOf(smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME).smsfsc__PageSize__c):
                              1;
   
    @AuraEnabled
    public Integer maxActivitySize = smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME) != null &&  
                                     smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME).smsfsc__MaxActivityRecords__c != Null ?
                                     Integer.valueOf(smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME).smsfsc__MaxActivityRecords__c) : 500;

}