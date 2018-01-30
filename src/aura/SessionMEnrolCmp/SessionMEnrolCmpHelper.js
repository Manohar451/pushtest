({
	InitializeComponent: function(component) {
	//Show the loading spinner
	component.set("v.isLoading", true);

	
		var initializeEnroll = component.get("c.initializeEnroll");
		initializeEnroll.setParams({ accountId : component.get("v.recordId"),
                         });
				initializeEnroll.setCallback(this, function(response8) {
					component.set("v.showEnroll", true);
					component.set('v.enrollWrapper',response8.getReturnValue());
					var enrollUtilityWrapperObj = component.get('v.enrollWrapper');
                   
					
					if((enrollUtilityWrapperObj.experience ==='Theme3'))
					{
						
							if((enrollUtilityWrapperObj.networkId=== null)||(enrollUtilityWrapperObj.networkId=== '') ||($A.util.isUndefinedOrNull(enrollUtilityWrapperObj.networkId)))
							{
								var isThemeConsole1=sforce.console.isInConsole();
								
								if(isThemeConsole1=== false)
								{
								
								 enrollUtilityWrapperObj.isDisplayBack= true;
								 enrollUtilityWrapperObj.isBackdisabled= false;
								}
								else{
									enrollUtilityWrapperObj.isDisplayBack= false;
								}
							}
							else{
								enrollUtilityWrapperObj.isDisplayBack= true;
								enrollUtilityWrapperObj.isBackdisabled= false;
							}
					}
					else{
						enrollUtilityWrapperObj.isBackdisabled= false;//Hide the back button for other themes(Lightning)
					}
			
					//Hide the loading spinner
					
					component.set('v.enrollWrapper',enrollUtilityWrapperObj);
                     window.setTimeout(
									$A.getCallback(function() {
										
                                        component.set("v.isLoading", false);
											}), 2000
									);
					
				});
				
	$A.enqueueAction(initializeEnroll);
		
 
},

doenrollUser: function(component){

	//Show the loading spinner
	component.set("v.isLoading", true);
	component.set('v.showMessage',false);
	var enrollUtilityWrapper = component.get('v.enrollWrapper');
    var enroll = component.get("c.enroll");//Method called to enroll user
    var that = this;
	
    //User entered email and corresponding accountId are set as arguments
    enroll.setParams({ emailId : enrollUtilityWrapper.accountEmail,
                          accountId : component.get("v.recordId"),
                          "JSONstring" : JSON.stringify(enrollUtilityWrapper)
                         });

    // Set up the callback
   
    enroll.setCallback(this, function(response) {
        var state = response.getState();
        
			if (component.isValid() && state === "SUCCESS") {
            
				if(response.getReturnValue()!==null)	 
				{
						component.set('v.enrollWrapper',response.getReturnValue());
						component.set('v.showMessage',true);
						var enrollUtilityWrapperInstance = component.get('v.enrollWrapper');
						
						
							if(enrollUtilityWrapperInstance.isEnrolSuccess)
							{
								
								enrollUtilityWrapperInstance.isEnroldisabled = true;
								enrollUtilityWrapperInstance.isBackdisabled = true;
                              
							}
							else{
								 //hints for labels
								// $Label.smsfsc.An_Email_Or_External_Id_Is_Required
								// $Label.smsfsc.API_EmailField_Label  
								// $Label.smsfsc.Enrollment_Access_Error
								// $Label.smsfsc.Enrollment_Error_Community
								// $Label.smsfsc.Enrollment_Info  
								// $Label.smsfsc.Enroll_Email_Not_Present_Partial_Msg
								// $Label.smsfsc.external_id_already_used
								// $Label.smsfsc.internal_server_error  
								// $Label.smsfsc.invalid_api_key
								// $Label.smsfsc.incorrect_api_params
								// $Label.smsfsc.SessionM_Internal_Error  
								// $Label.smsfsc.User_Enrollment_Failure
								// $Label.smsfsc.validation
								// $Label.smsfsc.Validation_Error_Email
							
								 if(response.getReturnValue().msg.msgText.startsWith('#_$') || response.getReturnValue().msg.msgText.endsWith('#_$') || response.getReturnValue().msg.msgText.includes("#_$")){
                            
							 //hints for labels
								// $Label.smsfsc.An_Email_Or_External_Id_Is_Required
								// $Label.smsfsc.API_EmailField_Label  
								// $Label.smsfsc.Enrollment_Access_Error
								// $Label.smsfsc.Enrollment_Error_Community
								// $Label.smsfsc.Enrollment_Info  
								// $Label.smsfsc.Enroll_Email_Not_Present_Partial_Msg
								// $Label.smsfsc.external_id_already_used
								// $Label.smsfsc.internal_server_error  
								// $Label.smsfsc.invalid_api_key
								// $Label.smsfsc.incorrect_api_params
								// $Label.smsfsc.SessionM_Internal_Error  
								// $Label.smsfsc.User_Enrollment_Failure
								// $Label.smsfsc.validation
								// $Label.smsfsc.Validation_Error_Email
								
                            
                           
                            
                            var codeAndMessageArray = response.getReturnValue().msg.msgText.split("#_$");
                           
                            
                            
                            if(($A.util.isEmpty(codeAndMessageArray[1])) || ( $A.util.isUndefinedOrNull(codeAndMessageArray[1])))
                            {
                                 
                                  
                                
                                   enrollUtilityWrapperInstance.msg.msgText = $A.get("$Label.smsfsc."+codeAndMessageArray[0]);
                            }
                            else if(($A.util.isEmpty(codeAndMessageArray[0])) || ( $A.util.isUndefinedOrNull(codeAndMessageArray[0]))){
                                enrollUtilityWrapperInstance.msg.msgText = codeAndMessageArray[1];
                               
                            }
                            
                            else
                            {
                                
                              
                              var text = $A.get("$Label.smsfsc."+codeAndMessageArray[0]);
							 
                              
								   if(($A.util.isEmpty(text)) || ( $A.util.isUndefinedOrNull(text)) || text.includes('$Label') || text.startsWith('['))
								    {
									  
									
									 //alert('hi thr');
									 enrollUtilityWrapperInstance.msg.msgText= codeAndMessageArray[1];
								    }
								    else
									{
										
									  enrollUtilityWrapperInstance.msg.msgText=text; 
									}
                            
                            }
                        }
							
							}
							
							component.set('v.enrollWrapper',enrollUtilityWrapperInstance);
                            
							var toastEvent = $A.get("e.force:showToast");//Show toast message for success/failure when run in Lightning mode
							
							if((enrollUtilityWrapperInstance.experience !=='Theme4t' && enrollUtilityWrapperInstance.experience !=='Theme3') || ((toastEvent) && (enrollUtilityWrapperInstance.experience !=='Theme4t') 
								&& ((enrollUtilityWrapperInstance.networkId!== null)&&(enrollUtilityWrapperInstance.networkId!== '') &&(!$A.util.isUndefinedOrNull(enrollUtilityWrapperInstance.networkId)))))
							{
								setTimeout(function(){
                                    
									if(toastEvent)
									{
										toastEvent.setParams({
										"title": enrollUtilityWrapperInstance.isEnrolSuccess ? 'Success!' : 'Failure!',
										"message": enrollUtilityWrapperInstance.msg.msgText,//Display the error message using toast event
										"type": enrollUtilityWrapperInstance.isEnrolSuccess ? 'success' : 'error'
											});
										toastEvent.fire();//Fire the toast event
										component.set("v.isLoading",false);//Hide the loading spinner
										
									}
								},2000);
								
								
							}
							else{
								//alert('Here in Classic ');
								setTimeout(function(){
									$A.createComponent(
											"c:SessionMMessageCmp",
											{
												"MessageInfo": enrollUtilityWrapperInstance.msg
											},
											function(msgBox){                
												if (component.isValid()) {
													var targetCmp = component.find('MessageBody');
													var body = targetCmp.get("v.body");
													body.push(msgBox);
													targetCmp.set("v.body", body); 
												}
											}
										);
								component.set("v.isLoading",false);	
								},2000);
								
							}
								if(enrollUtilityWrapperInstance.isEnrolSuccess)
								{
										window.setTimeout(
										$A.getCallback(function() { 
											component.set('v.showMessage',false);
											component.set("v.showEnroll", false);
											that.reloadViewEvent(component); //Call a method which fires an application event which loads the View Component
											
												}), (enrollUtilityWrapperInstance.experience ==='Theme4d'? 2000 : 5000)
										);
									
								}
					}
				}
				
			
    });
  
    $A.enqueueAction(enroll);
	
},

/* Function to fire an application event which is handled in the parent component 
 * to Load the View Component after successful Enrollment
 */

reloadViewEvent: function(component) {
   var recordId = component.get("v.recordId");

    if(!$A.util.isUndefined(recordId) && !$A.util.isEmpty(recordId)){
    	 component.set("v.isLoading", false);
		var SessionMReloadViewEvent = $A.get("e.c:SessionMReloadViewEvent");
		SessionMReloadViewEvent.setParams({ "redirectionContext" : "Event Fired" ,"accountId" :  recordId});
										   
		SessionMReloadViewEvent.fire();
    }
}
})