/**
* @Description This is test class for SessionMAppSettingsController classes covered are SessionMAppSettingsController
* @author Manohar Pandurangi
* @date 11-11-2017
*/



@isTest
private  class SessionMAppSettingsControllerTest {

  /**
* @Description This method tests for the positive cases i.e when all data validations are passed
* @author Manohar Pandurangi
* @date 11-11-2017 
*/

    
     @isTest 
    private static void testcontroller() {
        
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
        
        
        System.runAs(usr){
            
            smsfsc__SMLSettings__c listCustomSettings =  TestDataFactory.createUnprotectedCustomSettings();
            insert listCustomSettings;
            
            smsfsc__SMPSettings__c protectedCustomSettings =  TestDataFactory.createProtectedCustomSettings();//creating records of smp
            insert protectedCustomSettings;
           
            SettingsUtilityWrapper wrapper = SessionMAppSettingsController.init();
            Message msg = SessionMAppSettingsController.validateAndSave('{"islistCustomSettingsUpdateable":true,"isprotectedCustomSettingsUpdateable":true,"listCustomSettings":{"Name":"test","smsfsc__EmailFieldInAccounts__c":"smsfsc__Email_to_Enroll__c","smsfsc__EnableEnrollInCommunity__c":false,"smsfsc__PageSize__c":12,"smsfsc__SessionMtoSalesforceMappingsAPIName__c":"smsfsc__SessionM_to_Salesforce_API_Mapping"},"listCustomSettingsExist":false,"msg":{"experienceType":"CLASSIC","msgCode":"","msgText":"Min value for page Size is 1 and max value is 50","msgType":"error"},"protectedCustomSettings":{"Name":"test","smsfsc__APIEndpoint__c":"https://sessionmpkg1-dev-ed.lightning.force.com","smsfsc__APIKey__c":"test","smsfsc__APISecret__c":"test","smsfsc__APIVersion__c":"2"},"protectedCustomSettingsExist":false}');
            System.assert(wrapper!=null);
        
            
         }
    }
   
    /**
* @Description The purpose of this method is to test the SessionM controller class in negative scenario where records are not saved succesfully
* @author Manohar Pandurangi
* @date 11-11-2017
*/
    @isTest
    public static void testcontrollernegative()
    {
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
        
        System.runAs(usr){
        
             Message msg = SessionMAppSettingsController.validateAndSave('{"islistCustomSettingsUpdateable":true,"isprotectedCustomSettingsUpdateable":true,"listCustomSettings":{"Name":"test","smsfsc__EmailFieldInAccounts__c":"smsfsc__Emaill_to_Enrolll__c","smsfsc__EnableEnrollInCommunity__c":false,"smsfsc__PageSize__c":12,"smsfsc__SessionMtoSalesforceMappingsAPIName__c":"smsfsc__SessionM_to_Salesforce_API_Mapping"},"listCustomSettingsExist":false,"msg":{"experienceType":"CLASSIC","msgCode":"","msgText":"Min value for page Size is 1 and max value is 50","msgType":"error"},"protectedCustomSettings":{"Name":"test","smsfsc__APIEndpoint__c":"https://sessionmpkg1-dev-ed.lightning.force.com","smsfsc__APIKey__c":"test","smsfsc__APISecret__c":"test","smsfsc__APIVersion__c":"2"},"protectedCustomSettingsExist":false}');
             SettingsUtilityWrapper smwrapper = SessionMAppSettingsController.init();
             System.assert(msg!=null);
        }
        
    }
    
     
    /**
* @Description The purpose of this method is to test the SessionM controller class in negative scenario i.e list custom settings dont exist
* @author Manohar pandurangi
* @date 11-11-2017
*/
  @isTest
    public static void testcontrollernegativecase2()
    {
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
        
        System.runAs(usr){
        
             Message msg = SessionMAppSettingsController.validateAndSave('{"islistCustomSettingsUpdateable":true,"isprotectedCustomSettingsUpdateable":true,"listCustomSettings":{"Name":"test","smsfsc__EmailFieldInAccounts__c":"Name","smsfsc__EnableEnrollInCommunity__c":false,"smsfsc__PageSize__c":12,"smsfsc__SessionMtoSalesforceMappingsAPIName__c":"smsfsc__SessionM_to_Salesforce_API_Mapping"},"listCustomSettingsExist":false,"msg":{"experienceType":"CLASSIC","msgCode":"","msgText":"Min value for page Size is 1 and max value is 50","msgType":"error"},"protectedCustomSettings":{"Name":"test","smsfsc__APIEndpoint__c":"https://sessionmpkg1-dev-ed.lightning.force.com","smsfsc__APIKey__c":"test","smsfsc__APISecret__c":"test","smsfsc__APIVersion__c":"2"},"protectedCustomSettingsExist":false}');

             System.assert(msg!=null);
        }
        
    }
    
    
   
    /**
* @Description The purpose of this method is to test the SessionM controller class in negative scenario i.e when protected settings doesnt exist
* @author Manohar Pandurangi
* @date 11-11-2017
*/
    @isTest
    public static void testcontrollernegative2()
    {
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
        
        System.runAs(usr){
        
             Message msg = SessionMAppSettingsController.validateAndSave('{"islistCustomSettingsUpdateable":true,"isprotectedCustomSettingsUpdateable":true,"listCustomSettings":{"Name":"test","smsfsc__EmailFieldInAccounts__c":"smsfsc__Emaill_to_Enrolll__c","smsfsc__EnableEnrollInCommunity__c":false,"smsfsc__PageSize__c":12,"smsfsc__SessionMtoSalesforceMappingsAPIName__c":"smsfsc__SessionM_to_Salesfoorce_API_Mapping"},"listCustomSettingsExist":false,"msg":{"experienceType":"CLASSIC","msgCode":"","msgText":"Min value for page Size is 1 and max value is 50","msgType":"error"},"protectedCustomSettings":{"Name":"test","smsfsc__APIEndpoint__c":"https://sessionmpkg1-dev-ed.lightning.force.com","smsfsc__APIKey__c":"test","smsfsc__APISecret__c":"test","smsfsc__APIVersion__c":"2"},"protectedCustomSettingsExist":false}');

             System.assert(msg!=null);
        }
        
    }
    
    
      
/**
* @Description The purpose of this method is to test the SessionM controller class in negative scenario where page size exceeds its limit
* @author Manohar Pandurangi
* @date 11-11-2017
*/
    @isTest
     public static void testcontrollernegative3()
    {
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
        
        System.runAs(usr){
        
             Message msg = SessionMAppSettingsController.validateAndSave('{"islistCustomSettingsUpdateable":true,"isprotectedCustomSettingsUpdateable":true,"listCustomSettings":{"Name":"test","smsfsc__EmailFieldInAccounts__c":"smsfsc__Emaill_to_Enrolll__c","smsfsc__EnableEnrollInCommunity__c":false,"smsfsc__PageSize__c":12,"smsfsc__SessionMtoSalesforceMappingsAPIName__c":"smsfsc__SessionM_to_Salesfoorce_API_Mapping"},"listCustomSettingsExist":false,"msg":{"experienceType":"CLASSIC","msgCode":"","msgText":"Min value for page Size is 1 and max value is 50","msgType":"error"},"protectedCustomSettings":{"Name":"test","smsfsc__APIEndpoint__c":"https://sessionmpkg1-dev-ed.lightning.force.com","smsfsc__APIKey__c":"test","smsfsc__APISecret__c":"test","smsfsc__APIVersion__c":"2"},"protectedCustomSettingsExist":false}');

             System.assert(msg!=null);
        }
        
    }
    
    
}