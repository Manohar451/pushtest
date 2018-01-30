/**
* @Description Controller class for SessionMContainerCmp
* @author Oswin
* @date 22-12-2017
*/

public with sharing class SessionMContainerController {
    
/**
* @Description This method is called when Conatiner component loads
* @author Saptaswa
* @date 19-12-2017
* @return ContainerUtilityWrapper-->Wrapper object that holds all the values that are to be loaded on page when page is freshly loaded
* @param accId AccountId of the User 
*/

    @AuraEnabled
    public static ContainerUtilityWrapper  init(Id accId) {
        
        return new ContainerUtilityWrapper(accId);
    }
    

/**
* @Description This method is used to check if duplicate record is created 
* @author Saptaswa
* @date 20-12-2017
* @See GeneralUtility.getSessionMUserListByAccountId
* @return Boolean-->Indicates if duplicate record is present or not
* @param accountId Account Id of account record
*/

    @AuraEnabled
    public static boolean isDuplicateRecordDeleted(Id accountId){
            
        List<smsfsc__SessionMUser__c> smUserObjList = GeneralUtility.getSessionMUserListByAccountId(accountId);
        
        if(smUserObjList != null ){
            
            if(smUserObjList.size() ==1)
            {
                return true;
            }else {
                return false;
            }
            
        }
        else{
        
            return false;
        }
    }
    
/**
* @Description This method is used to check if enroll record is created or not
* @author Saptaswa
* @date 20-12-2017
* @See GeneralUtility.getSessionMUserListByAccountId
* @return boolean-->indicates if user is successfully enrolled or not
* @param accountId AccountId of the account record
*/

    @AuraEnabled
    public static boolean isEnrolledRecordCreated(Id accountId){
            
        List<smsfsc__SessionMUser__c> smUserObjList = GeneralUtility.getSessionMUserListByAccountId(accountId);
        
        if(smUserObjList != null ){
            
            if(smUserObjList.size() ==1 || smUserObjList.size() > 1)
            {
                return true;
            }else{
                return false;
            }
            
        }
        else{
        
            return false;
        }
    }
    

    
/**
* @Description This method is used to check the transaction object record count
* @author Oswin
* @date 22-12-2107
* @See GeneralUtility.getTransactionCountForSessionMUser
* @return AggregateResult-->aggregate count of number of transaction records created
* @param sessionMUserId Id of the SessionMUser record
*/

    @AuraEnabled
    public static AggregateResult checkTransactionCount(Id accountId){


                 
        return GeneralUtility.getTransactionCountForSessionMUser(accountId);
        
    }
}