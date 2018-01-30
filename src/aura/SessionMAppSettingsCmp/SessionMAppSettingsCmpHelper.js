({
    
    //This method is called when page loads initially
    initialise : function(component) {
        var init = component.get("c.init");
        init.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS"){
                component.set('v.configWrapper',response.getReturnValue());
            }
                
        });
        $A.enqueueAction(init); 
    },
    
    //This method is called when user clicks on Save Button
    save : function(component) {
        
        var settingsUtilityWrapper = component.get('v.configWrapper');
        var protectedsettings = settingsUtilityWrapper.protectedCustomSettings;
        var listsettings =  settingsUtilityWrapper.listCustomSettings;
       
        //Regular Expression for matching URL format
        var regex = new RegExp("^(https:\/\/www\.|https:\/\/)[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$");
        
        //Boolean which checks if field is blank or not
        var isBlankField = false;
        var isError = false;
        
        //Iterate through protected custom settings and remove unwanted spaces
        for (var field in protectedsettings){
            if(field.endsWith('__c')){

                var inputField = component.find(field);

                if(!$A.util.isUndefined(inputField) &&  !$A.util.isEmpty(inputField)){
                    
                    if(typeof protectedsettings[field] === 'string' || protectedsettings[field] instanceof String){
                        protectedsettings[field] = protectedsettings[field].trim();
                    }
                    
                    //Check if Fields are empty or not if empty set error
                    if($A.util.isUndefined(protectedsettings[field]) || $A.util.isEmpty(protectedsettings[field])){
                        inputField.set("v.errors", [{message: $A.get("$Label.smsfsc.Mandatory_Field_Error")}]);
                        $A.util.addClass(inputField, "slds-has-error");
                        isBlankField = true;
                    }
                    else if(typeof protectedsettings[field] !== 'boolean'){
                       inputField.set("v.errors", null);
                        $A.util.removeClass(inputField, "slds-has-error"); 
                    }
                }
            }
        }
        
        //Iterate through list customsettings and remove unwanted spaces
        for (var field in listsettings){
            if(field.endsWith('__c')){

                var inputFields = component.find(field);

                if(!$A.util.isUndefined(inputFields) &&  !$A.util.isEmpty(inputFields)){
                    
                    if(typeof listsettings[field] === 'string' || listsettings[field] instanceof String){
                        listsettings[field] = listsettings[field].trim();
                    }
                   
                    //Check if fields are empty if empty show appropriate erros
                    if($A.util.isUndefined(listsettings[field]) || $A.util.isEmpty(listsettings[field])){
                        inputFields.set("v.errors", [{message: $A.get("$Label.smsfsc.Mandatory_Field_Error")}]);
                        $A.util.addClass(inputFields, "slds-has-error");
                        isBlankField = true;
                    }
                    else if(typeof listsettings[field] !== 'boolean'){
                        inputFields.set("v.errors", null);
                        $A.util.removeClass(inputFields, "slds-has-error");  
                    }
                }
            }
        } 
        
        //If there are any blank fields show UI message from Custom Label
        if(isBlankField){
            isError = true;
            settingsUtilityWrapper.msg.msgText = $A.get("$Label.smsfsc.Mandatory_Field_Error");
        }
        
        //Check if entered URL matched REGEX if not show appropriate errors
        else if(!regex.test(protectedsettings.smsfsc__APIEndpoint__c)){
            
            settingsUtilityWrapper.msg.msgText = $A.get("$Label.smsfsc.Pattern_Mismatch_Error");
            var inputFieldAPIEndPoint = component.find('smsfsc__APIEndpoint__c');
            inputFieldAPIEndPoint.set("v.errors", [{message: settingsUtilityWrapper.msg.msgText}]);
            $A.util.addClass(inputFieldAPIEndPoint, "slds-has-error");
            isError = true;
            
        }
        //Check Page Size limits and if exceeded show appropriate errors
        else if(parseInt(listsettings.smsfsc__PageSize__c,10) < 1 || parseInt(listsettings.smsfsc__PageSize__c,10) > 50 || (listsettings.smsfsc__PageSize__c%1!==0)){
            
            settingsUtilityWrapper.msg.msgText = $A.get("$Label.smsfsc.PageSize_Error_Message");
            var inputFieldPageSize = component.find('smsfsc__PageSize__c');
            inputFieldPageSize.set("v.errors", [{message: settingsUtilityWrapper.msg.msgText}]);
            $A.util.addClass(inputFieldPageSize, "slds-has-error");
            isError = true;
            
        }
        
         //Check TimeOut limits and if exceeded show appropriate errors
        else if(parseInt(listsettings.smsfsc__SessionMTimeOut__c,10) < 1 || parseInt(listsettings.smsfsc__SessionMTimeOut__c,10) > 120000 || (listsettings.smsfsc__SessionMTimeOut__c%1!==0)){
                    
            settingsUtilityWrapper.msg.msgText = $A.get("$Label.smsfsc.TimeoutErrorMessage");
            var inputFieldTimeout = component.find('smsfsc__SessionMTimeOut__c');
            inputFieldTimeout.set("v.errors", [{message: settingsUtilityWrapper.msg.msgText}]);
            $A.util.addClass(inputFieldTimeout, "slds-has-error");
            isError = true;
        }
        
         //Check MaxActivityRecords limits and if exceeded show appropriate errors
        else if(parseInt(listsettings.smsfsc__MaxActivityRecords__c,10) < 1 || parseInt(listsettings.smsfsc__MaxActivityRecords__c,10) > 500 || (listsettings.smsfsc__MaxActivityRecords__c%1!==0)){
                    
            settingsUtilityWrapper.msg.msgText = $A.get("$Label.smsfsc.Max_Activity_Records_Message");
            var inputFieldTimeout = component.find('smsfsc__MaxActivityRecords__c');
            inputFieldTimeout.set("v.errors", [{message: settingsUtilityWrapper.msg.msgText}]);
            $A.util.addClass(inputFieldTimeout, "slds-has-error");
            isError = true;
        }
        
        //if isError is true create message component and show UI messages
        if(isError){
            $A.createComponent(
                "c:SessionMMessageCmp",
                {
                    "MessageInfo": settingsUtilityWrapper.msg
                },
                function(msgBox){                
                    if (component.isValid()) {
                        var targetCmp = component.find('MessageBody');
                        var body = targetCmp.get("v.body");
                        body.push(msgBox);
                        targetCmp.set("v.body", body);
                         window.setTimeout(

										$A.getCallback(function() {

													targetCmp.set("v.body", '');

											  }), 3000
                  							 );
                    }
                }
            );
        }else{
            
            //if all validations are passed call save method
            var validateAndSave = component.get("c.validateAndSave");
            validateAndSave.setParams({ "JSONstring" : JSON.stringify(settingsUtilityWrapper) });
            
            validateAndSave.setCallback(this, function(response) {
                if(response.getState() === "SUCCESS")
                    var msg = response.getReturnValue();
                    //shows error message below SessionMtoSalesforce Mapping Field
                    if(msg.msgText === $A.get("$Label.smsfsc.Mappings_Not_Found")){
                        var inputFieldMappingName = component.find('smsfsc__SessionMtoSalesforceMappingsAPIName__c');
                        inputFieldMappingName.set("v.errors", [{message: msg.msgText}]);
                        $A.util.addClass(inputFieldMappingName, "slds-has-error");
                    }
                
                    //Shows Error message below EmailFieldinAccounts field if data type is not Email
                    else if(msg.msgText === $A.get("$Label.smsfsc.Email_Field_DataType_Error")){
                        var inputFieldEmail = component.find('smsfsc__EmailFieldInAccounts__c');
                        inputFieldEmail.set("v.errors", [{message: msg.msgText}]);
                        $A.util.addClass(inputFieldEmail, "slds-has-error");
                    }
                
                    //Shows Error message below EmailFieldinAccounts field if field doesnt exist
                    else if(msg.msgText === $A.get("$Label.smsfsc.Field_Does_Not_Exist")){
                        var inputFieldError = component.find('smsfsc__EmailFieldInAccounts__c');
                        inputFieldError.set("v.errors", [{message: msg.msgText}]);
                        $A.util.addClass(inputFieldError, "slds-has-error");
                    }
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
                                  window.setTimeout(

										$A.getCallback(function() {

													targetCmp.set("v.body", '');

											  }), 3000
                  							 );
                              
                            }
                            
                        }
                    );
                
                //if save is successful go back to edit mode and save data in customsettings
                if(response.getReturnValue().msgType.toLowerCase() === 'success'){
                    component.set("v.isEditMode", true);

                    for (var protectedfield in protectedsettings){
                        
                        if(protectedfield.endsWith('__c') && 
                            typeof protectedsettings[protectedfield] !== 'boolean'){
                            
                                var inputFieldprotected = component.find(protectedfield);

                                if(!$A.util.isUndefined(inputFieldprotected) &&  !$A.util.isEmpty(inputFieldprotected)){

                                    inputFieldprotected.set("v.errors", null);
                                    //Remove errors from fields
                                    $A.util.removeClass(inputFieldprotected, "slds-has-error");
                                }
                        }
                        
                    }
                    
                    //Remove error messages and error border across fields
                    for (var unprotectedfield in listsettings){
                        
                        if(unprotectedfield.endsWith('__c') && 
                            typeof listsettings[unprotectedfield] !== 'boolean'){
                            
                            var inputFieldunprotected = component.find(unprotectedfield);

                            if(!$A.util.isUndefined(inputFieldunprotected) &&  !$A.util.isEmpty(inputFieldunprotected)){

                                inputFieldunprotected.set("v.errors", null);
                                $A.util.removeClass(inputFieldunprotected, "slds-has-error");

                            }
                        }
                        
                    }
                   this.initialise(component);
                   return;
                }
            });
            
            //Enqueue save action
            $A.enqueueAction(validateAndSave);
        }
        component.set('v.configWrapper',settingsUtilityWrapper); 
        
    }
})