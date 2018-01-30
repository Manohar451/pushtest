({
    
    //This method is called when the page loads initially
    doInit: function (component, event, helper) {

        //Setting the table headers
        component.set('v.dataTableHeaders', [
            {label: $A.get("$Label.smsfsc.Activities_Column_Header_Name"), fieldName: 'eventTypeName', type: 'text', sortable : false},
            {label: $A.get("$Label.smsfsc.Activities_Column_Header_Type"), fieldName: 'type', type: 'text', sortable : false},
            {label: $A.get("$Label.smsfsc.Activities_Column_Header_Date"), fieldName: 'timestamp', type: 'text', sortable : false}
        ]);
        helper.initialize(component);
     },
    
    //This method is called when user clicks on Next button
	 next: function (component, event, helper) {

		helper.next(component, event);
	},
    
    //This method is called when user clicks on Previous Button
    previous: function (component, event, helper) {

    	helper.previous(component, event);
    },
    
    //This method is called when user clicks on Back Button
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
            
            component.set("v.showActivity",false);
        }
        
    }
})