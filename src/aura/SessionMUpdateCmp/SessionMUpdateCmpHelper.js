({
    
       //Method called when page loads initially
		doInitialize : function(component) {
			$A.util.removeClass(component.find("spinner"), "slds-hide");
			
			
			var checkAccess = component.get("c.checkAccess"); 
            
           
			checkAccess.setCallback(this, function(response) {
				if(response.getState() === "SUCCESS"){
				   var isSufficientPrivilege = response.getReturnValue(); 
				  
				   if(isSufficientPrivilege !== null){
						component.set('v.isInSuffiecientPrivilege',isSufficientPrivilege);
				   }
				   $A.util.addClass(component.find("spinner"), "slds-hide");
				}
			});
			$A.enqueueAction(checkAccess);
			
			
			var init = component.get("c.init"); 
            
            //Set fuction parameters i.e account Id
			 init.setParams({
				accId: component.get("v.recordId") 
			});
			
			init.setCallback(this, function(response) {
				if(response.getState() === "SUCCESS"){
				   var objSessionMUser = response.getReturnValue(); 
				   if(objSessionMUser !== null){
						component.set('v.SessionMUser',objSessionMUser);
				   }
				   $A.util.addClass(component.find("spinner"), "slds-hide");
				}
			});
			$A.enqueueAction(init);
		},

        //Method that saves the updated data
		saveRecord : function(component) {
			component.find("recordView").get("e.recordSave").fire();
		},

        //Method that updates the data entered in page
		doUpdate : function(component) {
			
		
			component.set('v.showMessage',false);
			var objSessionMUser = component.get("v.SessionMUser");
			if(!$A.util.isUndefined(objSessionMUser.Id) && !$A.util.isEmpty(objSessionMUser.Id)){
				
				$A.util.removeClass(component.find("spinner"), "slds-hide");
				
				var modifySessionMUser = component.get("c.modifySessionMUser"); 
				modifySessionMUser.setParams({sessionMUserObjId: objSessionMUser.Id});
				modifySessionMUser.setCallback(this, function(response) {
					
					if(response.getState() === "SUCCESS"){
						
					   component.set('v.showMessage',true);
					   var msg = response.getReturnValue();
					   
					   if(!$A.util.isUndefined(msg) && !$A.util.isEmpty(msg)){
											  
							 if(msg.msgText.startsWith('#_$') || msg.msgText.endsWith('#_$') || msg.msgText.includes("#_$")){
                            
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
								// $Label.smsfsc.Read_Only_Fields_Not_Updatable_Error
								
                            
                           
                            
                            var codeAndMessageArray = msg.msgText.split("#_$");
                           
                            
                            
                            if(($A.util.isEmpty(codeAndMessageArray[1])) || ( $A.util.isUndefinedOrNull(codeAndMessageArray[1])))
                            {
                                 
                                  
                                
                                    msg.msgText = $A.get("$Label.smsfsc."+codeAndMessageArray[0]);
                            }
                            else if(($A.util.isEmpty(codeAndMessageArray[0])) || ( $A.util.isUndefinedOrNull(codeAndMessageArray[0]))){
                                msg.msgText = codeAndMessageArray[1];
                               
                            }
                            
                            else
                            {
                                
                              
                              var text = $A.get("$Label.smsfsc."+codeAndMessageArray[0]);
							 
                              
								   if(($A.util.isEmpty(text)) || ( $A.util.isUndefinedOrNull(text)) || text.includes('$Label') || text.startsWith('['))
								    {
									  
									
									 //alert('hi thr');
									  msg.msgText= codeAndMessageArray[1];
								    }
								    else
									{
										
									   msg.msgText=text; 
									}
                            
                            }
                        }
						   
							if(msg.experienceType === 'LIGHTNING'){
								var toastEvent = $A.get("e.force:showToast");
								toastEvent.setParams({
									"type": msg.msgType,
									"message": msg.msgText	
								});
								toastEvent.fire();
							}
							else{
								
								$A.createComponent(
									"c:SessionMMessageCmp",
									{
										"MessageInfo": msg
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
							}
							
							if(msg.msgType === 'success'){
                                //If message type is success disable the Back and Save button
								component.set('v.makeDisabled',true);
								
								var that = this;
								 
							   window.setTimeout(
									$A.getCallback(function() {
										
										component.set('v.showUpdate',false);
										that.fireSessionMContainerEvent(component); //Call a method which fires an application event which loads the View Component

									}), 2000
								);
							}
							else{
							component.set('v.makeDisabled',false);	
							component.set('v.hasError',true);
							$A.util.addClass(component.find("spinner"), "slds-hide");
							}
					   }
					   
					}
					
				});
				$A.enqueueAction(modifySessionMUser);    
			}
		},
    
    
        //Event fired on succesful user update
		fireSessionMContainerEvent : function(component) {
			var recordId = component.get("v.recordId");

        	if(!$A.util.isUndefined(recordId) && !$A.util.isEmpty(recordId)){

        		$A.util.addClass(component.find("spinner"), "slds-hide");
				var SessionMContainerEvent = $A.get("e.c:SessionMContainerEvent");
				SessionMContainerEvent.setParams({ "redirectionContext" : "Event Fired From Update","accountId" :  recordId }); 
				SessionMContainerEvent.fire();

        	}
			
		},
    
        //Event fired when user clicks Back Button
		reloadViewEvent: function(component) {
			var recordId = component.get("v.recordId");

        	if(!$A.util.isUndefined(recordId) && !$A.util.isEmpty(recordId)){

				$A.util.addClass(component.find("spinner"), "slds-hide");
				var SessionMReloadViewEvent = $A.get("e.c:SessionMReloadViewEvent");
				SessionMReloadViewEvent.setParams({ "redirectionContext" : "Event Fired","accountId" :  recordId });
												   
				SessionMReloadViewEvent.fire(); 
			}
		
		},
    
        //This method is called when user clicks Back button
		goBack:function(component){
			
			var objSessionMUser = component.get("v.SessionMUser");
			if(!$A.util.isUndefined(objSessionMUser.Id) && !$A.util.isEmpty(objSessionMUser.Id)){
				
				if(component.get("v.hasError")===false)
				{
                    //Show the spinner
					$A.util.removeClass(component.find("spinner"), "slds-hide");
				}
				else{
                    //Hide the Spinner
					$A.util.addClass(component.find("spinner"), "slds-hide");
				}
                
                //Action which cleans the duplicate record
				var actionBack = component.get("c.cleanUpForUpdateServices"); 
				actionBack.setParams({
					newSessionMUserObjId: objSessionMUser.Id 
				});
				actionBack.setCallback(this, function(response) {
					
				    var state = response.getState();
					var that = this;
					if (state === "SUCCESS") {
						 window.setTimeout(
								$A.getCallback(function() {
									component.set('v.showUpdate',false);
									that.reloadViewEvent(component); //Call a method which fires an application event which loads the View Component
                                   
								}), 500
							);
					}
					
				});
					
				$A.enqueueAction(actionBack); 
			}
			
			 
		}

	})