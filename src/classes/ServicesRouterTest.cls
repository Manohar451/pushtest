/**
* @Description ServicesRouterTest is used for ServicesRouter
* @author Manohar Pandurangi
* @date 11-11-2017
*/

@isTest
public with sharing class ServicesRouterTest {
    
    /**
* @Description Creating dummy data for test class
* @author Manohar Pandurnagi
* @date 11-11-2107
*/

   
    @testSetup 
    static void setup() {

        smsfsc__SMLSettings__c listCustomSettings =  TestDataFactory.createunprotectedcustomsettings();
        smsfsc__SMPSettings__c protectedCustomSettings =  TestDataFactory.createprotectedcustomsettings();
        insert listCustomSettings;
        insert protectedCustomSettings;
        
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
        
        Account account = TestDataFactory.createAccountRecord();
        insert account;
       
        smsfsc__SessionMUser__c smUser = TestDataFactory.getSessionMUserRecord();
        insert smUser;
        
        System.assert(account!=null);
        
        
    }
    
    /**
* @Description services router positive scenario of viewService where callout is succesfully performed
* @author Manohar Pandurangi
* @date 11-11-2017
*/

    
    @isTest
    public static  void ViewServices(){
        
        String lastName = String.valueOf('\'') +'lastName'+ String.valueOf('\'');
        List<User> userList = Database.query('Select Id from User where lastName ='+lastName);
        
        User user = null;
        if(userList != null && userList.size()>0){
            user = userList.get(0);
        }
        
        System.runAs(user){

            SettingsUtilityWrapper objSettingsUtilityWrapper = new SettingsUtilityWrapper();

            ServicesRouter.configureSettings(objSettingsUtilityWrapper);
            ServicesRouter.validateAppSettings(objSettingsUtilityWrapper);

            Test.startTest();  
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
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
        
            Message msg = ServicesRouter.getSessionMUser(account.id);//Testing method for getSessionMuser in services router
            
            system.assertNotEquals(msg,null);
            Test.stopTest();
        }
        
    }
    
    /**
* @Description This is test class for enroll services when callout is succesful
* @author Manohar Pandurangi
* @date 11-11-2017
*/

    
     @isTest
    public static  void EnrollServices()
    {
        
        String lastName = String.valueOf('\'') +'lastName'+ String.valueOf('\'');
        List<User> userList = Database.query('Select Id from User where lastName ='+lastName);
        
        User user = null;
        if(userList != null && userList.size()>0){
            user = userList.get(0);
        }
        
        System.runAs(user){
            Test.startTest();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
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
            
            smsfsc__SMLSettings__c customSetting =  smsfsc__SMLSettings__c.getInstance('Default');
            String emailId = customSetting.smsfsc__EmailFieldInAccounts__c;
           
            EnrollRequest enwrap = new EnrollRequest(String.ValueOf(account.id),emailId,null,null,null,null,null,null,null,null);
            string jsonbody = json.serialize(enwrap);
            System.debug('jsonbodyhereinservices'+jsonbody);
            
            APIResult api = ServicesRouter.enrollUser(jsonBody, account.id);//testingt enrollmethod of servicesrouter
            Message message = new Message('SUCCESS','200','User Enrolled Succesfully');
            List<Message> listMsg = new List<Message>();
            listMsg.add(message);
            APIResult api2 = new APIResult(true,listMsg);
            
            system.assertEquals(api2.isSuccess, api.isSuccess);
            Test.stopTest();
        }
    }
    
    
    /**
* @Description negative scenario test for viewservice of servicesrouter when error response is received from SessionM
* @author Manohar Pandurnagi
* @date 11-11-2017
*/

   
   @isTest
    public static  void ViewServicesnegative(){
        
        String lastName = String.valueOf('\'') +'lastName'+ String.valueOf('\'');
        List<User> userList = Database.query('Select Id from User where lastName ='+lastName);
        
        User user = null;
        if(userList != null && userList.size()>0){
            user = userList.get(0);
        }
        
        System.runAs(user){
            Test.startTest();
                
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('GetNegativeResponseJson');
            mock.setStatusCode(400);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            mock.setStatus('OK');
          
            Test.setMock(HttpCalloutMock.class, mock);    
            
           
            Account account = null;
            String name = String.valueOf('\'') +'testAccount123'+ String.valueOf('\'');
            List<Account> accountList = Database.query('SELECT Id FROM Account WHERE Name = '+name);
            if(accountList != null && accountList.size()>0){
                account= accountList.get(0);
            }
            
            System.assertNotEquals(account,null);
            
         
            Message msg  = ServicesRouter.getSessionMUser(account.id);///testing getSessionMUser(id) of servicesrouter
        
            Test.stopTest();
        }
    }
    
    /**
* @Description negative case scenario of enroll service in service router when error response is received from SessionM
* @author Manohar Pandurangi
* @date 11-11-2017
*/

    
   
      @isTest
     public static  void EnrollServicesNegative(){
        String lastName = String.valueOf('\'') +'lastName'+ String.valueOf('\'');
        List<User> userList = Database.query('Select Id from User where lastName ='+lastName);
        
        User user = null;
        if(userList != null && userList.size()>0){
            user = userList.get(0);
        }
        
        System.runAs(user){
            Test.startTest();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('EnrollNegativeResponseJson');
            mock.setStatusCode(400);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            mock.setStatus('error');
            Test.setMock(HttpCalloutMock.class, mock);  
          
          
            Account account = null;
            String name = String.valueOf('\'') +'testAccount123'+ String.valueOf('\'');
            List<Account> accountList = Database.query('SELECT Id FROM Account WHERE Name = '+name);
            if(accountList != null && accountList.size()>0){
                account= accountList.get(0);
            }
            
            System.assertNotEquals(account,null);
            
            smsfsc__SMLSettings__c listCustomSettings =  smsfsc__SMLSettings__c.getInstance('Default');
            String emailId = listCustomSettings.smsfsc__EmailFieldInAccounts__c;
           
            EnrollRequest enwrap = new EnrollRequest(String.ValueOf(account.id),emailId,null,null,null,null,null,null,null,null);
            string jsonbody = json.serialize(enwrap);
            System.debug('jsonbodyhereinservices'+jsonbody);
           
           
            APIResult api = ServicesRouter.enrollUser(jsonBody, account.id);//calling enrollUser(jsonBody, id) of ServicesRouter
            SettingsUtilityWrapper obj = new SettingsUtilityWrapper();
            ServicesRouter.configureSettings(obj);
            Message msg = new Message('FAILURE','400','User Enrollment Failure : external id in use');
            List<Message> listMsg = new List<Message>();
            listMsg.add(msg);
            APIResult api2 = new APIResult(true,listMsg);
//            system.assertEquals(api2.isSuccess, api.isSuccess);
            Test.stopTest();
        }
        
    }
    
    

    
    
}