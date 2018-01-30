/**
* @Description Controller Class For SessionMViewCmp component which displays the data of user enrolled into SessionM platform
* @author Saptaswa
* @date 22-12-2017
*/


public with sharing class SessionMViewController {
    
/**
* @Description This method is called when page loads initially and projects all the existing user data onto page
* @author Saptaswa
* @date 22-12-2017
* @return ViewUtilityWrapper-->wrapper class object that has all the data to be loaded on page when page loads 
* @param accId AccountId of account record
*/

    @AuraEnabled
    public static ViewUtilityWrapper  init(Id accId) {
        return new ViewUtilityWrapper(accId);
    }
    
    
    /**
	* @Description This method fetches email field value of account.
	* @author Saptaswa
	* @date 22-12-2017
	* @return String  Value of email field of account if found else null. 
	* @param accId Id of account record
	*/
    
     @AuraEnabled
    public static String checkAccountEmail(Id accId) {
        
         String emailfieldName =   smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME) != null &&  
                                  String.isNotBlank(smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME).smsfsc__EmailFieldInAccounts__c) ?
                      smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME).smsfsc__EmailFieldInAccounts__c:
                      '';
                      
        String accountEmail = null; 
                      
        if(emailfieldName != null && emailfieldName.length() >0  ){
        	
        	Account accountObj = GeneralUtility.getAccountRecordWithEmail(accId,emailfieldName);
        	
        	if(accountObj != null){
        	
        		accountEmail = String.ValueOf(accountObj.get(emailfieldName));
	        
		        if(accountEmail != null)
		        {
		            return accountEmail;
		        }
        	}
        }
        
        return accountEmail;
		        
                      
        
    }
}