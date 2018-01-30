/**
* @Description  Utility Class for Comping Service that handles all the necessary data to facilitate Comp functionality
* @author Manohar Pandurangi
* @date 11-11-2017
*/


public with sharing class SessionMCompingWrapperClass {
    
    //Current theme of user
    @AuraEnabled
    public string theme;
    
    //NetworkId to identify whether run in community or not
    @AuraEnabled
    public string networkId;
    
    //Boolean flag which checks if user is suspended or whether he opted out or not
    @AuraEnabled
    public boolean isSuspendedSessionMUser;
    
    //picklist values which are displayed on the page
    @AuraEnabled
    public List<String> pickListValues;
    
    //Account Id of the user
    @AuraEnabled
    public String accountId;
    
    //Message class object
    @AuraEnabled
    public Message msg;
    
    @AuraEnabled
    public boolean isInSufficientPrivilege;
    
    //Transaction Object
    @AuraEnabled
    public smsfsc__SessionM_Transaction__c transactobj;
    
    // old count -exitsting count 200
    @AuraEnabled
    public AggregateResult transactionsAggregate;
    
    /**
* @Description Constructor method of the above class Which takes Id of the Account Record and initializes the attributes of the class
* @author Manohar Pandurangi
* @date 11-11-2017
* @param actId AccountId of the Account Record
*/
    
    public SessionMCompingWrapperClass(String accountId){
    	
    	try{
        
	        theme=UserInfo.getUiThemeDisplayed();
	        networkId=Network.getNetworkId();
	        pickListValues=getselectOptions();
	        accountId = accountId;
	       
	        Account accountRecord = GeneralUtility.getAccountRecord(accountId);
	        system.debug('accountrecord is in wrapper'+accountRecord);
	        system.debug('accountrecord id in wrapper'+accountRecord.Id);
	        
	        
	        smsfsc__SessionMUser__c sessionMUser = GeneralUtility.getSessionMUserRecordByAccountId(accountId);
			system.debug('Queried SM User is : '+sessionMUser);
	        
	        
	        if(accountRecord.smsfsc__Loyalty_User__c && !sessionMUser.smsfsc__Suspended__c && sessionMUser.smsfsc__OptedIn__c ){
	            
	            isSuspendedSessionMUser= false;
	            
	        }else{
	            
	            isSuspendedSessionMUser= true;
	        }
        
        	 isInSufficientPrivilege = false;
        	
	        if(Schema.getGlobalDescribe().get('smsfsc__SessionM_Transaction__c').getDescribe().isAccessible() &&
	           Schema.getGlobalDescribe().get('smsfsc__SessionM_Transaction__c').getDescribe().isCreateable() ){
				   
				   system.debug('Inside accessible check block ');
	        
	              Map<String, Schema.SObjectField> sessionMTransactionObjFieldMap = GeneralUtility.sessionMTransactionObjFieldMap;
                  
                  //This code block checks if user has necessary permissions to create a new transaction record    
                  if(Schema.getGlobalDescribe().get('smsfsc__SessionM_Transaction__c').getDescribe().isAccessible() &&
                    Schema.getGlobalDescribe().get('smsfsc__SessionM_Transaction__c').getDescribe().isCreateable() ){
                    
                  	transactobj = new smsfsc__SessionM_Transaction__c(); 
                  
                    if(sessionMTransactionObjFieldMap.get('smsfsc__CumulativeAvailablePoints__c'.toLowerCase()).getDescribe().isAccessible() &&
                      sessionMTransactionObjFieldMap.get('smsfsc__CumulativeAvailablePoints__c'.toLowerCase()).getDescribe().isCreateable()){
                        
                        transactobj.smsfsc__CumulativeAvailablePoints__c= 0;
                  
                    }else{
                    	
                    	isInSufficientPrivilege = true;
                    }
                    
                    if(sessionMTransactionObjFieldMap.get('smsfsc__LoyaltyPoints__c'.toLowerCase()).getDescribe().isAccessible() &&
                      sessionMTransactionObjFieldMap.get('smsfsc__LoyaltyPoints__c'.toLowerCase()).getDescribe().isCreateable()){
                         
                         transactobj.smsfsc__LoyaltyPoints__c=0;
                         
                    }else{
                    	
                    	isInSufficientPrivilege = true;
                    }
                    
                    if(sessionMTransactionObjFieldMap.get('smsfsc__ReasonCodes__c'.toLowerCase()).getDescribe().isAccessible() &&
                      sessionMTransactionObjFieldMap.get('smsfsc__ReasonCodes__c'.toLowerCase()).getDescribe().isCreateable()){
                        
                          transactobj.smsfsc__ReasonCodes__c='';
                  
                    }else{
                    	isInSufficientPrivilege = true;
                    }
                    
                    if(sessionMTransactionObjFieldMap.get('smsfsc__Status__c'.toLowerCase()).getDescribe().isAccessible() &&
                      sessionMTransactionObjFieldMap.get('smsfsc__Status__c'.toLowerCase()).getDescribe().isCreateable()){
                        
                        transactobj.smsfsc__Status__c =GeneralConstants.CONST_APPROVED;
                  
                    }else{
                    	
                    	isInSufficientPrivilege = true;
                    }
                    
                    if(sessionMTransactionObjFieldMap.get('smsfsc__Account__c'.toLowerCase()).getDescribe().isAccessible() &&
                      sessionMTransactionObjFieldMap.get('smsfsc__Account__c'.toLowerCase()).getDescribe().isCreateable()){
                         
                          transactobj.smsfsc__Account__c=accountId;
						  transactionsAggregate = GeneralUtility.getTransactionCountForSessionMUser(accountId);
						  system.debug('Transaction Count is  : '+transactionsAggregate);
                  
                    }else{
                    	
                    	isInSufficientPrivilege = true;
                    }
                   
		    	} else{
		    		
		    		isInSufficientPrivilege = true;
		    	}
    
    		}
    		
            System.debug('privilages is    '+isInSufficientPrivilege);
    		if(isInSufficientPrivilege){
    			msg = new  Message(GeneralConstants.CONST_STATUS_ERROR, null,System.Label.smsfsc.Insufficient_Priviledges);
    		}else{
    			msg = new  Message(GeneralConstants.CONST_SUCCESS_MSG, null,null);
    		}
    	}
        catch(Exception e){
                
                msg = new  Message(GeneralConstants.CONST_STATUS_ERROR, null,e.getMessage());
                system.debug('exception is   '+e.getMessage());
               
        }
    }
    
    /**
* @Description This method iterates through the picklist values of the TransactionObject and returns a List of picklist values
* @author Manohar Pandurangi
* @date 11-11-2017
* @return List<String>-->which is list of picklist values
*/
    
    public static List <String> getselectOptions() {
        
        List <String> allOptions = new list < String > ();
        
        // Get a map of fields for the SObject
        Map <String, Schema.SObjectField> fieldMap = GeneralUtility.sessionMTransactionObjFieldMap;
        
        // Get the list of picklist values for this field.
        list <Schema.PicklistEntry> values =
            fieldMap.get('smsfsc__ReasonCodes__c').getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            
            allOptions.add(a.getLabel());
        }
        
        allOptions.sort();
        
        return allOptions;
    }    
}