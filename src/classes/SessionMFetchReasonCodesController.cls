/**
* @Description  Controller Class For ReasonCode valeus Page that handles contains all the reason codes received from SessionM platform

* @author Manohar Pandurangi
* @date 11-11-2017
*/


//New Class

public with sharing class SessionMFetchReasonCodesController {
    
/**
* @Description This Method drives the functionality of performing callouts to SessionM API and fetch the reasoncodes
* @author Manohar Pandurangi
* @date 11-11-2017
* @See ServicesRouter.fetchReasonCodePickListValues
* @return type ReasonCodeResponse-->Wrapper object that holds all the picklist values
*/

    
    @AuraEnabled
    public static ReasonCodeResponse fetchReasonCodePickListValues(){
        
        return ServicesRouter.fetchReasonCodePickListValues();
        
    }

}