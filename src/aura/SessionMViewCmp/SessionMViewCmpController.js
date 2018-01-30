({
    //This method is called when loads initially
	doInit: function(component, event, helper) {
    	helper.doinitialize(component); 
	},
    
    //This method is called when user clicks on Comp button and shows Comping Component
	viewComputePoints:function(component, event, helper) {
        helper.viewComputePoints(component);  	    
	},
    
     //This method is called when user clicks on Update button and shows Update Component
	viewSessionMUpdate :function(component, event, helper) {
         helper.viewSessionMUpdate(component);
	},
    
     //This method is called when user clicks on Comp button and shows Comping Component
	viewActivities :function(component, event, helper) {
         helper.viewActivities(component);
	},
    
    //This method is called When user clicks on Back button
	goback : function() {
       window.history.back();
	},
    //This is fired when any update on the account record occurs
    sessionMCloseContainer :function(component, event) {
        var accountId = event.getParam("accountId");
        var recordId = component.get("v.recordId");

        if(!$A.util.isUndefined(accountId) 
            && !$A.util.isEmpty(accountId)
            && !$A.util.isUndefined(recordId)
            && !$A.util.isEmpty(recordId)
            && accountId === recordId
            ){
            
            component.set("v.showView",false);
        }
        
    }
})