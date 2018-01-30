/**
* @Description This is test class for GeneralUtility class
* @author Manohar Pandurangi
* @date 11-11-2017
*/

@isTest
public with sharing class GeneralUtilityTest {
    
/**
* @Description The purpose of this method is to create dummy data for test classes input
* @author Manohar Pandurangi
* @date 11-11-2017
*/

    @testSetup static void setup() {
        
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
* @Description The purpose of this method is to test the post callout to API endpoint Positive Scenario
* @author Manohar Pandurangi
* @date 11-11-2017
*/

    public static void PostTEST()
    {
        String lastName = String.valueOf('\'') +'lastName'+ String.valueOf('\'');
        List<User> userList = Database.query('Select Id from User where lastName ='+lastName);
        
        User user = null;
        if(userList != null && userList.size()>0){
            user = userList.get(0);
        }
        
        System.runAs(user){
        
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();//Setting static resource as response for mock callouts
            mock.setStaticResource('EnrollPositiveResponse2Json');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            mock.setStatus('OK');
            // Associate the callout with a mock response
            Test.setMock(HttpCalloutMock.class, mock);
            
            
            Account account = null;
            String name = String.valueOf('\'') +'testAccount123'+ String.valueOf('\'');
            List<Account> accountList = Database.query('SELECT Id FROM Account WHERE Name = '+name);
            if(accountList != null && accountList.size()>0){
                account= accountList.get(0);
            }
            
            System.assertNotEquals(account,null);
            
            smsfsc__SMLSettings__c listCustomSettings =  smsfsc__SMLSettings__c.getInstance('Default');
            smsfsc__SMPSettings__c protectedCustomSettings =  smsfsc__SMPSettings__c.getInstance('Default');
            String emailId = listCustomSettings.smsfsc__EmailFieldInAccounts__c;
        
            EnrollRequest enwrap = new EnrollRequest(String.ValueOf(account.id),'aa@adf.com',null,null,null,null,null,null,null,null);//This method is to serialize the values to json
            String jsonbody = json.serialize(enwrap);//Create JsonBody 
            String endPointUrl = protectedCustomSettings.smsfsc__APIEndpoint__c;
            String body =jsonbody;
            String apiSecret = protectedCustomSettings.smsfsc__APISecret__c;
            String apikey = protectedCustomSettings.smsfsc__APIKey__c;
            String apiversion=protectedCustomSettings.smsfsc__APIVersion__c;
          
            System.assertNotEquals(apiversion,null);
        }
    }
    
    
    
    
    /**
* @Description The purpose of this method is to test the GEt callout from API endpoint Positive Scenario
* @author Manohar Pandurangi
* @date 11-11-2017
*/
    public static void GETTEST()
    {
        
        String lastName = String.valueOf('\'') +'lastName'+ String.valueOf('\'');
        List<User> userList = Database.query('Select Id from User where lastName ='+lastName);
        
        User user = null;
        if(userList != null && userList.size()>0){
            user = userList.get(0);
        }
        
        System.runAs(user){
        
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();//Setting static resource as response for mock callouts
            mock.setStaticResource('GetPositiveResponseJson');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            mock.setStatus('OK');
            // Associate the callout with a mock response
            Test.setMock(HttpCalloutMock.class, mock);     
                
            Account account = null;
            String name = String.valueOf('\'') +'testAccount123'+ String.valueOf('\'');
            List<Account> accountList = Database.query('SELECT Id FROM Account WHERE Name = '+name);
            if(accountList != null && accountList.size()>0){
                account= accountList.get(0);
            }
            System.assertNotEquals(account,null);
            
            smsfsc__SMLSettings__c listCustomSettings =  smsfsc__SMLSettings__c.getInstance('Default');
            smsfsc__SMPSettings__c protectedCustomSettings =  smsfsc__SMPSettings__c.getInstance('Default');
            
            String emailId = listCustomSettings.smsfsc__EmailFieldInAccounts__c;
            String endPointUrl = protectedCustomSettings.smsfsc__APIEndpoint__c;
            String apiSecret = protectedCustomSettings.smsfsc__APISecret__c;
            String apikey = protectedCustomSettings.smsfsc__APIKey__c;
            String apiversion=protectedCustomSettings.smsfsc__APIVersion__c;
            ReasonCodeResponse fetchReasonCodePickListValues = GeneralUtility.fetchReasonCodePickListValues();
            GeneralUtility.getMapforReasonCodes();
            smsfsc__SessionM_Json_Mappings__mdt  getJsonMappingCustomMetadataTypes = GeneralUtility.getJsonMappingCustomMetadataTypes('smsfsc__SessionM_to_Salesforce_API_Mapping');
        
            
            System.assertNotEquals(apiversion,null);
        }
        
    }
    
     /**
* @Description The purpose of this method is to test the post callout to API endpoint Negative Scenario
* @author Manohar Pandurangi
* @date 11-11-2017
*/

   
   
    public static void PostTESTNegative()
    {
        
         String lastName = String.valueOf('\'') +'lastName'+ String.valueOf('\'');
        List<User> userList = Database.query('Select Id from User where lastName ='+lastName);
        
        User user = null;
        if(userList != null && userList.size()>0){
            user = userList.get(0);
        }
        
        System.runAs(user){
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();//Setting static resource as response for mock callouts
            mock.setStaticResource('EnrollNegativeResponseJson');
            mock.setStatusCode(400);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            mock.setStatus('error');
            Test.setMock(HttpCalloutMock.class, mock);        
            
            Account account = null;
            String name = String.valueOf('\'') +'testAccount123'+ String.valueOf('\'');
            List<Account> accountList = Database.query('SELECT Id,Name FROM Account WHERE Name = '+name);
            if(accountList != null && accountList.size()>0){
                account= accountList.get(0);
            }
                
            System.assertNotEquals(account,null);
            smsfsc__SMLSettings__c listCustomSettings =  smsfsc__SMLSettings__c.getInstance('Default');
            smsfsc__SMPSettings__c protectedCustomSettings =  smsfsc__SMPSettings__c.getInstance('Default');
            String emailId = listCustomSettings.smsfsc__EmailFieldInAccounts__c;
            Account testAccountrecord = GeneralUtility.getAccountRecord(account.id);
            smsfsc__SessionMUser__c testSessionMUser = GeneralUtility.getSessionMUserRecordByAccountId(account.id);
            Account testAccountrecord1 = GeneralUtility.getAccountRecordWithEmail(account.Id, emailId);
            
            EnrollRequest enwrap = new EnrollRequest(String.ValueOf(account.id),'aaa@aaaa.com',null,null,null,null,null,null,null,null);
            String jsonbody = json.serialize(enwrap);//Serialize and create json body
            System.debug('jsonbodyhereinservices'+jsonbody);
            String endPointUrl = protectedCustomSettings.smsfsc__APIEndpoint__c;
            
            String body =jsonbody;
            String apiSecret = protectedCustomSettings.smsfsc__APISecret__c;
            String apikey = protectedCustomSettings.smsfsc__APIKey__c;
            String apiversion=protectedCustomSettings.smsfsc__APIVersion__c;
         
            System.assertNotEquals(apiversion,null);
        }
    }
    
    /**
* @Description The purpose of this method is to test the GEt callout to API endpoint Negative Scenario
* @author Manohar Pandurangi
* @date 11-11-2017
*/
    public static void GETTESTNegative()
    {
        String lastName = String.valueOf('\'') +'lastName'+ String.valueOf('\'');
        List<User> userList = Database.query('Select Id from User where lastName ='+lastName);
        
        User user = null;
        if(userList != null && userList.size()>0){
            user = userList.get(0);
        }
        
        System.runAs(user){

            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();//Setting static resource as response for mock callouts
            mock.setStaticResource('GetNegativeResponseJson');
            mock.setStatusCode(400);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            mock.setStatus('OK');
            // Associate the callout with a mock response
            Test.setMock(HttpCalloutMock.class, mock);         
            Account account = null;
            String name = String.valueOf('\'') +'testAccount123'+ String.valueOf('\'');
            List<Account> accountList = Database.query('SELECT Id FROM Account WHERE Name = '+name);
            if(accountList != null && accountList.size()>0){
                account= accountList.get(0);
            }
                
            System.assertNotEquals(account,null);
            
            smsfsc__SMLSettings__c listCustomSettings =  smsfsc__SMLSettings__c.getInstance('Default');
            smsfsc__SMPSettings__c protectedCustomSettings =  smsfsc__SMPSettings__c.getInstance('Default');
            
            String emailId = listCustomSettings.smsfsc__EmailFieldInAccounts__c;
            String endPointUrl = protectedCustomSettings.smsfsc__APIEndpoint__c;
            String apiSecret = protectedCustomSettings.smsfsc__APISecret__c;
            String apikey = protectedCustomSettings.smsfsc__APIKey__c;
            String apiversion=protectedCustomSettings.smsfsc__APIVersion__c;
            
         
           
            System.assertNotEquals(apiversion,null);
        }
        
       
        
        
    }
   
    /**
* @Description The purpose of this method is to call all the test methods above
* @author Manohar Pandurangi
* @date 11-11-2017
*/

     @isTest
    public static void callingmethods()
    {
        String lastName = String.valueOf('\'') +'lastName'+ String.valueOf('\'');
        List<User> userList = Database.query('Select Id from User where lastName ='+lastName);
        
        User user = null;
        if(userList != null && userList.size()>0){
            user = userList.get(0);
        }
        
        System.runAs(user){
        
            Test.startTest();
            PostTEST();
            GETTEST();
            PostTESTNegative();
            GETTESTNegative();
            
            Account account = null;
            String name = String.valueOf('\'') +'testAccount123'+ String.valueOf('\'');
            List<Account> accountList = Database.query('SELECT Id FROM Account WHERE Name = '+name);
            if(accountList != null && accountList.size()>0){
                account= accountList.get(0);
            }
                
            System.assertNotEquals(account,null);
                
            System.assertNotEquals(account,null);
            
            EnrollRequest enwrap = new EnrollRequest(account.id,'manohar451@gmail.com',null, null, null, null, null, null, null, null);
            String Str = EnrollRequest.serializeEnrollRequest(enwrap);
            String Actual = GeneralUtility.queryBuilder('smsfsc__SessionMUser__c');//Query builder method of generalutility class
            System.assertNotEquals(Str,null);
            Test.stopTest();
        }
        
        
    }
    
    
}