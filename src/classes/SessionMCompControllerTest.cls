/**
* @Description This is test class for SessionMCompController,SessionMCompingWrapper,PointsResponse,PointsRequestHelper,PointsRequestJSONGenerator
* @author Manohar Pandurangi
* @date 11-11-2017
*/

 
@isTest
private class SessionMCompControllerTest {
/**
* @Description This method creates dummy data in test context
* @author Manohar Pandurangi
* @date 11-11-2017
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
* @Description This method tests the controller for happy path i.e callout is succesful and points are added succesfully
* @author Manohar Pandurangi
* @date 11-11-2017
*/
@isTest
private static void TestPositiveCase(){
        
        Account accountRecord = [select Id from Account where Name='testAccount123' LIMIT 1];
        smsfsc__SessionMUser__c sessionmuser = [select Id from smsfsc__SessionMUser__c where smsfsc__Account__c=:accountRecord.Id];
        Test.startTest();
        List<String> reasonList = new List<String>();
        System.debug('account id in debug is '+accountRecord.Id);
      // SessionMCompingWrapperClass smWrapper = SessionMCompController.init(accountRecord.Id);
         //system.debug('account record is'+smWrapper.accountId);
        smsfsc__SessionM_Transaction__c sessionMTransaction = [select Id,smsfsc__ReasonCodes__c,smsfsc__Account__c from smsfsc__SessionM_Transaction__c where smsfsc__Account__c=:accountRecord.Id];
        
        system.debug('list of reasons'+reasonList);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('PointsPositiveResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        Message msg ;
       Message message = null;
        //SessionMCompingWrapperClass smcompwrapper= new SessionMCompingWrapperClass(accountRecord.Id);
        SessionMCompingWrapperClass smWrapper = SessionMCompController.init(accountRecord.Id);
       SessionMCompingWrapperClass compingWrapper = new SessionMCompingWrapperClass(accountRecord.Id);
       compingWrapper.accountId=accountRecord.Id;
       System.debug('manohar abfibf'+compingWrapper.accountId);
       system.debug('json stirng is '+JSON.serialize(compingWrapper));
        message=SessionMCompController.computePoints(JSON.serialize(compingWrapper));
        
       System.assert(message!=null);
   
   
    
        Test.stopTest();
          
     
    }
  
    
/**
* @Description This method tests the controller for negative scenario when callout failed and an error json is received
* @author Manohar Pandurangi
* @date 11-11-2017
*/
    
    @isTest 
    private static void TestNegativeCase(){
        
        Account accountRecord = [select Id from Account where Name='testAccount123' LIMIT 1];
        smsfsc__SessionMUser__c sessionmuser = [select Id from smsfsc__SessionMUser__c where smsfsc__Account__c=:accountRecord.Id];
        Test.startTest();
        List<String> reasonList = new List<String>();
       SessionMCompingWrapperClass smWrapper = SessionMCompController.init(accountRecord.Id);
      
        smsfsc__SessionM_Transaction__c sessionMTransaction = [select Id,smsfsc__ReasonCodes__c,smsfsc__Account__c from smsfsc__SessionM_Transaction__c where smsfsc__Account__c=:accountRecord.Id];
        
        system.debug('list of reasons'+reasonList);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('PointsAPIErrorResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
         SessionMCompingWrapperClass smcompwrapper= new SessionMCompingWrapperClass(accountRecord.Id);
        smcompwrapper.accountId = accountRecord.Id;
        smcompwrapper.transactobj.smsfsc__LoyaltyPoints__c=9;
        smcompwrapper.transactobj.smsfsc__ReasonCodes__c = '';
        string jsonstr = JSON.serialize(smcompwrapper);
        system.debug('json str in debug is '+jsonstr);
        Message msg =  SessionMCompController.computePoints(jsonstr);
                 
        system.debug(msg);
        System.assert(msg!=null);
   
   
    
        Test.stopTest();
          
     
    }
    
    
/**
* @Description This method tests the controller for negative scenario in case if points are not integer values
* @author Manohar Pandurangi
* @date 11-11-2017
*/
    @isTest
    private static void TestNegativeCaseIntegerValidation(){
        
        Account accountRecord = [select Id from Account where Name='testAccount123' LIMIT 1];
        smsfsc__SessionMUser__c sessionmuser = [select Id from smsfsc__SessionMUser__c where smsfsc__Account__c=:accountRecord.Id];
        Test.startTest();
        List<String> reasonList = new List<String>();
       SessionMCompingWrapperClass smWrapper = SessionMCompController.init(accountRecord.Id);
      
        smsfsc__SessionM_Transaction__c sessionMTransaction = [select Id,smsfsc__ReasonCodes__c,smsfsc__Account__c from smsfsc__SessionM_Transaction__c where smsfsc__Account__c=:accountRecord.Id];
        
        system.debug('list of reasons'+reasonList);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('PointsAPIIntegerError');
        mock.setStatusCode(404);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        SessionMCompingWrapperClass smcompwrapper= new SessionMCompingWrapperClass(String.valueOf(accountRecord.Id));
        string jsonstring = '{ "status": "ok", "user": { "id": "9a4ccf04-bff1-11e7-9f1b-c8342c95a502", "available_points": 530, "test_points": 0 } }';
        PointsResponse pointsResponses =new PointsResponse(); 
       PointsResponse parsedjson =  PointsResponse.parse(jsonstring);
        string errorjson = '{ "user": { "id": "9a4ccf04-bff1-11e7-9f1b-c8342c95a502", "available_points": 0, "test_points": 0 }, "status": "error", "errors": { "transaction": { "id": "9a4ccf04-bff1-11e7-9f1b-c8342c95a502", "available_points": 0, "test_points": 0 }, "code": "ok", "message": "Erros" } }';
         PointsResponse parsedjsonerror =  PointsResponse.parse(errorjson);
        String statusss = parsedjsonerror.status;
        System.debug('status issss'+statusss);
         smcompwrapper.accountId = accountRecord.Id;
        smcompwrapper.transactobj.smsfsc__LoyaltyPoints__c=12;
        smcompwrapper.transactobj.smsfsc__ReasonCodes__c = '';
        string jsonstr = JSON.serialize(smcompwrapper);
        system.debug('json str in debug is '+jsonstr);
        Message msg ;
          msg = SessionMCompController.computePoints(jsonstr);
       
        system.debug(msg);
        System.assert(msg!=null);
   
   
    
        Test.stopTest();
          
     
    }
    
    
    
  
}