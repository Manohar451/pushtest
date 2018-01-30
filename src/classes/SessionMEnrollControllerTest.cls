/**
* @Description Test Class for SessionMEnrollControllerClass
* @author Saptaswa
* @date 23-12-2018
*/


@isTest
private class SessionMEnrollControllerTest {
    
/**
* @Description Test method for SessionMEnrollController class which sets up dummy data in test context
* @author Saptaswa
* @date 23-12-2018
*/

    testmethod static void testEnrollController(){
        
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
        

        smsfsc__SMLSettings__c listCustomSettings =  TestDataFactory.createUnprotectedCustomSettings();
        insert listCustomSettings;
        
        smsfsc__SMPSettings__c protectedCustomSettings =  TestDataFactory.createProtectedCustomSettings();
        insert protectedCustomSettings;
        
        Account account = TestDataFactory.createAccountRecord();
        insert account;
        
        System.assert(account!=null);
        
        Test.startTest();
        
         System.runAs(usr){
    	
    		listCustomSettings =  smsfsc__SMLSettings__c.getInstance('Default');
			
			EnrollUtilityWrapper enwrapper = new EnrollUtilityWrapper();
            string enrollResultType = enwrapper.enrollResultType;
            string enrollmsgHeader = enwrapper.enrollResultMsgHeader;
            string enrollfailure = enwrapper.enrollFailure;
            boolean isback = enwrapper.isBackdisabled;
            Account acc = enwrapper.accountRecord;
            APIResult apiresult = enwrapper.apiResult;
            boolean displayback = enwrapper.isDisplayBack;
    		
	        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
	        
	        mock.setStaticResource('EnrollPositiveResponse2Json');//Setting the static response EnrollPositive data as response
	        mock.setStatusCode(200);
	        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
	        mock.setStatus('OK');
	        
	        // Associate the callout with a mock response
	        
	        Test.setMock(HttpCalloutMock.class, mock);
             	EnrollUtilityWrapper euw = SessionMEnrollController.initializeEnroll(account.id);
             	SessionMEnrollController.enroll('aa@aa.com', account.id,JSON.serialize(euw));
	        }
    	
        
        Test.stopTest();
    }

}