/**
* @Description Utility Class is utilized to check necessary user permissions on various Sobjects and their respective fields
* @author Oswin
* @date 20-12-2017
*/


public with sharing class PermissionsWrapper {

    public Boolean isAccessible;
    public Boolean isUpdateable;
    public Boolean isCreateable;
    public Boolean isSearchable;
    public Boolean isDeletable;
    public Boolean isQueryable;

/**
* @Description Constructor method for PermissionsWrapper which takes object name as input and checks if  user has permissions to access object
* @author Oswin
* @date 20-12-2017
* @param objName Name of the SObject
*/

    public PermissionsWrapper(String objName){
        Schema.DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(objName).getDescribe();
        this.isAccessible = objResult.isAccessible();
        this.isUpdateable = objResult.isUpdateable();
        this.isCreateable = objResult.isCreateable();
        this.isSearchable = objResult.isSearchable();
        this.isDeletable = objResult.isDeletable();
        this.isQueryable = objResult.isQueryable();
    }

    
 /**
* @Description Constructor method for PermissionsWrapper which takes object fields as input and checks if user has necessary permission to access them
* @author Oswin
* @date 20-12-2017
* @param field Name of field on which permissions are to be checked
*/
    public PermissionsWrapper(Schema.sObjectField field){
        Schema.DescribeFieldResult objResult = field.getDescribe();
        this.isAccessible = objResult.isAccessible();
        this.isUpdateable = objResult.isUpdateable();
        this.isCreateable = objResult.isCreateable();
    }
    
}