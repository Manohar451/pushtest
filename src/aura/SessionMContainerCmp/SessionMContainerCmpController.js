({
    
    //This method is called when page initially loads
    doInit: function(component, event, helper) {
       
        
        helper.doinitialize(component);
        
    },
    /* Function to navigate 
	 * back to the previous screen
	 */
    goback : function(component) {
       $A.util.addClass(component.find("spinner"), "slds-hide");
       window.history.go(-1); 
	},
    
    //Handles Container Event Fired to display View or Enroll
    sessionMContainerEventHandler :function(component, event, helper) {

        var accountId = event.getParam("accountId");
        var recordId = component.get("v.recordId");

        if(!$A.util.isUndefined(accountId) 
            && !$A.util.isEmpty(accountId)
            && !$A.util.isUndefined(recordId)
            && !$A.util.isEmpty(recordId)
            && accountId === recordId
            )
        {
            $A.util.removeClass(component.find("spinner"), "slds-hide");
            var redirectionContext = event.getParam("redirectionContext");
            //Hide Update
            component.set("v.viewSessionMUpdate",false);
            //Hide Activities
            component.set("v.viewActivities",false);
            //Hide Comping
            component.set("v.viewCompute",false); 
            if(redirectionContext ==="Event Fired From Update")
            {
                window.setTimeout(
                $A.getCallback(function() {
                        helper.initializeFromUpdate(component);
                 }), 1000
                
                );
            }
            else{
                helper.doinitialize(component); 
            }

        }

          
    },
    
    //Event fired from Update that loads View
	sessionMReloadViewEventHanlder :function(component, event, helper) {

        var accountId = event.getParam("accountId");
        var recordId = component.get("v.recordId");

         if(!$A.util.isUndefined(accountId) 
            && !$A.util.isEmpty(accountId)
            && !$A.util.isUndefined(recordId)
            && !$A.util.isEmpty(recordId)
            && accountId === recordId
            )
        {

            var redirectionContext = event.getParam("redirectionContext");
         	component.set("v.viewSessionMUpdate",false);
            component.set("v.viewActivities",false);
            component.set("v.viewCompute",false); 
            if(redirectionContext ==="Event Fired From Update")
            {
                helper.initializeFromUpdate(component);
            }
            else{
                helper.doinitializeView(component);
            }
        } 
    },
    
    //This is fired when Comping is Succesfully done
    checkTransactionCountAndRedirect :function(component, event, helper) {
        
        var accountId = event.getParam("accountId");
        var recordId = component.get("v.recordId");

        if(!$A.util.isUndefined(accountId) 
            && !$A.util.isEmpty(accountId)
            && !$A.util.isUndefined(recordId)
            && !$A.util.isEmpty(recordId)
            && accountId === recordId
            )
        {
            //Hide Spinner
    		$A.util.removeClass(component.find("spinner"), "slds-hide");
            //Hide comping component
    		component.set("v.viewCompute",false);
            helper.checkTransactionCountAndRedirect(component,event.getParam("transactionCount"));
        }
    },

    //This is fired when any update on the account record occurs
    refreshContainer :function(component, event, helper) {

        var recordId = component.get("v.recordId");
		component.set("v.errorMsg",'');
		component.set("v.isError",true);
		component.set("v.hideBack",false);
		
        
        if(!$A.util.isUndefined(recordId) && !$A.util.isEmpty(recordId)){

            var workspaceAPI = component.find("workspace");
			workspaceAPI.isConsoleNavigation().then(function(response) {
                
            if(response === false)
            {
               window.setTimeout(
                    $A.getCallback(function() {

                        var SessionMCloseContainerEvent = $A.get("e.c:SessionMCloseContainerEvent");
                        SessionMCloseContainerEvent.setParams({ "accountId" : recordId});
                        SessionMCloseContainerEvent.fire();

                     }), 1500
                );
        
                window.setTimeout(
                    $A.getCallback(function() {
        
                            helper.doinitialize(component);
        
                     }), 2000 
                );
        
            }else if(response === true){
            
                workspaceAPI.getFocusedTabInfo().then(function(tabResponse) {
                    console.log(recordId,'-------tabResponse.recordId === recordId--------',tabResponse.recordId);        
                    
                    if(!$A.util.isUndefined(tabResponse) 
                        && !$A.util.isEmpty(tabResponse) 
                        && !$A.util.isUndefined(tabResponse) 
                        && !$A.util.isEmpty(tabResponse.recordId)
                        && tabResponse.recordId === recordId){
        
                        window.setTimeout(
                            $A.getCallback(function() {
								
								
                                var SessionMCloseContainerEvent = $A.get("e.c:SessionMCloseContainerEvent");
                                SessionMCloseContainerEvent.setParams({ "accountId" : recordId});
                                SessionMCloseContainerEvent.fire();

                             }), 1000
                        );
        
                        window.setTimeout(
                            $A.getCallback(function() {
									
                                    helper.doinitialize(component);
        
                             }), 2000 
                        );
                    }
        
                })
                .catch(function(error) {
                   console.log(error);
                });
            }
        })
        .catch(function(error) {
            console.log(error);
           
        });
            
      }
        
    }
})