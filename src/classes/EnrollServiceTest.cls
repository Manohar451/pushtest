/**
* @Description EnrollServiceTest is the test class for EnrollService,EnrollRequest,EnrollResponse
* @author Manohar Pandurangi
* @date 11-11-2017
*/

@isTest
private class EnrollServiceTest {
    
     @testSetup static void setupforenroll() {
        
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
    }
    
    
    /**
* @Description This method is used to test the enrollment service in positive scenario or happy path i.e callout is succesful
* @author Manohar Pandurangi
* @date 11-11-2017
*/

    
    @isTest
    static void enrollUserPositiveScenario1(){
        
        String lastName = String.valueOf('\'') +'lastName'+ String.valueOf('\'');
        List<User> userList = Database.query('Select Id from User where lastName ='+lastName);
        
        User user = null;
        if(userList != null && userList.size()>0){
            user = userList.get(0);
        }
        
        System.runAs(user){
            
            Test.startTest();
            
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();//Setting static resource as response for mock callouts
            
            mock.setStaticResource('EnrollPositiveResponseJson');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            mock.setStatus('OK');
            
            // Associate the callout with a mock response
            Test.setMock(HttpCalloutMock.class, mock);
            
            String name = String.valueOf('\'') +'testAccount123'+ String.valueOf('\'');
            List<Account> accountList = Database.query('SELECT Id FROM Account WHERE Name = '+name);
           
            Account account = null;
            if(accountList != null && accountList.size()>0){
                account= accountList.get(0);
            }
            
            System.assertNotEquals(account,null);
            
            EnrollRequest enrollRequest = new  EnrollRequest(String.ValueOf(account.id), 'aba@aba.com', null, null,
                                                      null, null, null, null, null, null);
                                                      
            String jsonBody = json.serialize(enrollRequest);
            EnrollResponse enrolresp = new EnrollResponse();
            string response = '{ "status":"ok", "user":{ "id":"6a89beac-a0dd-11e4-93f6-ddb808912e2c", "external_id":"1284111", "email":"john.smith@test.com", "identifiers":[ { "external_id":"1234abcd", "external_id_type":"facebook" } ], "first_name":"John", "last_name":"Smith", "gender":"m", "dob":"1980-01-01", "account_status":"good", "address":"7 Tremont Street", "city":"Boston", "state":"MA", "zip":"02021", "country":"USA" } }';
            
            APIResult apiRes = EnrollService.enrollUser(jsonBody, account.id);
            //APIResult displayresponseFormat = EnrollService.displayresponseFormat(null, enrolresp, true);
            
            Test.stopTest();
        }
    }
    
    
/**
* @Description This method tests the enroll service for negative cases when callout returns an error json
* @author Manohar Pandurangi
* @date 11-11-2017
*/

    
    @isTest
    static void enrollUserNegativeScenarioErrorJson(){
        
        String lastName = String.valueOf('\'') +'lastName'+ String.valueOf('\'');
        List<User> userList = Database.query('Select Id from User where lastName ='+lastName);
        
        User user = null;
        if(userList != null && userList.size()>0){
            user = userList.get(0);
        }
        
        System.runAs(user){
                
            Test.startTest();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();//Setting static resource as response for mock callouts
            mock.setStaticResource('EnrollNegativeResponseJson');
            mock.setStatusCode(400);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            mock.setStatus('ERROR');
            
            // Associate the callout with a mock response
            Test.setMock(HttpCalloutMock.class, mock);
            String name = String.valueOf('\'') +'testAccount123'+ String.valueOf('\'');
            List<Account> accountList = Database.query('SELECT Id FROM Account WHERE Name = '+name);
            
            Account account = null;
            if(accountList != null && accountList.size()>0){
                account= accountList.get(0);
            }
            
            System.assertNotEquals(account,null);
            
            EnrollRequest enrollRequst = new  EnrollRequest(String.ValueOf(account.id), 'aba@adfa.com', null, 
                                                            null, null, null, null, null, null, null);
            String jsonBody = json.serialize(enrollRequst);
            APIResult apiRes = EnrollService.enrollUser(jsonBody, account.id);
            Test.stopTest();
        }
    }
}