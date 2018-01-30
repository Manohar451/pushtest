/**
* @Description This is test class for SessionMViewController
* @author Manohar Pandurangi
* @date 18-12-2017
*/

@isTest
public class SessionMViewControllerTest {
    
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
    * @Description The purpose of this method is to test the SessionMViewController class when callout is successful
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
        
        //system.debug('profile is '+user.ProfileId);
        
        System.runAs(user){
            
            Test.startTest();
            String json2 = '{"status":"ok","user":{"id":"6a89beac-a0dd-11e4-93f6-ddb808912e2c","external_id":"1284111","email":"john.smith@test.com","identifiers":[{"external_id":"1234abcd","external_id_type":"facebook"}],"first_name":"John","last_name":"Smith","gender":"m","dob":"1980-01-01","account_status":"good","address":"7 Tremont Street","city":"Boston","state":"MA","zip":"02021","country":"USA"}}';
            
            //System.assert(ViewResponse.parse(json2)!=null);//check whether object is null or not
            
            
            smsfsc__SMLSettings__c listCustomSettings =  smsfsc__SMLSettings__c.getInstance('Default');
            String emailId = listCustomSettings.smsfsc__EmailFieldInAccounts__c;
            String json = '{ "SmToSfFieldMappings": { "Mappings": [{ "smApiName": "id", "sfApiName": "SessionMID__c" }, { "smApiName": "external_id", "sfApiName": "ExternalID__c" }, { "smApiName": "available_points", "sfApiName": "AvailablePoints__c" }, { "smApiName": "test_points", "sfApiName": "TestPoints__c" }, { "smApiName": "unclaimed_achievement_count", "sfApiName": "UnclaimedAchievementCount__c" }, { "smApiName": "email", "sfApiName": "Email__c" }, { "smApiName": "external_id", "sfApiName": "ExternalID__c" }, { "smApiName": "gender", "sfApiName": "Gender__c" }, { "smApiName": "dob", "sfApiName": "DateOfBirth__c" }, { "smApiName": "created_at", "sfApiName": "CreatedAt__c" }, { "smApiName": "updated_at", "sfApiName": "UpdatedAt__c" }, { "smApiName": "address", "sfApiName": "Address__c" }, { "smApiName": "city", "sfApiName": "City__c" }, { "smApiName": "zip", "sfApiName": "ZipCode__c" }, { "smApiName": "dma", "sfApiName": "Dma__c" }, { "smApiName": "state", "sfApiName": "State__c" }, { "smApiName": "country", "sfApiName": "Country__c" }, { "smApiName": "suspended", "sfApiName": "Suspended__c" }, { "smApiName": "last_name", "sfApiName": "LastName__c" }, { "smApiName": "first_name", "sfApiName": "FirstName__c" }, { "smApiName": "registered_at", "sfApiName": "RegisteredAt__c" }, { "smApiName": "verification_method", "sfApiName": "VerificationMethod__c" }, { "smApiName": "profile_photo_url", "sfApiName": "ProfilePhotoURL__c" }, { "smApiName": "test_account", "sfApiName": "TestAccount__c" }, { "smApiName": "account_status", "sfApiName": "AccountStatus__c" }, { "smApiName": "current_state", "sfApiName": "CurrentState__c" }, { "smApiName": "current_country", "sfApiName": "CurrentCountry__c" }, { "smApiName": "tier", "sfApiName": "Tier__c" }, { "smApiName": "tier_system", "sfApiName": "TierSystem__c" }, { "smApiName": "next_tier_percentage", "sfApiName": "NextTierPercentage__c" }, { "smApiName": "next_tier_points", "sfApiName": "NextTierPoints__c" }, { "smApiName": "tier_starts_value", "sfApiName": "TierStartsValue__c" }, { "smApiName": "tier_ends_value", "sfApiName": "TierEndsValue__c" }, { "smApiName": "tier_entered_at", "sfApiName": "TierEnteredAt__c" }, { "smApiName": "_version", "sfApiName": "CustomInteger1__c" }, { "smApiName": "external_id", "sfApiName": "ExternalID__c" }, { "smApiName": "birthday", "sfApiName": "CustomDate1__c" }, { "smApiName": "companyName", "sfApiName": "CustomText1__c" }, { "smApiName": "fax", "sfApiName": "CustomText10__c" }, { "smApiName": "firstName", "sfApiName": "CustomText2__c" }, { "smApiName": "jobTitle", "sfApiName": "CustomText4__c" }, { "smApiName": "nextBirthday", "sfApiName": "CustomDate2__c" }, { "smApiName": "phoneBusiness", "sfApiName": "CustomText11__c" }, { "smApiName": "phoneHome", "sfApiName": "CustomText12__c" }, { "smApiName": "phoneMobile", "sfApiName": "CustomText13__c" }, { "smApiName": "salutation", "sfApiName": "CustomText5__c" }, { "smApiName": "secondName", "sfApiName": "CustomText14__c" }, { "smApiName": "suffix", "sfApiName": "CustomText6__c" }, { "smApiName": "email", "sfApiName": "CustomText7__c" }, { "smApiName": "title", "sfApiName": "CustomText8__c" }, { "smApiName": "gender", "sfApiName": "CustomInteger2__c" } ] } }';
            
            SmToSfFieldJsonParser jsonParser = SmToSfFieldJsonParser.parse(json);//Testing the parser class SmToSfFieldJsonParser
            System.assert(jsonParser != null);//check whether object is null or not
            
            
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();//Setting static resource as response for mock callouts
            mock.setStaticResource('GetPositiveResponseJson');
            mock.setStatusCode(200); 
            mock.setHeader('Content-Type', 'application/json');
            mock.setStatus('OK');
            Test.setMock(HttpCalloutMock.class, mock); 
            
            String name = String.valueOf('\'') +'testAccount123'+ String.valueOf('\'');
            List<Account> accountList = Database.query('SELECT Id FROM Account WHERE Name = '+name);
            
            Account objAccount = null;
            if(accountList != null && accountList.size()>0){
                objAccount= accountList.get(0);
            }
            
            System.assertNotEquals(objAccount,null);
            System.assertNotEquals(SessionMViewController.init(objAccount.Id),null);
            
            Test.stopTest();
           
       
        }
        
        
        
        
        
        
    }
    
    
     /**
    * @Description The purpose of this method is to test the SessionMViewController class for negative scenario i.e an error response json is returned
    * @author Manohar Pandurangi
    * @date 18-12-2017
    */
    @isTest
    public static  void testControllerNegative(){
        
            String lastName = String.valueOf('\'') +'lastName'+ String.valueOf('\'');
        List<User> userList = Database.query('Select Id from User where lastName ='+lastName);
        
        User user = null;
        if(userList != null && userList.size()>0){
            user = userList.get(0);
        }
        
        //system.debug('profile is '+user.ProfileId);
        
        System.runAs(user){
            Test.startTest();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();//Setting static resource as response for mock callouts
            mock.setStaticResource('GetNegativeResponseJson');
            mock.setStatusCode(200); 
            mock.setHeader('Content-Type', 'application/json');
            mock.setStatus('error');
            Test.setMock(HttpCalloutMock.class, mock); 
            
            String name = String.valueOf('\'') +'testAccount123'+ String.valueOf('\'');
            List<Account> accountList = Database.query('SELECT Id FROM Account WHERE Name = '+name);
            
            Account objAccount = null;
            if(accountList != null && accountList.size()>0){
                objAccount= accountList.get(0);
            }
            
            System.assertNotEquals(objAccount,null);
            System.assertNotEquals(SessionMViewController.init(objAccount.Id),null);
            
            Test.stopTest();
        
        
    }
    }
    
     /**
    * @Description The purpose of this method is to test the SessionMViewController class for negative scenario i.e when callout return an error json
    * @author Manohar Pandurangi
    * @date 18-12-2017
    */
    @isTest
    public static  void testControllerNegativetemp(){
        
            String lastName = String.valueOf('\'') +'lastName'+ String.valueOf('\'');
        List<User> userList = Database.query('Select Id from User where lastName ='+lastName);
        
        User user = null;
        if(userList != null && userList.size()>0){
            user = userList.get(0);
        }
        
        //system.debug('profile is '+user.ProfileId);
        
        System.runAs(user){
            Test.startTest();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();//Setting static resource as response for mock callouts
            mock.setStaticResource('GetViewResponseMultipleMapping');
            mock.setStatusCode(200); 
            mock.setHeader('Content-Type', 'application/json');
            mock.setStatus('error');
            Test.setMock(HttpCalloutMock.class, mock); 
            
            String name = String.valueOf('\'') +'testAccount123'+ String.valueOf('\'');
            List<Account> accountList = Database.query('SELECT Id FROM Account WHERE Name = '+name);
            
            Account objAccount = null;
            if(accountList != null && accountList.size()>0){
                objAccount= accountList.get(0);
            }
            
            System.assertNotEquals(objAccount,null);
            System.assertNotEquals(SessionMViewController.init(objAccount.Id),null);
            
            Test.stopTest();
        
        
    }
    }
    
    

}