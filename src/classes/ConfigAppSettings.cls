/**
* @Description This Class handles the functionality of saving all the data entered in SessionMAppSettings Page into custom settings
* @author Oswin
* @date 20-12-2017
*/


public with sharing class ConfigAppSettings{

    public static String customSettingsLabelName = System.Label.smsfsc.Custom_Setings_Name;
    public static Schema.DescribeSObjectResult listCustSettingsDesObjResult = Schema.sObjectType.smsfsc__SMLSettings__c;
    public static Schema.DescribeSObjectResult protCustSettingsDesObjResult = Schema.sObjectType.smsfsc__SMPSettings__c;
    private static smsfsc__SMPSettings__c protectedCustomSettings =smsfsc__SMPSettings__c.getValues(customSettingsLabelName);
    
  
/**
* @Description This methods handles functionality of inserting/updating the valid values entered on the Appsettings page into custom settings
* @author Oswin
* @date 20-12-2017
* @param settingsUtilityWrapperObj WrapperClass object for SessionMAppSettingsCmp which has all the valid data to be stored in custom settings
*/

 
    public static void configure(SettingsUtilityWrapper settingsUtilityWrapperObj){
        
        if(listCustSettingsDesObjResult.isCreateable() && listCustSettingsDesObjResult.isUpdateable()){
            upsert settingsUtilityWrapperObj.listCustomSettings;
        }
            
        if(protCustSettingsDesObjResult.isCreateable() && protCustSettingsDesObjResult.isUpdateable()){
           upsert settingsUtilityWrapperObj.protectedCustomSettings; 
        }
             
    }
    
    
/**
* @Description This method handles the functionality of validating the values entered by user in AppSettings page and sends a message to be displayed on UI in both cases i.e error and success
* @author Oswin
* @date 20-12-2017
* @See EnrollService
* @return Message-->Wrapper class that contains messagetext,messagetype and message code
* @param settingsUtilityWrapperObj WrapperClass object for SessionMAppSettingsCmp
*/

   
    public static Message validateAppSettings(SettingsUtilityWrapper settingsUtilityWrapperObj){
        List<Message> messages = new List<Message>();
        String msgTodisplay = ''; 
        if(!SettingsUtilityWrapper.ValidationCheck(settingsUtilityWrapperObj,messages)){
         //check if user has entered values in all the fields of AppSettings page
            if(!messages.isEmpty()){

                for(Message msg : messages){

                    msgTodisplay += msg.msgText+', ';
                }

                msgTodisplay = msgTodisplay.removeEnd(', ');

            }
            //If user has left any field blank display error message on UI
            return new Message(GeneralConstants.CONST_STATUS_ERROR, null, String.isNotBlank(msgTodisplay) ? msgTodisplay : System.Label.General_Error_Message);
        }
        else{

            ServicesRouter.configureSettings(settingsUtilityWrapperObj);
            return new Message(GeneralConstants.CONST_SUCCESS_MSG, null, String.isNotBlank(msgTodisplay) ? msgTodisplay : System.Label.General_Success_Message);
        }   
    }
    
   

}