/**
* @Description This is controller class for SessionMAppSettingsCmp
* @author Oswin
* @date 11-11-2017
*/

public  with sharing class SessionMAppSettingsController {

    
/**
* @Description This method is called when the AppSettings page initially loads
* @author Oswin 
* @date 11-11-2017
* @return SettingsUtilityWrapper-->Wrapper class objects that loads values in the field when is freshly loaded
*/

    @AuraEnabled
    public static SettingsUtilityWrapper init() {
        
        return new SettingsUtilityWrapper();
    }

    
    /**
* @Description This method is used to save custom settings
* @author Oswin
* @date 11-11-2017
* @See ServicesRouter.validateAppSettings
* @return Message-->Message objects that holds msgtext,msgcode,msgtype
* @param JSONString custom settings object serialized and returned in json format from client controller
*/

    @AuraEnabled
    public static  Message validateAndSave(String JSONstring) {
        
        return ServicesRouter.validateAppSettings((SettingsUtilityWrapper) JSON.deserialize(JSONstring, SettingsUtilityWrapper.class));

    }
}