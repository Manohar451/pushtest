/**
* @Description Message class is responsible to hande all the UI messages displayed to the user in both Success and Failure scenario
* @author Saptaswa
* @date 23-11-2017
*/

public with sharing class Message {
    
    // Message Type attribute will have 3 possible values
    // ERROR, WARNING, SUCCESS
    @AuraEnabled 
    public String msgType;
    // Message Code attribute is set from the response of Session M 
    @AuraEnabled  
    public String msgCode;
    // Description if any
    @AuraEnabled 
    public String msgText;
    // Description if any
    @AuraEnabled 
    public String experienceType;
    @AuraEnabled 
    public Boolean isCommunity = Network.getNetworkId() != Null;

/**
* @Description Constructor method for Message class that sets the msgcode,msgtype,msgtext and also the theme in which user is currently in
* @author Oswin
* @date 23-12-2017
* @param msgType Type of message ERROR,SUCCESS,INFO 
* @param msgCode Message code
* @param msgText Message received from SessionMAPI
*/

    public Message(String msgType, String msgCode, String msgText){
        this.msgCode = String.isNotBlank(msgCode) ? msgCode : '';
        this.msgType = String.isNotBlank(msgType) ? msgType.toLowerCase() : '';
        this.msgText = String.isNotBlank(msgText) ? msgText : '';
        String uiTheme = UserInfo.getUiThemeDisplayed();

        //Check for appropriate theme being displayed for the current user
        if(uiTheme == 'Theme1' || uiTheme == 'Theme2' || uiTheme == 'Theme3'){
             experienceType = 'CLASSIC';
        }
        else if(uiTheme == 'Theme4d'){
            experienceType = 'LIGHTNING';
        }
        else if(uiTheme == 'Theme4t'){
            experienceType = 'SF1';
        }    
    }
}