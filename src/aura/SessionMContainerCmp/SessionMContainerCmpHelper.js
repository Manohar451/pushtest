({
initializeFromUpdate : function(component) {
    
	var that=this;
    var checkDuplicateRecord = component.get("c.isDuplicateRecordDeleted"); 
		 checkDuplicateRecord.setParams({
			accountId: component.get("v.recordId") 
		});
		
		checkDuplicateRecord.setCallback(this, function(response) {
			if(response.getState() === "SUCCESS"){
               $A.util.removeClass(component.find("spinner"), "slds-hide");
			   var hasDuplicateRecordDeleted = response.getReturnValue();
			   if(hasDuplicateRecordDeleted === false){
                   
					window.setTimeout(
						$A.getCallback(function() {
                         	that.initializeFromUpdate(component); //Call a method which fires an application event which loads the View Component
                           
						}), 4000
					);
			    }
				else{
					var recordId = component.get("v.recordId");
        
	        		if(!$A.util.isUndefined(recordId) && !$A.util.isEmpty(recordId)){
	        			
	        			window.setTimeout(
			                $A.getCallback(function() {

			                    var SessionMCloseContainerEvent = $A.get("e.c:SessionMCloseContainerEvent");
				                SessionMCloseContainerEvent.setParams({ "accountId" : recordId});
				                SessionMCloseContainerEvent.fire();

			                 }), 1000
		                );
	        		}

                    window.setTimeout(
						$A.getCallback(function() {
                           
							that.doinitialize(component);
                            component.set("v.viewSessionMUpdate",false);
                            component.set("v.viewActivities",false);
                            component.set("v.viewCompute",false);
						}), 2000
					);					
				}
			   
			}
		});
	$A.enqueueAction(checkDuplicateRecord);

},

doinitializeView : function(component) {
       
	var that=this;
    var checkenrolledRecord = component.get("c.isEnrolledRecordCreated"); 
		 checkenrolledRecord.setParams({
			accountId: component.get("v.recordId") 
		});
		
		checkenrolledRecord.setCallback(this, function(response) {
			if(response.getState() === "SUCCESS"){
                
               $A.util.removeClass(component.find("spinner"), "slds-hide");
			   var hasRecordCreated = response.getReturnValue();
               
			   if(hasRecordCreated === false){
				   
				  
				    /*****Newly Added*****/
				    window.setTimeout(
			                $A.getCallback(function() {

			                    var SessionMCloseContainerEvent = $A.get("e.c:SessionMCloseContainerEvent");
				                SessionMCloseContainerEvent.setParams({ "accountId" : recordId});
				                SessionMCloseContainerEvent.fire();

			                 }), 1000
		                );
                   
					window.setTimeout(
						$A.getCallback(function() {
                          
							that.doinitializeView(component); //Call a method which fires an application event which loads the View Component
                            
						}), 4000
					);
			    }
				else{
					
                    var recordId = component.get("v.recordId");
        
	        		if(!$A.util.isUndefined(recordId) && !$A.util.isEmpty(recordId)){
	        			
	        			window.setTimeout(
			                $A.getCallback(function() {

			                    var SessionMCloseContainerEvent = $A.get("e.c:SessionMCloseContainerEvent");
				                SessionMCloseContainerEvent.setParams({ "accountId" : recordId});
				                SessionMCloseContainerEvent.fire();

			                 }), 1000
		                );
	        		}

                    window.setTimeout(
						$A.getCallback(function() {
                            
                            that.doinitialize(component);
							component.set("v.showView",true);
							component.set("v.showEnroll",false);
                            component.set("v.viewSessionMUpdate",false);
                            component.set("v.viewActivities",false);
                            component.set("v.viewCompute",false);
						}), 2000
					);					
				}
			  
			}
		});
	$A.enqueueAction(checkenrolledRecord);

},
doinitialize : function(component) {
	var recordId = component.get("v.recordId");

	if(!$A.util.isUndefined(recordId) && !$A.util.isEmpty(recordId)){
		
       /* var workspaceAPI = component.find("workspace");
        workspaceAPI.isConsoleNavigation().then(function(response) {
            if(response === false){
                var SessionMCloseContainerEvent = $A.get("e.c:SessionMCloseContainerEvent");
                SessionMCloseContainerEvent.setParams({ "accountId" :  recordId});
                SessionMCloseContainerEvent.fire();
            }
        })
        .catch(function(error) {
           
        });*/
        
        

		var init = component.get("c.init");
		init.setParams({ accId : recordId });
		init.setCallback(this, function(response) {
		
	        if(response.getState() === "SUCCESS"){
				    
					var resultWrapper = response.getReturnValue();
					
					var errorMsg = '';
					if(!$A.util.isUndefined(resultWrapper) && !$A.util.isEmpty(resultWrapper)){
					
						
						var msgInfo = resultWrapper.responseMsg;
                   		var msg  = msgInfo;
	                    if(!$A.util.isUndefined(msg) && !$A.util.isEmpty(msg)){
						
	                    	var hideBack = false;

	                    	//var workspaceAPI = component.find("workspace");
					        

                            if(msg.experienceType !== 'CLASSIC'){
                                hideBack = true;
                            }
                            else if(!msg.isCommunity){
                                if(sforce.console.isInConsole()){
                                    hideBack = true;
                                }    
                            }
							component.set('v.hideBack',hideBack);
								
							if(!resultWrapper.isSufficientPrivilege)
							{
								
									errorMsg = $A.get("$Label.smsfsc.Insufficient_Priviledges");
									component.set("v.isError",false);
									if(!$A.util.isUndefined(errorMsg) && !$A.util.isEmpty(errorMsg)){
										component.set("v.errorMsg",errorMsg);
										$A.util.addClass(component.find("spinner"), "slds-hide");
										return;
									}
							}
						
                            
							//hints for labels
							// $Label.smsfsc.Configuration_Error
							// $Label.smsfsc.SObject_Type_Error
							if(!resultWrapper.isConfigured)
							{
									errorMsg = $A.get("$Label.smsfsc.Configuration_Error");
									component.set("v.isError",false);
									if(!$A.util.isUndefined(errorMsg) && !$A.util.isEmpty(errorMsg)){
										component.set("v.errorMsg",errorMsg);
										return;
									}
							}
							
						
	                   		if(msg.msgType !== 'success'){
                                
                                component.set("v.isError",true);
								$A.util.addClass(component.find("spinner"), "slds-hide");
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
		                                "message": msg.msgText,
                                        "duration" : 500
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
                                return;
	                   		}
                            else{
								
								
                                component.set("v.isError",false);
								
								if(!resultWrapper.isAccount)
									errorMsg = $A.get("$Label.smsfsc.SObject_Type_Error");
								else if(!resultWrapper.isConfigured)
									errorMsg = $A.get("$Label.smsfsc.Configuration_Error");
								else if(resultWrapper.hasNoAccess || (!resultWrapper.hasEditAccess && !resultWrapper.isSessionMuser))
								{
									
									errorMsg = (!$A.util.isUndefined(resultWrapper.networkId) && !$A.util.isEmpty(resultWrapper.networkId)) ? 
																$A.get("$Label.smsfsc.Enrollment_Error_Community") :  $A.get("$Label.smsfsc.Enrollment_Access_Error");
                                }
                                if(!$A.util.isUndefined(errorMsg) && !$A.util.isEmpty(errorMsg)){
                                    component.set("v.errorMsg",errorMsg);
                                    return;
                                }
                                else if(resultWrapper.isConfigured && resultWrapper.isAccount && !resultWrapper.hasNoAccess){
                                	
									
                                	component.set("v.showView",false);
                                	component.set("v.showEnroll",false);
									

                                	if(resultWrapper.isSessionMuser){
                                		$A.createComponent(
									        "c:SessionMViewCmp",
									        {
									            "recordId": recordId,
									            "viewCompute": component.get("v.viewCompute"),
									            "viewSessionMUpdate": component.get("v.viewSessionMUpdate"),
									            "viewActivities": component.get("v.viewActivities"),
									            "showView": component.get("v.showView"),
									            "showEnroll": component.get("v.showEnroll"),
									            "hideBack": component.get("v.hideBack")

									        },
									        function(viewEnrollContentBody){                
									            if (component.isValid()) {
									                var targetCmp = component.find('viewEnrollContentBody');
									                var body = targetCmp.get("v.body");
									                body.push(viewEnrollContentBody);
									                targetCmp.set("v.body", body);
									            }
									        }
									    );
                                	}
                                	else if(resultWrapper.hasEditAccess && !resultWrapper.isSessionMuser){
                                		$A.createComponent(
									        "c:SessionMEnrolCmp",
									        {
									            "recordId": recordId,
									            "showView": component.get("v.showView"),
									            "showEnroll": component.get("v.showEnroll")
									        },
									        function(viewEnrollContentBody){                
									            if (component.isValid()) {
									                var targetCmp = component.find('viewEnrollContentBody');
									                var body = targetCmp.get("v.body");
									                body.push(viewEnrollContentBody);
									                targetCmp.set("v.body", body);
									            }
									        }
									    );
                                	}
                            	}
                            }
						}

						$A.util.addClass(component.find("spinner"), "slds-hide");
				}
	        }
			
		});
		$A.enqueueAction(init);
	}
    else{
        
	 component.set("v.isError",false);
     component.set("v.errorMsg",$A.get("$Label.smsfsc.Loyalty_Data_Absent_Error"));
    }
},
checkTransactionCountAndRedirect : function(component, objtransactionOldCount) {
    
    var that = this;
    var checkTransactionCountAction = component.get("c.checkTransactionCount");
        
    checkTransactionCountAction.setParams({ accountId : objtransactionOldCount.smsfsc__Account__c });
    checkTransactionCountAction.setCallback(this, function(response) {
        
        var objtransactionNewCount = response.getReturnValue();
        if(response.getState() === "SUCCESS" && !$A.util.isUndefined(objtransactionNewCount) 
           && !$A.util.isEmpty(objtransactionNewCount)){
            
			
            if(objtransactionOldCount.cnt === objtransactionNewCount.cnt){
                window.setTimeout(
						$A.getCallback(function() {
                                       $A.util.addClass(component.find("spinner"), "slds-hide");

                            that.checkTransactionCountAndRedirect(component,objtransactionOldCount);
                        }),4000);
            }
            else{
            	var recordId = component.get("v.recordId");
        
        		if(!$A.util.isUndefined(recordId) && !$A.util.isEmpty(recordId)){

        			window.setTimeout(
		                $A.getCallback(function() {

		                    var SessionMCloseContainerEvent = $A.get("e.c:SessionMCloseContainerEvent");
			                SessionMCloseContainerEvent.setParams({ "accountId" : recordId});
			                SessionMCloseContainerEvent.fire();

		                 }), 1000
	                );
        		}
            	

                window.setTimeout(
						$A.getCallback(function() {
                            $A.util.addClass(component.find("spinner"), "slds-hide");          

                            that.doinitialize(component);
							
						}),2000);
            }
        }
    });
    $A.enqueueAction(checkTransactionCountAction);
}
})