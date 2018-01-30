/**
* @Description This is test class for enroll user ,UpdateComponentController,conatinercontroller
* @author Manohar Pandurangi
* @date 07-11-2017
*/

@isTest
private class ViewUserTest {
    
    /** 
* @Description The purpose of this method is to create dummy data for test classes input
* @author Manohar Pandurangi
* @date 11-11-2017
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
* @Description This is testmethod for UpdateServices class 
* @author Manohar
* @date 11-11-2017
*/
    @isTest
    private static void UpdateUserTest1()
    {
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
            
            
            
            
            smsfsc__SessionMUser__c smu = ServicesRouter.fetchSessionMUserRecord(account.id);
            
            smu.smsfsc__Address__c= '2';
            smu.smsfsc__City__c= '2';
            smu.smsfsc__CurrentState__c= '2';
            smu.smsfsc__FirstName__c = 'kk';
            smu.smsfsc__LastName__c = 'klk';
            smu.smsfsc__CustomerGender__c = 'Male';
            
            smu.smsfsc__Dma__c= '12';
            update smu;
            
            Test.startTest();
            ServicesRouter.modifySessionMUser(smu.id);
            
            smu = GeneralUtility.getSessionMUserRecordByAccountId(account.id);
            
            smsfsc__SessionMUser__c smu1 = smu.clone(false,true,false,false);
            smu1.smsfsc__SessionMUserParent__c  = smu.id; 
            smu1.smsfsc__Account__c = smu.smsfsc__Account__c;
            insert smu1;
            
            
            List<smsfsc__SessionMUser__c> smfl = [Select Id from smsfsc__SessionMUser__c where smsfsc__Account__c = :account.id ];
            
            smu  = UpdateServices.fetchSessionMUserRecord(account.id);
            
            smu.smsfsc__Email__c = 'a@a.a';
            
            ServicesRouter.modifySessionMUser(smu.id);
            
            
            UpdateRequest ur = new UpdateRequest();
            UpdateRequest.UpdateUserRequest uur = new UpdateRequest.UpdateUserRequest();
            uur.external_id= '1';  //1284111
            uur.external_id= '1';  //1284111
            uur.id= '1';  
            uur.email= '1';  //john.smith@test.com
            uur.first_name= '1';  //John
            uur.last_name= '1';  //Smith
            uur.gender= '1';  //m
            
            uur.city= '1';  //Boston
            uur.state= '1';  //MA
            uur.zip= '1';  //02021
            uur.country= '1';  //USA
            uur.available_points= '1';
            uur.test_points= '1';
            uur.unclaimed_achievement_count= '1';
            
            uur.address= '1';
            uur.dma= '1';
            uur.suspended= '1';
            uur.registered_at= '1';
            uur.verification_method= '1';
            
            uur.test_account= '1';
            
            uur.tier= '1';
            uur.tier_system= '1';
            uur.next_tier_percentage= '1';
            uur.next_tier_points= '1';
            uur.tier_starts_value= '1';
            uur.tier_ends_value= '1';
            uur.tier_entered_at= '1';
            uur.account_status= '1';
            
            UpdateRequest.serializeEnrollRequest(ur);
            
            
            Test.stopTest();
        }
        
    }
    
}