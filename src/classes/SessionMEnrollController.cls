/**
* @Description Controller Class For SessionEnrollCmp component that handles the functionality on enrolling user to loyalty programme
* @author Saptaswa
* @date 12-12-2017
*/

public with sharing class SessionMEnrollController{
    
    public static smsfsc__SMLSettings__c listCustomSettings {get;set;}
    public static EnrollUtilityWrapper enrolUtilityWrapper {get;set;}
  
/**
* @Description This method is called when page loads initially and projects all the existing data onto  the page
* @author Saptaswa
* @date 12-12-2017
* @return EnrollUtilityWrapper-->Wrapper class object that holds the data which is to be loaded on page when the page loads
* @param accountId AccountId of the account record 
*/
    @AuraEnabled
    public static EnrollUtilityWrapper initializeEnroll(Id accountId) {
        
        return populateAllFields(accountId);
    }

    
/**
* @Description This method is used to populate all the fields 
* @author Saptaswa
* @date 12-12-2017
* @return EnrollUtilityWrapper-->Wrapper class object that holds all the valid data to be loaded on the page when loaded
* @param accountId AccountId of the account record
*/

    private static EnrollUtilityWrapper populateAllFields(Id accountId)
    {
        EnrollUtilityWrapper enrollUtilityWrapper = new EnrollUtilityWrapper();

        String email = '';
        
        String emailfieldName =   smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME) != null &&  
                                  String.isNotBlank(smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME).smsfsc__EmailFieldInAccounts__c) ?
        						  smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME).smsfsc__EmailFieldInAccounts__c:
        						  '';
     
       enrollUtilityWrapper.accountEmail=  String.ValueOf(GeneralUtility.getAccountRecordWithEmail(accountId,emailfieldName).get(emailfieldName));
      //This code block here checks if user has an email,if the user doesnt have an email an error message iis displayed on UI
        if(enrollUtilityWrapper.accountEmail == null )
        {
            listCustomSettings = smsfsc__SMLSettings__c.getValues(System.Label.smsfsc.Custom_Setings_Name);
           
            enrollUtilityWrapper.accountEmailLabel=  EnrollService.accountObjFieldMap.get(listCustomSettings.smsfsc__EmailFieldInAccounts__c).getDescribe().getLabel(); 
            enrollUtilityWrapper.isEmailPresent = false;
            enrollUtilityWrapper.isEnroldisabled = true;
            enrollUtilityWrapper.isBackdisabled = true;
           
        }
        else{
            enrollUtilityWrapper.isEmailPresent = true;
            enrollUtilityWrapper.isEnroldisabled = false;
           enrollUtilityWrapper.isBackdisabled = false;
        }
     
        
       return enrollUtilityWrapper;   
    }
    
 
/**
* @Description Below method drives the functionality of enrolling the user in SessionM platform
* @author Saptaswa
* @date 12-12-2017
* @See ServicesRouter.enrollUser
* @return EnrollUtilityWrapper-->Wrapper object that holds all the data about success or failure of Enrolling user to SessionM platform
* @param emailId EmailId of the User 
* @param accountId AccountId of the Account record
* @param JSONstring Request which is to be sent to SessionM platform
*/

 
    @AuraEnabled
    public static EnrollUtilityWrapper enroll(String emailId, Id accountId,String JSONstring)
    {
        enrolUtilityWrapper= (EnrollUtilityWrapper)System.JSON.deserialize(JSONstring, EnrollUtilityWrapper.class);
        
        APIResult apiresult= ServicesRouter.enrollUser(emailId, accountId);
       
        if(apiresult.messages != null && !apiresult.messages.isEmpty()){

            enrolUtilityWrapper.isEnrolSuccess= apiresult.isSuccess;
            enrolUtilityWrapper.msg = apiresult.messages[0];
        }
        if(enrolUtilityWrapper.msg !=null)
        {
            return enrolUtilityWrapper;
        }
        else{
             return null;
        }
        
    }
   
}