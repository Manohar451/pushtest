/**
* @Description APIResult class will be responsible for the fetching the responses of the SessionM API Callouts
* @author Saptaswa
* @date 07-11-2017
*/

public with sharing class APIResult {
    
    /*
    * Attributes
    */
    // isSuccess tells whether it is successful or not
     @AuraEnabled
    public boolean isSuccess {get;set;}
    
    // List of Messages
     @AuraEnabled
    public List<Message> messages {get;set;}
   
/**
* @Description Constructor method for APIResult class that is used to set the attributes of the class
* @author Saptaswa
* @date 07-11-2017
* @param isSuccess Boolean value it is true if status is success else false 
* @param messages List of messages 
*/

    public APIResult(boolean isSuccess, List<Message> messages){
        
        this.isSuccess=isSuccess;
        this.messages= messages;
        
    }

    
}