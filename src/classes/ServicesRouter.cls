/**
* @Description It internally calls different services depending upon the events, it will be a single gateway for every API Call
* @author Krunal
* @date 12-11-2017
*/

public with sharing class ServicesRouter {

/**
* @Description This method drives the functionality of saving the valid data in AppSettings page to respective custom settings records
* @author Oswin
* @date 20-12-2017
* @See ConfigAppSettings.configure
* @param objSettingsUtilityWrapper Wrapper class object of SettingsUtilityWrapper 
*/

  //Newly Added During Refactor
    public static void configureSettings(SettingsUtilityWrapper objSettingsUtilityWrapper){
    
        ConfigAppSettings.configure(objSettingsUtilityWrapper);
    }
    
/**
* @Description This method validates the data entered by user in fields of AppSettings page and displays appropriate message 
* @author Oswin
* @date 20-12-2017
* @SeeConfigAppSettings.validateAppSettings
* @return Message-->Message objects that holds msgtext,msgcode,msgtype 
* @param objSettingsUtilityWrapper Wrapper class object of SettingsUtilityWrapper 
*/

    //Newly Added During Refactor
    public static Message validateAppSettings(SettingsUtilityWrapper objSettingsUtilityWrapper){
        
        return ConfigAppSettings.validateAppSettings(objSettingsUtilityWrapper);
    }
    

/**
* @Description This method drives the functionality of the updation of user data
* @author Saptaswa
* @date 20-12-2017
* @See UpdateServices.modifySessionMUser
* @return Message-->Message objects that holds msgtext,msgcode,msgtype
* @param sessionMUserObjId SessionM user Id   
*/

    //Newly Added During Refactor
    public static Message modifySessionMUser(Id sessionMUserObjId){
    
        return UpdateServices.modifySessionMUser(sessionMUserObjId);
    } 
    
/**
* @Description This method drives the functionality of  fetching activitiy record from SessionMAPI
* @author Saptaswa
* @date 20-12-2017
* @See TimelineServices.fetchActivities
* @return ActivityUtilityWrapper-->Wrapper class object that holds all the activities record
* @param accountId AccountId of the account record
* @param count Number of records to be fetched 
*/

    
    //Newly Added
    public static ActivityUtilityWrapper fetchActivities(Id accountId,Integer count){
        
        return TimelineServices.fetchActivities(accountId,count);
    }
    
/**
* @Description This method is used to fetch reasoncode values from SessionM API
* @author Krunal
* @date 20-12-2017
* @See GeneralUtility.fetchReasonCodePickListValues
* @return ReasonCodeResponse-->wrapper object that has all picklist values
*/

   public static ReasonCodeResponse fetchReasonCodePickListValues(){
    
        return GeneralUtility.fetchReasonCodePickListValues();
    } 
 
 /**
* @Description This method drives the functionality of enrolling the user into SessionM platform
* @author Saptaswa
* @date 11-11-2017
* @See EnrollService.enrollUserSM
* @return APIResult-->Wrapper object which indicates the result of callout and its respective message
* @param emailId EmailId used to register on SessionM platform 
* @param AccountId AccountId of the account record 
*/

  public static APIResult enrollUser(String emailId,Id AccountId){
    
    return EnrollService.enrollUser(emailId,AccountId);
  }
  

/**
* @Description This method is used to fetch the SessionM record of the Account record whose Id is passed as parameter
* @author Saptaswa
* @date 22-12-2017
* @See ViewService.getSessionMUser
* @return Message-->Message object that holds messagetype,msgcode and messagetext
* @param AccountId AccountId of the account record
*/

  public static Message getSessionMUser(String AccountId){
    
    return ViewService.getSessionMUser(AccountId);
    
  }
  
/**
* @Description This method drives the functionality of  Adding/Removing Points to the User
* @author Krunal
* @date 22-12-2017
* @See CompingServices.computePoints
* @return Message-->Message object that holds messagetype,msgcode and messagetext
* @param compingWrapper Wrapper class object of SessionMCompingWrapperClass 
*/

  public static Message computePoints(SessionMCompingWrapperClass compingWrapper){
    
    return CompingServices.computePoints(compingWrapper);
    
  }
  
 
/**
* @Description This method is used to clean up for update services i.e delete junk records created when update opertaion is performed
* @author Saptaswa
* @date 22-12-2017
* @See  UpdateServices.cleanUpForUpdateServices
* @param newSessionMUserObjId Id of SessionMUser record 
*/


    public static void cleanUpForUpdateServices(Id newSessionMUserObjId){
        UpdateServices.cleanUpForUpdateServices(newSessionMUserObjId);
    }
    

/**
* @Description Used to fetch sessionM user record when accountID is given as input
* @author Saptaswa
* @date 22-12-2017
* @See UpdateServices.fetchSessionMUserRecord
* @return smsfsc__SessionMUser__c-->SessionM user record
* @param accountId Account Id of the account record
*/

    public static smsfsc__SessionMUser__c fetchSessionMUserRecord(Id accountId){
        return UpdateServices.fetchSessionMUserRecord(accountId);
    }
}