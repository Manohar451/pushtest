/**
* @Description This is an utility class that checks custom labels and their values and helps shipping them to the User
* @author Krunal
* @date 09-01-2017
*/
@isTest
private with sharing class LabelUtilityTest {
    
     /**
* @Description This method is used to check if the custom labels are present or not and ships the labels
* @author Manohar Pandurangi
* @date 11-11-2017
*/

    static testmethod void customlabelTest() {
        
         System.debug(System.Label.smsfsc.external_id_already_used);
        System.debug(System.Label.smsfsc.validation);
        System.debug(System.Label.smsfsc.User_Enrollment_Failure);
        System.debug(System.Label.smsfsc.An_Email_Or_External_Id_Is_Required);
         System.debug(System.Label.smsfsc.user_not_found);
         System.debug(System.Label.smsfsc.User_Updated_Success);
         System.debug(System.Label.smsfsc.incorrect_api_params);
         System.debug(System.Label.smsfsc.invalid_api_key);
         System.debug(System.Label.smsfsc.Activity_PageSize_HelpText);
         System.debug(System.Label.smsfsc.Enrollment_Access_Error);
         System.debug(System.Label.smsfsc.Enrollment_Error_Community);
         System.debug(System.Label.smsfsc.Loyalty_Data_Absent_Error);
         System.debug(System.Label.smsfsc.Email_Different_Message_When_Account_Updates);
       
        System.assert(System.Label.smsfsc.external_id_already_used!=null);
        System.assert(System.Label.smsfsc.invalid_api_key!=null);
        System.assert(System.Label.smsfsc.Comping_Error_message!=null);
        System.assert(System.Label.smsfsc.SObject_Type_Error!=null);
        System.assert(System.Label.smsfsc.internal_server_error!=null);
        System.assert(System.Label.smsfsc.incorrect_api_params!=null);
         System.assert(System.Label.smsfsc.PageSize_Error_Message!=null);
         System.assert(System.Label.smsfsc.ReasonCode_Button_Label!=null);
         System.assert(System.Label.smsfsc.ZeroPointsErrorMessage!=null);
         System.assert(System.Label.smsfsc.PointsComponentPointsFieldLabel!=null);
         System.assert(System.Label.smsfsc.PointsField_Empty_Error_Message!=null);
         System.assert(System.Label.smsfsc.PointsValidationError!=null);
         System.assert(System.Label.smsfsc.Page_Size_Label!=null);
         System.assert(System.Label.smsfsc.ReasonCode_PageHeader_Text!=null);
        System.assert(System.Label.smsfsc.Validation_Error_Email!=null); 
         System.assert(System.Label.smsfsc.MaxPointsReachedError!=null);
        System.assert(System.Label.smsfsc.Read_Only_Fields_Not_Updatable_Error!=null);
         System.assert(System.Label.smsfsc.SessionM_TimeOut_Label!=null);
         System.assert(System.Label.smsfsc.SessionM_TimeOut_HelpText!=null);
         System.assert(System.Label.smsfsc.TimeoutErrorMessage!=null);
          System.assert(System.Label.smsfsc.Max_Activity_Records_HelpText!=null);
           System.assert(System.Label.smsfsc.Max_Activity_Records_Label!=null);
            System.assert(System.Label.smsfsc.Max_Activity_Records_Message!=null);
            System.assert(System.Label.smsfsc.Configuration_Error!=null);
            System.assert(System.Label.smsfsc.Pattern_Mismatch_Error!=null);
            System.assert(System.Label.smsfsc.Email_Different_Message_When_Account_Updates!=null);
             System.assert(System.Label.smsfsc.Insufficient_Priviledges!=null);
                     System.assert(System.Label.smsfsc.no_stream_view_found!=null);
                             System.assert(System.Label.smsfsc.access_denied!=null);


      
            
    

    }

}