({
    //This method is init method of message component
    doInit : function(component) {
		var msg = component.get('v.MessageInfo');
        //Find the experience type i.e Theme of User
        if(!msg.isCommunity && msg.experienceType === 'CLASSIC'){
            if(sforce.console.isInConsole()){
                msg.experienceType = 'SF1';
            } 	
        }
        
       
	},
    
    //Method called when user clicks on close Button of Message
	closeUIMessage : function(component) {
		$A.util.addClass(component.find('messageId'), 'slds-hide');
	}
})