({
	/* Function to fetch the data entered by User  
	 * in Email Field of the corresponding 
	   Account record
	 */
	doInit: function(component, event, helper) {      
    // Fetch the account email from the Apex controller   
    helper.InitializeComponent(component); 
    
    },
    
    
	/* Function to navigate 
	 * back to the previous screen
	 */
    goback : function(component) {
       component.set("v.isLoading", false);
       window.history.go(-1); 
	},
    
    
    /* Function to Enroll user 
     * 
     */
    enrollUser : function(component, event, helper) {
    
    	helper.doenrollUser(component);
    	
	},
    //This is fired when any update on the account record occurs
    sessionMCloseContainer :function(component, event) {
		
        var accountId = event.getParam("accountId");
		console.log('Account Id : ',accountId);
        var recordId = component.get("v.recordId");

        if(!$A.util.isUndefined(accountId) 
            && !$A.util.isEmpty(accountId)
            && !$A.util.isUndefined(recordId)
            && !$A.util.isEmpty(recordId)
            && accountId === recordId
            ){
           
            component.set("v.showEnroll",false);
        }
        
    }
})