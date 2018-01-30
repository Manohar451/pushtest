({
    
    //Method called when page loads initially
	doInit : function(component, event, helper) {
		helper.initialise(component);
	},
    
    //Method called when user clicks Save Button
	save : function(component, event, helper) {
		helper.save(component);
        
	},
    
    //Method called when user clicks on Edit Button
    allowEdit: function(component){
		 component.set("v.isEditMode", false);
    },
    
    //Method called when user clicks on ReasonCodes Button
    fetchReasonCodePickListValues : function(){
		window.open("/apex/SessionMFetchReasonCodesPage");
    },
    
    //Method called when user clicks on Back Button
    goBack: function() {
		window.history.go(-1);
    },
    
    //Method called when user clicks on Cancel Button
    cancel: function() {
		window.location.reload();
	}
})