/**
* @Description Test class for TestDataFactory
* @author Manohar Pandurangi
* @date 11-11-2017
*/
@isTest
public with sharing class TestObjectBuilderFactoryTest {
    
    
 /**
* @Description Test Method for TestDataFactory class
* @author Manohar Pandurangi
* @date 11-11-2017
*/
    @isTest
    public static void testdatafactorymethod()
    {
        
        Account acc = TestDataFactory.createAccountRecord();
        insert acc;
        Contact con = TestDataFactory.createContactRecords();
        insert con;
        
        smsfsc__SMPSettings__c smp = TestDataFactory.createProtectedCustomSettings();
        insert smp;
        
        smsfsc__SMLSettings__c sml = TestDataFactory.createUnprotectedCustomSettings();
        insert sml;
        
        SessionMUser__c sm = TestDataFactory.getSessionMUserRecord();
        insert sm;
        
        Account acc1 = TestDataFactory.createAccountRecordNegative();
        insert acc1;
        
        SessionMUser__c sm1 = TestDataFactory.getSessionMUserRecordsNegative();
        insert sm1;
        
        smsfsc__SessionM_Transaction__c transobj = TestDataFactory.SessionMTransactionRecords();
        insert transobj;
        
        system.assert(acc!=null);
        system.assert(con!=null);
        
       
    }
   
   
}