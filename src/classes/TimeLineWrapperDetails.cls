/**
* @Description  Utility Class for Activity Service that contains all necessary which faciliates user to view Activity data on page
* @author Saptaswa
* @date 20-12-2017
*/




public with sharing class TimeLineWrapperDetails {
    
    @AuraEnabled
    public Integer index;
    @AuraEnabled
    public String eventTypeName;
    @AuraEnabled
    public String type;
    @AuraEnabled
    public String timestamp;
   
    
/**
* @Description Constructor Method for TimeLineWrapperDetails that initializes eventTypename,type,timestamp
* @author Saptaswa
* @date 20-12-2017
*/

    public TimeLineWrapperDetails(){
   
            eventTypeName='';
            type='';
            timestamp= null;
        }

   
}