({

//This method is called when page loads initially
doinitialize : function(component) {
	var recordId = component.get("v.recordId");
    
    //Show spinner component
	$A.util.removeClass(component.find("spinner"), "slds-hide");
    
	if(!$A.util.isUndefined(recordId) && !$A.util.isEmpty(recordId)){
        
        
        component.set("v.viewSessionMUpdate",false);
        component.set("v.viewActivities",false);
        component.set("v.viewCompute",false); 
        
		var init = component.get("c.init");
        
		init.setParams({ accId : recordId });
		init.setCallback(this, function(response) {
	        if(response.getState() === "SUCCESS"){
                    //component.set("v.showView",true);
					var resultWrapper = response.getReturnValue();
					if(!$A.util.isUndefined(resultWrapper) && !$A.util.isEmpty(resultWrapper)){
						
							if(resultWrapper.objSessionMUser === null){
								var that = this;
								window.setTimeout(
									$A.getCallback(function() {
										that.doinitialize(component); //Call a method which fires an application event which loads the View Component
									}), 2000
								);
								return; 
							}
							else{
							
								var checkAccountEmail = component.get("c.checkAccountEmail");
        
								checkAccountEmail.setParams({ accId : recordId });
								
								checkAccountEmail.setCallback(this, function(response) {
									if(response.getState() === "SUCCESS"){
											component.set("v.showView",true);
											var accountEmail = response.getReturnValue();
											if(!$A.util.isUndefined(accountEmail) && !$A.util.isEmpty(accountEmail)){
													
													//var objViewUtilityWrapperObj= component.get("v.objViewUtilityWrapper");
												
													if(resultWrapper.objSessionMUser !== null){
														
														if(resultWrapper.objSessionMUser.smsfsc__Email__c !== accountEmail)
														{
															component.set("v.showEmailOutOfSyncMessage",true);
														}
													} 
												
										}
										$A.util.addClass(component.find("spinner"), "slds-hide");
									}
									
								});
								
								$A.enqueueAction(checkAccountEmail);
							}
							
							component.set("v.objViewUtilityWrapper",resultWrapper);
				}
                
	        }
			
		});
		$A.enqueueAction(init);
		
		
		
	}
},

//This method is called when user clicks on Comp Button
viewComputePoints : function(component) {
    
    //Disable ViewComponent
    component.set("v.showView",false);
    //Disable UpdateComponent
    component.set("v.viewSessionMUpdate",false);
    //Disable Activities Component
    component.set("v.viewActivities",false);
    //Enable Comping Component
    component.set("v.viewCompute",true);
    
    //Dynamically create comping component and pass recordId
    $A.createComponent(
        "c:SessionMCompCmp",
        {
            "recordId": component.get('v.recordId')
        },
        function(msgBox){                
            if (component.isValid()) {
                var targetCmp = component.find('CompBody');
                var body = targetCmp.get("v.body");
                body.push(msgBox);
                targetCmp.set("v.body", body);
            }
        }
    );
},
    
//This method is called when user clicks on Update Button
viewSessionMUpdate : function(component) {
    //Disable Comping Component
    component.set("v.viewCompute",false);
    //Disable View
    component.set("v.showView",false);
    //Disable Activity
    component.set("v.viewActivities",false);
    //Enable Update
    component.set("v.viewSessionMUpdate",true);
    
    //Dynamically create Update Component
    $A.createComponent(
        "c:SessionMUpdateCmp",
        {
            "recordId": component.get('v.recordId')
        },
        function(msgBox){                
            if (component.isValid()) {
                var targetCmp = component.find('UpdateBody');
                var body = targetCmp.get("v.body");
                body.push(msgBox);
                targetCmp.set("v.body", body);
            }
        }
    );
},
    
//This method is called when user click on Activities Button
viewActivities : function(component) {
    
    //Disable Comp Component
    component.set("v.viewCompute",false);
    //Disable View
    component.set("v.showView",false);
    //Disable Update
    component.set("v.viewSessionMUpdate",false);
    //Show Activity
    component.set("v.viewActivities",true);
    
    //Dynamically create component and pass recordId as parameter
    $A.createComponent(
        "c:SessionMActivityCmp",
        {
            "recordId": component.get('v.recordId')
        },
        function(msgBox){                
            if (component.isValid()) {
                var targetCmp = component.find('ActivityBody');
                var body = targetCmp.get("v.body");
                body.push(msgBox);
                targetCmp.set("v.body", body);
            }
        }
    );
},

})