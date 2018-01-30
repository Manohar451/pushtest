({
    /*
     * Initially this Method will be called and will fetch the records from the Salesforce Org 
     * Then we will hold all the records into the attribute of Lightning Component
     */
	initialize : function(component) {
        $A.util.removeClass(component.find("spinner"), "slds-hide");
        
		var init = component.get('c.init');
        init.setParams({ accountId : component.get('v.recordId') });
        
        init.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid()){
				var objActivityUtilWrapper = response.getReturnValue();
				
				if(!$A.util.isUndefined(objActivityUtilWrapper) && !$A.util.isEmpty(objActivityUtilWrapper)){

                    var msg  = objActivityUtilWrapper.msg;

					if(msg.msgType === 'success'){
					
						var activityList = objActivityUtilWrapper.activityList;
						var pageSize = objActivityUtilWrapper.pageSize;
                        component.set('v.maxActivitySize',objActivityUtilWrapper.maxActivitySize);

                        var paginatedActivityList = [];
                        for(var index= 0; index < (pageSize > activityList.length ? activityList.length : pageSize); index = index + 1){
                            paginatedActivityList.push(activityList[index]);
                        }

                        component.set("v.completeActivityList",activityList);
                        component.set('v.paginatedActivityList', paginatedActivityList);
                        component.set("v.pageSize",pageSize);
                        component.set("v.offset",pageSize);
                        component.set("v.isError",false);
                        
					}
					else{
                        
                        //If message type is error fetch error messages from custom labels and display them on UI
                        component.set("v.isError",true);
                        component.set("v.completeActivityList",[]);
                        component.set('v.paginatedActivityList', []);
                        component.set("v.pageSize",0);
                        component.set("v.offset",0);
                        if(msg.msgText.startsWith('#_$') || msg.msgText.endsWith('#_$') || msg.msgText.includes("#_$")){
                            
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

                        
                     //Check the theme and display message accordingly i.e if Lightnig show Toast else show UI message
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
					}
				}
            }
            $A.util.addClass(component.find("spinner"), "slds-hide");
        });
        $A.enqueueAction(init);
	},
    /*
     * Method will be called when use clicks on next button and performs the 
     * calculation to show the next set of records
     */
    next : function(component){
        var activityList = component.get("v.completeActivityList");
        var paginatedActivityList = [];
        var offset = component.get('v.offset');
        var pageSize = component.get("v.pageSize");
        var nextCount = offset + pageSize;
        
        for(var index = offset; index < (nextCount > activityList.length ? activityList.length : nextCount); index = index + 1){
            paginatedActivityList.push(activityList[index]);
        }
        component.set('v.paginatedActivityList', paginatedActivityList);
        component.set("v.offset",nextCount);
        
    },
    /*
     * Method will be called when use clicks on previous button and performs the 
     * calculation to show the previous set of records
     */
    previous : function(component){
       var activityList = component.get("v.completeActivityList");
        var paginatedActivityList = [];
        var offset = component.get('v.offset');
        var pageSize = component.get("v.pageSize");
        var previousCount = offset - pageSize;
        for(var index = previousCount - pageSize ; previousCount !== 0 && index< previousCount; index = index + 1){
            paginatedActivityList.push(activityList[index]);
        }
        component.set('v.paginatedActivityList', paginatedActivityList);
        component.set("v.offset",previousCount);
    },
    
    //The event when fired redirects to View Component
    reloadViewEvent: function(component) {
		var recordId = component.get("v.recordId");

        if(!$A.util.isUndefined(recordId) && !$A.util.isEmpty(recordId)){

            $A.util.addClass(component.find("spinner"), "slds-hide");
            var SessionMReloadViewEvent = $A.get("e.c:SessionMReloadViewEvent");
            SessionMReloadViewEvent.setParams({ "redirectionContext" : "Event Fired","accountId" :  recordId });
                                               
            SessionMReloadViewEvent.fire();
        }
		 
	},

    //This method is called when user clicks on Back Button
    goBack:function(component){
       component.set("v.isBackDisabled",true);
       var that = this;
       component.set("v.showActivity",false);
       that.reloadViewEvent(component);

    }
})