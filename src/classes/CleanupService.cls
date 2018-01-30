/**
* @Description This class is used to clear unwanted/junk SessionM user records 
* @author Oswin
* @date 15-01-2018
*/

public with sharing class CleanupService implements Queueable{
	
	
	
	private List<smsfsc__SessionMUser__c> seesionMUserToDel;
	
          
/**
* @Description This method is constructor method for CleanupService class this class initializes the seesionMUserToDel list i.e the records that are required to be cleaned up
* @author Krunal
* @date 15-11-2018
* @param seesionMUserToDel List of sessionMUser records that are required to be deleted when cleanup service runs
*/

	public CleanupService(List<smsfsc__SessionMUser__c> seesionMUserToDel){
		this.seesionMUserToDel = seesionMUserToDel;
	}
    
    
    
      
/**
* @Description This method clears SessionM user records at regular intervals as specified in List custom settings
* @author Oswin
* @date 15-11-2018
* @param context This paramater allows the user to place the cleanup service job in queue
*/
    public void execute(QueueableContext context){
        
        try{
            
            smsfsc__SMLSettings__c objListSettings = smsfsc__SMLSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME);
            smsfsc__SMPSettings__c objProtectedSettings = smsfsc__SMPSettings__c.getValues(GeneralConstants.CONST_CUSTOM_SETTINGS_LABEL_NAME);
            Map<String, Schema.SObjectField> fieldMapProtected = Schema.getGlobalDescribe().get('smsfsc__SMPSettings__c').getDescribe().fields.getMap();
           
            
            
            DateTime currentTime = Datetime.now();
            Integer cleanUpTimeFrame = Integer.valueOf(objListSettings.smsfsc__CleanUpServiceTimeFrame__c);
            DateTime paramDateTime = currentTime.addHours(-(cleanUpTimeFrame));

            if(smsfsc__SessionMUser__c.sObjectType.getDescribe().isDeletable() &&
                    smsfsc__SessionMUser__c.sObjectType.getDescribe().queryable){
                        
                    if(seesionMUserToDel!= null && seesionMUserToDel.size()>0  ){
                    	
                    	system.debug('-- records to delete in cleanup -- '+seesionMUserToDel.size());
                    
                        Database.delete(seesionMUserToDel,false);
                        
                        if(fieldMapProtected.get('smsfsc__CleanUpServiceLastTimeRun__c').getDescribe().isUpdateable()  ||  
                    	   fieldMapProtected.get('smsfsc__CleanUpServiceLastTimeRun__c').getDescribe().isCreateable()){
                    		
                    		objProtectedSettings.smsfsc__CleanUpServiceLastTimeRun__c  = DateTime.Now();
                    	}
                    	
                    	if(objProtectedSettings!= null && objProtectedSettings.Id != null){
                    		
                    		if(smsfsc__SMPSettings__c.sObjectType.getDescribe().isUpdateable()){
                            	update objProtectedSettings;
                        	}
                    
                   		 }else if(smsfsc__SMPSettings__c.sObjectType.getDescribe().isCreateable()){

                        	insert objProtectedSettings;
                    	}
                    }
                
              }
                
        }catch(Exception e){
            
            system.debug(e.getMessage());
        }
    }
}