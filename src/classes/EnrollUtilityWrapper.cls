/**
* @Description Utility Class for EnrollService that contains all the necessary data to facilitate Enroll functionality in Enroll component
* @author Oswin
* @date 20-12-2017
*/

public with sharing class EnrollUtilityWrapper {

    @AuraEnabled 
    public String enrollResultType{get;set;}
    @AuraEnabled 
    public  String experience=UserInfo.getUiThemeDisplayed();
    @AuraEnabled 
    public  String enrollResultMsgHeader{get;set;}
    @AuraEnabled 
    public  String enrollFailure{get;set;}
    @AuraEnabled 
    public  Boolean isEnroldisabled{get;set;}
    @AuraEnabled 
    public  Boolean isEmailPresent{get;set;}
    @AuraEnabled 
    public  Boolean isDisplayBack{get;set;}
    @AuraEnabled 
    public  Boolean isEnrolSuccess{get;set;}
    @AuraEnabled 
    public  Boolean isBackdisabled{get;set;}
    @AuraEnabled 
    public  String accountEmail{get;set;}
    @AuraEnabled 
    public  String accountEmailLabel{get;set;}
    @AuraEnabled 
    public  Account accountRecord{get;set;}
    @AuraEnabled 
    public  String networkId=Network.getNetworkId();
    @AuraEnabled
    public Message msg = new  Message(GeneralConstants.CONST_STATUS_ERROR, null, System.Label.smsfsc.Mandatory_Field_Error);
    @AuraEnabled
    public APIResult apiResult{get;set;}
    
    
/**
* @Description Constructor for EnrollUtilityWrapper that sets user theme and networkId(used to check if user is community user)
* @author Oswin
* @date 20-12-2017
*/

    public EnrollUtilityWrapper(){
        String uiTheme = UserInfo.getUiThemeDisplayed();
        experience= uiTheme;
        networkId= Network.getNetworkId();
    }

}