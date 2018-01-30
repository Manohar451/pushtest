({
    
    //This method is called when page loads initially
	doInit: function(component, event, helper) {
        component.set('v.showUpdate',true);
    	helper.doInitialize(component);
    },
    
    //Method fired when user clicks Save button
    saveRecord : function(component, event, helper) {
        component.set('v.makeDisabled',true);
        helper.saveRecord(component);
    },
	
    //Method called on succesful save of updated user data
    doUpdate: function(component, event, helper) {
        helper.doUpdate(component);
    },
    
    //Method called when Back button is clicked
    goBack : function(component, event, helper) {
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
            
            component.set("v.showUpdate",false);
        }
        
    }
})