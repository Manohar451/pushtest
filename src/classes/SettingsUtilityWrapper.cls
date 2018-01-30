/**
* @Description Utility class for SessionMAppSettings page which has the valid data to be stored in custom settings as its member variables
* @author Oswin
* @date 11-11-2017
*/



public with sharing class SettingsUtilityWrapper {
    
  private static String customSettingsLabelName = GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME;
    @AuraEnabled 
    public smsfsc__SMLSettings__c listCustomSettings;
    @AuraEnabled 
    public smsfsc__SMPSettings__c protectedCustomSettings;
    @AuraEnabled
    public Boolean protectedCustomSettingsExist;
    @AuraEnabled
    public Boolean hasNecessaryAccess;
  @AuraEnabled
  public Message msg = new  Message(GeneralConstants.CONST_STATUS_ERROR, null, System.Label.smsfsc.Mandatory_Field_Error);
   
    
    /**
* @Description Constructor method for SettingsUtilityWrapper class that sets the class variables with some initial values
* @author Oswin
* @date 11-11-2017
*/

    public SettingsUtilityWrapper(){
        
        smsfsc__SMLSettings__c objListSettings = smsfsc__SMLSettings__c.getValues(customSettingsLabelName);
        Boolean listCustomSettingsExist = objListSettings != Null;

        PermissionsWrapper objlistCustomSettingPermission = new PermissionsWrapper('smsfsc__SMLSettings__c');
        PermissionsWrapper objProtectedSettingPermission = new PermissionsWrapper('smsfsc__SMPSettings__c');

        listCustomSettings = objListSettings != Null ? 
                             objListSettings : 
                             new smsfsc__SMLSettings__c(Name = customSettingsLabelName,
                                                      smsfsc__EmailFieldInAccounts__c = '',
                                                      smsfsc__EnableEnrollInCommunity__c = false,
                                                      smsfsc__PageSize__c = 10,
                                                      smsfsc__MaxActivityRecords__c = 500,
                                                      smsfsc__SessionMtoSalesforceMappingsAPIName__c = '',
                                                       smsfsc__SessionMTimeOut__c=3500);
                
        listCustomSettings.smsfsc__EmailFieldInAccounts__c = String.isBlank(listCustomSettings.smsfsc__EmailFieldInAccounts__c) ? '' : listCustomSettings.smsfsc__EmailFieldInAccounts__c;
        listCustomSettings.smsfsc__PageSize__c = listCustomSettings.smsfsc__PageSize__c == Null ? 10 : listCustomSettings.smsfsc__PageSize__c;
        listCustomSettings.smsfsc__MaxActivityRecords__c = listCustomSettings.smsfsc__MaxActivityRecords__c == Null ? 500 : listCustomSettings.smsfsc__MaxActivityRecords__c;
        listCustomSettings.smsfsc__SessionMtoSalesforceMappingsAPIName__c = String.isBlank(listCustomSettings.smsfsc__SessionMtoSalesforceMappingsAPIName__c) ? '' : listCustomSettings.smsfsc__SessionMtoSalesforceMappingsAPIName__c;
        listCustomSettings.smsfsc__SessionMTimeOut__c = listCustomSettings.smsfsc__SessionMTimeOut__c == Null ? 3500 : listCustomSettings.smsfsc__SessionMTimeOut__c;
        
        smsfsc__SMPSettings__c objProtectedSettings = smsfsc__SMPSettings__c.getValues(customSettingsLabelName);
        protectedCustomSettingsExist = objProtectedSettings != Null;
        protectedCustomSettings =  protectedCustomSettingsExist ? 
                                   objProtectedSettings : 
                                   new smsfsc__SMPSettings__c(Name = customSettingsLabelName,
                                                             smsfsc__APIEndpoint__c = '',
                                                             smsfsc__APIKey__c = '',
                                                             smsfsc__APISecret__c = '',
                                                             smsfsc__APIVersion__c = '');
                                                             
        protectedCustomSettings.smsfsc__APIEndpoint__c = String.isBlank(protectedCustomSettings.smsfsc__APIEndpoint__c) ? '' : protectedCustomSettings.smsfsc__APIEndpoint__c;
        protectedCustomSettings.smsfsc__APIKey__c = String.isBlank(protectedCustomSettings.smsfsc__APIKey__c) ? '' : protectedCustomSettings.smsfsc__APIKey__c;
        protectedCustomSettings.smsfsc__APISecret__c = String.isBlank(protectedCustomSettings.smsfsc__APISecret__c) ? '' : protectedCustomSettings.smsfsc__APISecret__c;
        protectedCustomSettings.smsfsc__APIVersion__c = String.isBlank(protectedCustomSettings.smsfsc__APIVersion__c) ? '' : protectedCustomSettings.smsfsc__APIVersion__c;
        
        hasNecessaryAccess = (listCustomSettingsExist && protectedCustomSettingsExist) ? 
                            (objProtectedSettingPermission.isUpdateable &&  objlistCustomSettingPermission.isUpdateable) :
                            (objProtectedSettingPermission.isCreateable &&  objlistCustomSettingPermission.isCreateable);


                                  
    }

    
    /**
* @Description This method does necessary validations on the data entered by user in fields of App settings page
* @author Manohar Pandurangi
* @date 11-11-2017
*@return Boolean-->true if validation check passes and false if validation check fails
* @param objSettingsUtilityWrapper Object of SettingsUtilityWrapper 
* @param messages List Of Messages
*/

    public static Boolean ValidationCheck(SettingsUtilityWrapper objSettingsUtilityWrapper, List<Message> messages){
        
            if(GeneralUtility.getJsonMappingCustomMetadataTypes(objSettingsUtilityWrapper.listCustomSettings.smsfsc__SessionMtoSalesforceMappingsAPIName__c) == null){
               messages.add ( new  Message(GeneralConstants.CONST_STATUS_ERROR, null, System.Label.Mappings_Not_Found));
               return false;
            }

            Map<String, Schema.SObjectField> accountObjFieldMap = EnrollService.accountObjFieldMap;
            if(accountObjFieldMap.containsKey(objSettingsUtilityWrapper.listCustomSettings.smsfsc__EmailFieldInAccounts__c.toLowerCase())){
                
                if(accountObjFieldMap.get(objSettingsUtilityWrapper.listCustomSettings.smsfsc__EmailFieldInAccounts__c.toLowerCase()).getDescribe().getType() != Schema.DisplayType.Email){
                    messages.add ( new  Message(GeneralConstants.CONST_STATUS_ERROR, null, System.Label.smsfsc.Email_Field_DataType_Error));
                    return false;
                }
            }
            else{
                messages.add ( new  Message(GeneralConstants.CONST_STATUS_ERROR, null, System.Label.smsfsc.Field_Does_Not_Exist));
                return false;
            }

           return true; 
                 
        }
    
}