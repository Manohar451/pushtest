/**
* @Description This is class where dummy records for test classes are created and it is object builder factory for all test classes
* @author Manohar Pandurangi
* @date 11-11-2017
*/


public with sharing class TestDataFactory {

 /**
* @Description Used to create Accountrecords for test context
* @author Manohar Pandurangi
* @date 11-11-2017
* @return Account-->Account object
*/


	public static Account createAccountRecord()	{
		 
		  Account acc = new Account(Name='testAccount123',smsfsc__Loyalty_User__c=true);
		  return acc;
	 }
 
  
    
 /**
* @Description Used to create conatctrecords for test context
* @author Manohar Pandurangi
* @date 11-11-2107
* @return Contact-->Contact Object
*/

	public static Contact createContactRecords(){
	
		  Contact con = new Contact(LastName='testdata');
		  System.assert(con!=null);
		  return con;
	 }
 
   
    /**
* @Description Used to create protected custom settings for test context
* @author Manohar Pandurangi
* @date 11-11-2107
* @return smsfsc__SMPSettings__c-->custom settings protected
*/

    public static smsfsc__SMPSettings__c createProtectedCustomSettings() {
           
           smsfsc__SMPSettings__c smp = new smsfsc__SMPSettings__c(Name='Default',
                                                                    smsfsc__APIEndpoint__c=EncodingUtil.base64Encode(Blob.valueOf('https://api-sapient.stg-sessionm.com/')),
                smsfsc__APIKey__c=EncodingUtil.base64Encode(Blob.valueOf('bbe72ac7663a7118b69251eab37545c3fbbadcb4')),
                smsfsc__APIVersion__c=EncodingUtil.base64Encode(Blob.valueOf('v1')),
                smsfsc__APISecret__c=EncodingUtil.base64Encode(Blob.valueOf('491121168d4b4b67ad6f4e475b8d745576ddc531')));
                 
            return smp;
    }
    
    
/**
* @Description Used to create unprotected custom settings for test context
* @author Manohar Pandurangi
* @date 11-11-2017
* @return smsfsc__SMLSettings__c-->custom settings unprotected
*/

    public static smsfsc__SMLSettings__c createUnprotectedCustomSettings() {
    	
           string name =System.Label.smsfsc.Custom_Setings_Name;
           smsfsc__SMLSettings__c sml = new smsfsc__SMLSettings__c(Name='Default',smsfsc__EmailFieldInAccounts__c='Sic',
                                                                    smsfsc__SessionMtoSalesforceMappingsAPIName__c='smsfsc__SessionM_to_Salesforce_API_Mapping',smsfsc__PageSize__c=10);
           return sml;
            
    }
    
    /**
* @Description Used to create unprotected custom settings for test context
* @author Manohar Pandurangi
* @date 11-11-2017
* @return smsfsc__SMLSettings__c-->custom settings unprotected
*/

     public static smsfsc__SMLSettings__c createUnprotectedCustomSettingsfornegativecase() {
    	
           string name =System.Label.smsfsc.Custom_Setings_Name;
           smsfsc__SMLSettings__c sml = new smsfsc__SMLSettings__c(Name='Default',smsfsc__EmailFieldInAccounts__c='Sic',
                                                                    smsfsc__SessionMtoSalesforceMappingsAPIName__c='smsfsc__SessionM_to_Salesforce_API_Mapping',smsfsc__PageSize__c=null);
           return sml;
            
    }
    
    
    /**
* @Description Used to create SessionMUserRecords for test context
* @author Manohar Pandurangi
* @date 11-11-2017
* @return smsfsc__SessionMUser__c-->SessionM record
*/


    
    public static smsfsc__SessionMUser__c getSessionMUserRecord(){
  
	    smsfsc__SessionMUser__c smUser = new smsfsc__SessionMUser__c();
	    
	    String name = String.valueOf('\'') +'testAccount123'+ String.valueOf('\'');
	    List<Account> accountList = Database.query('SELECT Id FROM Account WHERE Name = '+name);
	    
	    Account account = null;
	    if(accountList != null && accountList.size()>0){
	    	account= accountList.get(0);
	    }
	    
	    System.assertNotEquals(account,null);
	    
	    smUser.Account__c=account.Id;
	    return smUser;
	    
	 }
    
    /**
* @Description Used to create Accountrecords for negative test scenario in test context
* @author Manohar Pandurangi
* @date 11-11-2017
* @return Account-->Account record
*/

	public static Account createAccountRecordNegative()	{
		
		  Account acc = new Account(Name='testAccount123NN',smsfsc__Loyalty_User__c=false);
		  return acc;
	 }
 
    
/**
* @Description Used to create SessionMUserRecords for test context
* @author Manohar Pandurangi
* @date 11-11-2017
* @return smsfsc__SessionMUser__c-->SessionM record
*/

    
    public static smsfsc__SessionMUser__c getSessionMUserRecordsNegative(){
  
	    smsfsc__SessionMUser__c smUser = new smsfsc__SessionMUser__c();
	    
	    String name = String.valueOf('\'') +'testAccount123'+ String.valueOf('\'');
	    List<Account> accountList = Database.query('SELECT Id FROM Account WHERE Name = '+name);
	    
	    Account account = null;
	    if(accountList != null && accountList.size()>0){
	    	account= accountList.get(0);
	    }
	    
	    System.assertNotEquals(account,null);
	    
	    smUser.Account__c=account.Id;
	    return smUser;
	   
 	}
   
    
    
/**
* @Description This method is used to create Transaction object records for test context
* @author Manohar Pandurangi
* @date 11-11-2017
* @return smsfsc__SessionM_Transaction__c-->transaction record
*/

   public static smsfsc__SessionM_Transaction__c SessionMTransactionRecords()
    {
        String name = String.valueOf('\'') +'testAccount123'+ String.valueOf('\'');
	    List<Account> accountList = Database.query('SELECT Id FROM Account WHERE Name = '+name);
	    
	    Account account = null;
	    if(accountList != null && accountList.size()>0){
	    	account= accountList.get(0);
	    }
	    
	    System.assertNotEquals(account,null);
	    
        smsfsc__SessionMUser__c sessionmuser = GeneralUtility.getSessionMUserRecordByAccountId(account.id);
        
        smsfsc__SessionM_Transaction__c sm = new smsfsc__SessionM_Transaction__c(smsfsc__Account__c=account.id);
        
        
        return sm;
        
        
        
    }
    
    
    
    
}