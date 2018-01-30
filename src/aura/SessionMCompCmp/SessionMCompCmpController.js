({
    //This method is called when page loads initially
    doInit: function(component, event, helper) {
       
        helper.initialize(component);

    },
    
    //This method is used to add or remove points to user
    validateAndCompute: function(component, event, helper) {
		 helper.validateAndCompute(component);
    },
    


    //This method is called when Back button is clicked
    goBack: function(component, event, helper) {

       helper.goBack(component);
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
            
            component.set("v.showCompingComponent",false);
        }
        
    }

})