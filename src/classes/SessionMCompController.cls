/**
* @Description  Controller Class For SessionMComp component that handles updation of loyalty points of user
* @author Manohar Pandurangi
* @date 11-11-2017
*/

//New class
public with sharing class SessionMCompController {
  
/**
* @DescriptionThis method is called when page loads initially and projects all the necessary data on the page
* @author Manohar Pandurangi
* @date 11-11-2017
* @See SessionMCompingWrapperClass 
* @return SessionMCompingWrapperClass-->Wrapper object that holds all the data which is to be intially loaded on page
* @param accountId AccountId of the account record
*/

    @AuraEnabled
    public static SessionMCompingWrapperClass init(String accountId){
        
        return new SessionMCompingWrapperClass(accountId);
        
    }
   
    
/**
* @Description This method is used to add/remove loyalty points to the User
* @author Manohar Pandurangi
* @date 11-11-2017
* @See ServicesRouter.SessionMcomputePoints
* @return Message-->Message object that holds messagetype,msgcode and messagetext
* @param compingWrapper SessionMCompingWrapper class object which is received in string format
*/

    @AuraEnabled
    public  static Message computePoints(String compingWrapper) {
      
        SessionMCompingWrapperClass transactionobjectParsed = (SessionMCompingWrapperClass)JSON.deserialize(compingWrapper, SessionMCompingWrapperClass.Class);
        system.debug('accountid in controller'+transactionobjectParsed.accountId);
        return ServicesRouter.computePoints(transactionobjectParsed);
        
    }
    
   
    }