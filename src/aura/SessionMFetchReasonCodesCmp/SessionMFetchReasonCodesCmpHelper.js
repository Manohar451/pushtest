({
    //This method is used to fetch reasoncode values from SessionM platform
    fetchReasonCodePickListValues: function(component) {
       
        var fetchReasonCodePickListValues = component.get("c.fetchReasonCodePickListValues");

        var errorMessageComponent = component.find("ReasonCodeError");
        
        $A.util.addClass(errorMessageComponent, "slds-hide");

        fetchReasonCodePickListValues.setCallback(this, function(response) {

         var state = response.getState();

         if (component.isValid() && state === "SUCCESS") {

                component.set('v.ReasonCodeResponse', response.getReturnValue());
                
                var reasonMessage = component.get('v.ReasonCodeResponse');

                if (reasonMessage.apiResult.messages[0].msgText !== '') {
                        //Show UI message component and display errors fetched from Custom labels
                        $A.util.addClass(errorMessageComponent, "slds-show");
                        var labelSubStr = reasonMessage.apiResult.messages[0].msgText.split("#_$");
                         if(reasonMessage.apiResult.messages[0].msgText.startsWith('#_$') || reasonMessage.apiResult.messages[0].msgText.endsWith('#_$') || reasonMessage.apiResult.messages[0].msgText.includes("#_$")){
                            
							/***** Do not remove these commented lines*****/
                            //hints for labels
                            // $Label.smsfsc.User_Updated_Success
                            // $Label.smsfsc.user_not_found  
                            // $Label.smsfsc.Email_Address_Update_Error
                            // $Label.smsfsc.external_id_already_used
                            // $Label.smsfsc.internal_server_error  
                            // $Label.smsfsc.invalid_api_key
                            // $Label.smsfsc.incorrect_api_params
                            // $Label.smsfsc.SessionM_Internal_Error  
                            // $Label.smsfsc.validation
                            // $Label.smsfsc.Validation_Error_Email
                            
                           
                            
                           
				     var labelSubStr = reasonMessage.apiResult.messages[0].msgText.split("#_$");
					 var errormessage = '';
                           
                            
                            
                            if(($A.util.isEmpty(labelSubStr[1])) || ( $A.util.isUndefinedOrNull(labelSubStr[1])))
                            {
                                 
                                  
                                
                                     errormessage = $A.get("$Label.smsfsc."+labelSubStr[0]);
                            }
                            else if(($A.util.isEmpty(labelSubStr[0])) || ( $A.util.isUndefinedOrNull(labelSubStr[0]))){
                                errormessage = labelSubStr[1];
                               
                            }
                            
                            else
                            {
                                
                              
                              var text = $A.get("$Label.smsfsc."+labelSubStr[0]);
							 
                              
								   if(($A.util.isEmpty(text)) || ( $A.util.isUndefinedOrNull(text)) || text.includes('$Label') || text.startsWith('['))
								    {
									  
									
									 
									  errormessage= labelSubStr[1];
								    }
								    else
									{
										
									   errormessage=text; 
									}
                            
                            }
                        }
               
               //Set the error message to be displayed
               component.set('v.ErrorMessage',errormessage);

                    } else {
                        
                        //If no errors hide the UI message component
                        $A.util.addClass(errorMessageComponent, "slds-hide");
    
                    }

            }

        });
       
        //Call the fetchReasonCodePickListValues action
        $A.enqueueAction(fetchReasonCodePickListValues);

    }
})