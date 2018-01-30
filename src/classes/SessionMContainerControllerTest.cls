/**
* @Description This is test class for SessionMContainerController
* @author Manohar Pandurangi
* @date 18-12-2017
*/

@isTest
public class SessionMContainerControllerTest {
    
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
            
            Account negAcc = TestDataFactory.createAccountRecordNegative();
            insert negAcc;
            
            smsfsc__SMLSettings__c unprotectedSettings =  TestDataFactory.createUnprotectedCustomSettings();//creating unprotected custom settings
            insert unprotectedSettings;
            
            smsfsc__SMPSettings__c protectedSettings =  TestDataFactory.createProtectedCustomSettings();//creating protected custom settings
            insert protectedSettings;
            
            smsfsc__SessionMUser__c sessionMuser = TestDataFactory.getSessionMUserRecord(); //creating SessionM user Records
            insert sessionMuser;
            
            System.assert(account!=null);
            
        
    }
    
    /**
    * @Description The purpose of this method is to test the SessionMContainerController class
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
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SessionMViewResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
            
            Test.startTest();
            String name = String.valueOf('\'') +'testAccount123'+ String.valueOf('\'');
            String name2 = String.valueOf('\'') +'testAccount123NN'+ String.valueOf('\'');
            List<Account> accountList1 = Database.query('SELECT Id FROM Account WHERE Name = '+name2);
            
            
            Account objAccount1 = null;
            if(accountList1 != null && accountList1.size()>0){
                objAccount1= accountList1.get(0);
            }
            List<Account> accountList = Database.query('SELECT Id FROM Account WHERE Name = '+name);
            
            
            Account objAccount = null;
            if(accountList != null && accountList.size()>0){
                objAccount= accountList.get(0);
            }
                        smsfsc__SessionMUser__c testSessionMUser = GeneralUtility.getSessionMUserRecordByAccountId(objAccount.id);

            Boolean isduplicateRecord = SessionMContainerController.isDuplicateRecordDeleted(objAccount.Id);
            Boolean isEnrolledRecordCreated = SessionMContainerController.isEnrolledRecordCreated(objAccount.Id);
           Boolean isEnrolledRecordCreatede = SessionMContainerController.isEnrolledRecordCreated(objAccount1.Id);

            
            System.assertNotEquals(objAccount,null);
            System.assertNotEquals(SessionMContainerController.init(objAccount.Id),null);
            AggregateResult aggregateResult = SessionMContainerController.checkTransactionCount(testSessionMUser.Id);
            
            Test.stopTest();
           
       
        }
        
        
        
    }
    
    
     
    /**
    * @Description The purpose of this method is to test the SessionMContainerController class for negative scenario
    * @author Manohar Pandurangi
    * @date 18-12-2017
    */
     @isTest
    public static  void testControllernegative(){
       String lastName = String.valueOf('\'') +'lastName'+ String.valueOf('\'');
        List<User> userList = Database.query('Select Id from User where lastName ='+lastName);
        
        User user = null;
        if(userList != null && userList.size()>0){
            user = userList.get(0);
        }
        
        System.runAs(user){
            
            Test.startTest();
            String name = String.valueOf('\'') +'testAccount123'+ String.valueOf('\'');
            List<Account> accountList = Database.query('SELECT Id FROM Account WHERE Name = '+name);
            
            Account objAccount = null;
            if(accountList != null && accountList.size()>0){
                objAccount= accountList.get(0);
            }
                        
                       
                     smsfsc__SessionMUser__c testSessionMUser = GeneralUtility.getSessionMUserRecordByAccountId(objAccount.id);
             Boolean isduplicateRecord = SessionMContainerController.isDuplicateRecordDeleted(testSessionMUser.Id);

            System.assertNotEquals(objAccount,null);
            
            Test.stopTest();
           
       
        }
        
    }
    
    /**
    * @Description The purpose of this method is to test the SessionMContainerController class for negative scenario
    * @author Saptsawa
    * @date 03-01-2018
    */
    @isTest
    public static  void testControllertempNegative(){
       String lastName = String.valueOf('\'') +'lastName'+ String.valueOf('\'');
        List<User> userList = Database.query('Select Id from User where lastName ='+lastName);
        
        User user = null;
        if(userList != null && userList.size()>0){
            user = userList.get(0);
        }
        
        System.runAs(user){
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetViewResponseMultipleMapping');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
            
            Test.startTest();
            String name = String.valueOf('\'') +'testAccount123'+ String.valueOf('\'');
            String name2 = String.valueOf('\'') +'testAccount123NN'+ String.valueOf('\'');
            List<Account> accountList1 = Database.query('SELECT Id FROM Account WHERE Name = '+name2);
            
            
            Account objAccount1 = null;
            if(accountList1 != null && accountList1.size()>0){
                objAccount1= accountList1.get(0);
            }
            List<Account> accountList = Database.query('SELECT Id FROM Account WHERE Name = '+name);
            
            
            Account objAccount = null;
            if(accountList != null && accountList.size()>0){
                objAccount= accountList.get(0);
            }
                        smsfsc__SessionMUser__c testSessionMUser = GeneralUtility.getSessionMUserRecordByAccountId(objAccount.id);

            Boolean isduplicateRecord = SessionMContainerController.isDuplicateRecordDeleted(objAccount.Id);
            Boolean isEnrolledRecordCreated = SessionMContainerController.isEnrolledRecordCreated(objAccount.Id);
           Boolean isEnrolledRecordCreatede = SessionMContainerController.isEnrolledRecordCreated(objAccount1.Id);

            
            System.assertNotEquals(objAccount,null); 
            System.assertNotEquals(SessionMContainerController.init(objAccount.Id),null);
            smsfsc__SessionMUser__c testSessionMUser2 = GeneralUtility.getSessionMUserRecordByAccountId(objAccount.id);
			
            system.debug('Updated SM User record : '+testSessionMUser2.smsfsc__CustomerGender__c+' '+testSessionMUser2.smsfsc__CustomText15__c+' '
			+testSessionMUser2.smsfsc__CustomInteger2__c+' '+testSessionMUser2.smsfsc__CustomInteger4__c);
			
            AggregateResult aggregateResult = SessionMContainerController.checkTransactionCount(testSessionMUser.Id);
            
            Test.stopTest();
           
       
        }
        
    }
}