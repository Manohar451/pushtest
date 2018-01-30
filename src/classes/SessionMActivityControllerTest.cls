/**
* @Description This is test class for SessionMActivityController class
* @author Manohar Pandurangi
* @date 21-12-2017
*/
@isTest
private class SessionMActivityControllerTest {
    
 /**
* @Description This method creates dummy data for test context
* @author Manohar Pandurangi
* @date 21-12-2017
*/

	
 @testSetup 
    static void setup() {
 	
 	
 	 smsfsc__SMLSettings__c listCustSettings =  TestDataFactory.createUnprotectedCustomSettings();
        insert listCustSettings;
        smsfsc__SMPSettings__c protectedCustSettings =  TestDataFactory.createProtectedCustomSettings();
        insert protectedCustSettings;
    	
    	String name = String.valueOf('\'') +'System Administrator'+ String.valueOf('\'');
	    List<Profile> profileList = Database.query('Select Id,Name from Profile  where Name = '+name);
	    
	    Profile profile = null;
	    if(profileList != null && profileList.size()>0){
	    	profile = profileList.get(0);
	    }
    	
    	User usr = new User(LastName ='lastName', email='email@email.com', 
					    	ProfileId=profile.id  ,Username='john4444444666@acme.com',CommunityNickname='cmn',
					    	TimeZoneSidKey='America/Los_Angeles',LocaleSidKey='en_US',Alias='als',
					    	EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
    	
    	insert usr;
         smsfsc__SMLSettings__c listCustomSettings =  TestDataFactory.createUnprotectedCustomSettingsfornegativecase();
         insert listCustomSettings;
        
        
        
        
    Account accountRecordPositive = TestDataFactory.createAccountRecord();
    insert accountRecordPositive;
    Account accountRecordNegative = TestDataFactory.createAccountRecordNegative();
    insert accountRecordNegative;
    smsfsc__SessionMUser__c sessionMUser= TestDataFactory.getSessionMUserRecord();
    insert sessionMUser;
     smsfsc__SessionM_Transaction__c transactionRecord =TestDataFactory.SessionMTransactionRecords();
     insert transactionRecord;
     
     system.assert(accountRecordPositive!=null);
 }
    
  
/**
* @Description This Method tests the SessionMActivityController for positive scenario i.e callout is succesful and all records are fetched
* @author Manohar Pandurangi
* @date 21-12-2017
*/

    
    @isTest
    private static void positiveTestCase()
    {
        String lastName = String.valueOf('\'') +'lastName'+ String.valueOf('\'');
        List<User> userList = Database.query('Select Id from User where lastName ='+lastName);
        
        User user = null;
        if(userList != null && userList.size()>0){
            user = userList.get(0);
        }
        
        
        
        System.debug(System.Label.Activities_Column_Header_Name);
        System.debug(System.Label.Activities_Column_Header_Type);
        System.debug(System.Label.Activities_Column_Header_Date);
        System.debug(System.Label.ReasonCode_Error_Message);
        
        
        
        System.runAs(user){
             smsfsc__SMLSettings__c listCustomSettings =  smsfsc__SMLSettings__c.getInstance('Default');
            smsfsc__SMPSettings__c protectedCustomSettings =  smsfsc__SMPSettings__c.getInstance('Default');
             Account account = null;
            String accName = String.valueOf('\'') +'testAccount123'+ String.valueOf('\'');
            List<Account> accountList = Database.query('SELECT Id FROM Account WHERE Name = '+accName);
            if(accountList != null && accountList.size()>0){
                account= accountList.get(0);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ActivityAPIResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
                Test.startTest();
                SessionMActivityController.init(account.Id);
                String testString = 'Testing';
                System.assert(testString!=null);
                Test.stopTest();
            }
        }
    }
    
 /**
* @Description This Method tests the SessionMActivityController for negative scenario i.e callout was unsuccesful and error json is returned
* @author Manohar Pandurangi
* @date 21-12-2017
*/

     @isTest
    private static void negativeTestCase()
    {
        String lastName = String.valueOf('\'') +'lastName'+ String.valueOf('\'');
        List<User> userList = Database.query('Select Id from User where lastName ='+lastName);
        
        User user = null;
        if(userList != null && userList.size()>0){
            user = userList.get(0);
        }
        
        
        
        
        System.runAs(user){
             smsfsc__SMLSettings__c listCustomSettings =  smsfsc__SMLSettings__c.getInstance('Default');
            system.debug('page size is'+listcustomSettings.smsfsc__PageSize__c);
            smsfsc__SMPSettings__c protectedCustomSettings =  smsfsc__SMPSettings__c.getInstance('Default');
             Account account = null;
            String accName = String.valueOf('\'') +'testAccount123'+ String.valueOf('\'');
            List<Account> accountList = Database.query('SELECT Id FROM Account WHERE Name = '+accName);
            if(accountList != null && accountList.size()>0){
                account= accountList.get(0);
                System.assert(account!=null);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ActivityAPIErrorResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
                Test.startTest();
                SessionMActivityController.init(account.Id);
                TimelineServices TimelineServicess = new TimelineServices();
                TimelineResponse activityResponse = new TimelineResponse();
                TimelineResponse.Context context = new  TimelineResponse.Context();
                Integer id = context.id;
                String name = context.name;
                Test.stopTest();
            }
        }
    }
    
  
    
    

}