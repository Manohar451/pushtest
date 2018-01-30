/**
* @Description This is test class for SessionMUpdateController,UpdateRequest,UpdateResponse
* @author Manohar Pandurangi
* @date 18-12-2017
*/

@isTest
public class SessionMUpdateControllerTest {
    
        /**
        * @Description The purpose of this method is to create dummy data for test classes input
        * @author Manohar Pandurangi
        * @date 18-12-2017
        */

        @testSetup 
        public static void setup() {
            
            String name = String.valueOf('\'') +'System Administrator'+ String.valueOf('\'');
            String standardusername = String.valueOf('\'') +'Chatter Only User'+ String.valueOf('\'');
            List<Profile> standardprofileList = Database.query('Select Id,Name from Profile  where Name = '+standardusername);
             

            List<Profile> profileList = Database.query('Select Id,Name from Profile  where Name = '+name);
            
            Profile profile = null;
            if(profileList != null && profileList.size()>0){
                profile = profileList.get(0);
            }
            
            profile standardprofile = null;
            if(standardprofileList != null && standardprofileList.size()>0){
                standardprofile = standardprofileList.get(0);
            }
            
            
            User usr = new User(LastName ='lastName', email='email@email.com', 
                                ProfileId=profile.id  ,Username='john4444444666@acme.com',CommunityNickname='cmn',
                                TimeZoneSidKey='America/Los_Angeles',LocaleSidKey='en_US',Alias='als',
                                EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
            
                User standardusr = new User(LastName ='firstName', email='email@email123.com', 
                                ProfileId=standardprofile.id  ,Username='john44444sdsada44666@acme.com',CommunityNickname='cmbn',
                                TimeZoneSidKey='America/Los_Angeles',LocaleSidKey='en_US',Alias='ales',
                                EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
            insert standardusr; 
            insert usr;
            
            Account account = TestDataFactory.createAccountRecord();  //Creating account records
            insert account;
            
            smsfsc__SMLSettings__c unprotectedSettings =  TestDataFactory.createUnprotectedCustomSettings();//creating unprotected custom settings
            insert unprotectedSettings;
            
            smsfsc__SMPSettings__c protectedSettings =  TestDataFactory.createProtectedCustomSettings();//creating protected custom settings
            insert protectedSettings;
            
            smsfsc__SessionMUser__c sessionMuser = TestDataFactory.getSessionMUserRecord(); //creating SessionM user Records
            insert sessionMuser;
            
            System.assert(account!=null);
            
        
    }
    
    /**
    * @Description The purpose of this method is to test the SessionMUpdateController class when callout is successful and user is updated succesful
    * @author Manohar Pandurangi
    * @date 18-12-2017
    */

   @isTest
    public static  void testController(){
        
        String lastName = String.valueOf('\'') +'lastName'+ String.valueOf('\'');
        List<User> userList = Database.query('Select Id from User where lastName ='+lastName);
        
        
        
        User user = null;
        if(userList != null && userList.size()>0){
            user = userList.get(0);
        }
        
        System.runAs(user){
              
            String name = String.valueOf('\'') +'testAccount123'+ String.valueOf('\'');
            List<Account> accountList = Database.query('SELECT Id FROM Account WHERE Name = '+name);
            
            Account account = null;
            if(accountList != null && accountList.size()>0){
                account= accountList.get(0);
            }
            
            System.assertNotEquals(account,null);
            smsfsc__SessionMUser__c userNew = GeneralUtility.getSessionMUserRecordByAccountId(account.id);
          
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();//Setting static resource as response for mock callouts
            mock.setStaticResource('UpdateResponseJSONPositive');
            mock.setStatusCode(200); 
            mock.setHeader('Content-Type', 'application/json');
            mock.setStatus('OK');
            Test.setMock(HttpCalloutMock.class, mock);

            smsfsc__SessionMUser__c userNew1 = userNew.clone(false,true,false,false);
            userNew1.smsfsc__Account__c= account.id;
            userNew1.smsfsc__Address__c= '1';
            userNew1.smsfsc__City__c= '1';
            userNew1.smsfsc__CustomerCountry__c= '1';
            userNew1.smsfsc__CustomerCurrentCountry__c= '1';
            userNew1.smsfsc__CurrentState__c= '1';
            userNew1.smsfsc__Dma__c= '1';

            
            insert userNew1;

            Test.startTest();
                System.assertNotEquals(SessionMUpdateController.init(account.Id),null);
                System.assertNotEquals(SessionMUpdateController.modifySessionMUser(userNew1.Id),null);
                SessionMUpdateController.cleanUpForUpdateServices(userNew1.Id);
            Test.stopTest();
        }
           
       
    }
        
}