({
    //This method is called when page loads initially
    initialize: function(component) {

        
        var initAction = component.get("c.init");
        $A.util.removeClass(component.find("spinner"), "slds-hide");

        initAction.setParams({
            accountId: component.get("v.recordId")
        });

        initAction.setCallback(this, function(response) {
			
            if (response.getState() === 'SUCCESS' && component.isValid()) {
				component.set("v.isBackDisabled",false);
                var objCompingUtilWrapper = response.getReturnValue();
               
                if (!$A.util.isUndefined(objCompingUtilWrapper) && !$A.util.isEmpty(objCompingUtilWrapper)) {
					
                    component.set("v.objCompWrapper", objCompingUtilWrapper);
                    
                    //this part of code displays ui message and disables comp button for suspended users
                    component.set("v.isCompingDisabled", objCompingUtilWrapper.isSuspendedSessionMUser);
					
                    //This part of code populates the picklist field with the values in picklist field of Transaction object
                    if (!$A.util.isUndefined(objCompingUtilWrapper.pickListValues) && !$A.util.isEmpty(objCompingUtilWrapper.pickListValues)) {

                        var reasonCodepicklistOptions=[];
                        var reasonCodePickListValues = objCompingUtilWrapper.pickListValues;
						
                        reasonCodepicklistOptions.push({
                            class: "optionClass",
                            label: "--- None ---",
                            value: ""
                        });

                        for (var index = 0; index < reasonCodePickListValues.length; index  = index + 1) {
                            reasonCodepicklistOptions.push({
                                class: "optionClass",
                                label: reasonCodePickListValues[index],
                                value: reasonCodePickListValues[index]
                            });

                        }

                        component.find("reasonCodes").set("v.options", reasonCodepicklistOptions);
                    }

 

                }

            }
            
            //hiding the spinner
            $A.util.addClass(component.find("spinner"), "slds-hide");

        });
        
        //Calling or enqueuing the init action
        $A.enqueueAction(initAction);

    },

    //This method is called on click of Back Button
    goBack: function(component) {
        var recordId = component.get("v.recordId");

        if(!$A.util.isUndefined(recordId) && !$A.util.isEmpty(recordId)){
            //disable backbutton and hide the comping componenet
            component.set("v.isBackDisabled", true);
            component.set("v.showCompingComponent", false);

            var reloadViewEvent = $A.get("e.c:SessionMReloadViewEvent");
            reloadViewEvent.setParams({
                "redirectionContext": "Event Fired","accountId" :  recordId
            });
            
            //finally fire the reloadview event on click of back button
            reloadViewEvent.fire();
        }
    },

  
   //Generic method to display UI method and takes component,isLightning,message as its parameters
    processmessage: function(component, isLightning, message) {

        //if theme is "Lightning" show toast messages
        if (isLightning) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": message.msgType,
                "message": message.msgText,
                "duration": 500
            });
            toastEvent.fire();
        } else {
            $A.createComponent(
                "c:SessionMMessageCmp", {
                    "MessageInfo": message
                },
                function(msgBox) {
                    if (component.isValid()) {
                        var targetCmp = component.find('MessageBody');
                        var body = targetCmp.get("v.body");
                        body.push(msgBox);
                        targetCmp.set("v.body", body);
                    }
                }
            );

        }
        
        //if message type is success disable comp button,back button and call update view event
        if (message.msgType.toLowerCase() === 'success') {
			
            component.set("v.isCompingDisabled", true);
            component.set("v.isBackDisabled", true);
            $A.util.addClass(component.find("spinner"), "slds-hide");

            window.setTimeout(

                $A.getCallback(function() {

                    var objCompWrapper = component.get("v.objCompWrapper");

                    var recordId = component.get("v.recordId");

                    if(!$A.util.isUndefined(recordId) && !$A.util.isEmpty(recordId)){

                        var SessionMTransactionCountEvent = $A.get("e.c:SessionMTransactionCountEvent");
                        SessionMTransactionCountEvent.setParams({
                            "transactionCount": !$A.util.isUndefined(objCompWrapper.transactionsAggregate) && !$A.util.isEmpty(objCompWrapper.transactionsAggregate) ? objCompWrapper.transactionsAggregate : {
                                cnt: 0,
                                smsfsc__Account__c: objCompWrapper.accountId
                            },"accountId" :  recordId
                        });
                        component.set("v.showCompingComponent", false);
                        SessionMTransactionCountEvent.fire();

                    }

                }), 2500
            );
        }

    },

    //this method is used to add or remove points to the user
    validateAndCompute: function(component) {

        var that = this;
        
        var pointsComponent = component.find("loyalityPoints");
        var reasonCode = component.find("reasonCodes");
        var compingPointsValue = pointsComponent.get("v.value");
        var reasonCodeValue = reasonCode.get("v.value");
        
        //hide or remove fieldlevel errors
        $A.util.removeClass(pointsComponent, 'slds-has-error');
        $A.util.removeClass(reasonCode, 'slds-has-error');
        $A.util.removeClass(component.find("spinner"), "slds-hide");
        
        pointsComponent.set("v.errors", null);
        reasonCode.set("v.errors", null);
        
        component.set("v.isCompingDisabled", true);
        component.set("v.showMessageComponent", false);
        
        //JS Object - msg and fieldId
		var validationMessageInfo;
		
        //validates the values entered and assigns proper error message to be displayed
        if($A.util.isUndefined(compingPointsValue) || $A.util.isEmpty(compingPointsValue)){
            validationMessageInfo = {msg : $A.get("$Label.smsfsc.PointsField_Empty_Error_Message"), fieldId :"loyalityPoints" };
        }
        else if($A.util.isUndefined(reasonCodeValue) || $A.util.isEmpty(reasonCodeValue)){
            validationMessageInfo = {msg : $A.get("$Label.smsfsc.ReasonCode_Error_Message"), fieldId :"reasonCodes" };
        }
        else if(compingPointsValue === 0){
             validationMessageInfo =  {msg : $A.get("$Label.smsfsc.ZeroPointsErrorMessage"), fieldId :"loyalityPoints" };
        }
        else if(compingPointsValue !== null && compingPointsValue % 1 !== 0){
            validationMessageInfo = {msg : $A.get("$Label.smsfsc.PointsValidationError"), fieldId :"loyalityPoints" };   
        }
 
		//if validationmessageInfo object is empty show error border and error messages at fields
		if (!$A.util.isUndefined(validationMessageInfo) && !$A.util.isEmpty(validationMessageInfo)) {
			  $A.util.addClass(component.find(validationMessageInfo.fieldId), 'slds-has-error');
	          component.find(validationMessageInfo.fieldId).set("v.errors", [{
	            message: validationMessageInfo.msg
	
	          }]);
			
			component.set("v.isCompingDisabled", false);
            $A.util.addClass(component.find("spinner"), "slds-hide");
			return;
		}
        //If all validations are passed call the computePointsAction action
        else if (reasonCodeValue !== 'None') {

            var objCompWrapper = component.get("v.objCompWrapper");
            objCompWrapper.accountId = component.get("v.recordId");
            var computePointsAction = component.get("c.computePoints");
			
            computePointsAction.setParams({

                //This method is used to covert object into JSON String
                compingWrapper: JSON.stringify(objCompWrapper)
            });

            computePointsAction.setCallback(this, function(response) {

                var state = response.getState();
                
                if (component.isValid() && state === "SUCCESS") {
					
                    //Enable the messagecomponent to show UI messages
                    component.set("v.showMessageComponent", true);
					
                    var msg = response.getReturnValue();
					
                    if (!$A.util.isUndefined(msg) && !$A.util.isEmpty(msg)) {

                        var isLightning = msg.experienceType === 'LIGHTNING' ? true : false;
                        
                        //if messagetype is not success get the error messages from customlabels and show on UI
                        
                        if (msg.msgType.toLowerCase() !== 'success') {
                            
                            //Stop the Spinner and also enable comp button
                            $A.util.addClass(component.find("spinner"), "slds-hide");
                            component.set("v.isCompingDisabled", false);
                           if(msg.msgText.startsWith('#_$') || msg.msgText.endsWith('#_$') || msg.msgText.includes("#_$")){
                            
							/***** Do not remove these commented lines*****/
                            //hints for labels
                            // $Label.smsfsc.User_Updated_Success
                            // $Label.smsfsc.user_not_found  
                            // $Label.smsfsc.Email_Address_Update_Error
                            // $Label.smsfsc.external_id_already_used
                            // $Label.smsfsc.internal_server_error  
                            // $Label.smsfsc.invalid_api_key
                            // $Label.smsfsc.incorrect_api_params
                            // $Label.smsfsc.SessionM_Internal_Error  
                            // $Label.smsfsc.validation
                            // $Label.smsfsc.Validation_Error_Email
                            // $Label.smsfsc.no_stream_view_found
							 //$Label.smsfsc.incorrect_api_params
                                // $Label.smsfsc.SessionM_Internal_Error 
                                //  $Label.smsfsc.invalid_api_key
                                // $Label.smsfsc.validation
                                //$Label.smsfsc.internal_server_error
                                //$Label.smsfsc.access_denied

                           
                            
                            var codeAndMessageArray = msg.msgText.split("#_$");
                           
                            
                            
                            if(($A.util.isEmpty(codeAndMessageArray[1])) || ( $A.util.isUndefinedOrNull(codeAndMessageArray[1])))
                            {
                                 
                                  
                                
                                    msg.msgText = $A.get("$Label.smsfsc."+codeAndMessageArray[0]);
                            }
                            else if(($A.util.isEmpty(codeAndMessageArray[0])) || ( $A.util.isUndefinedOrNull(codeAndMessageArray[0]))){
                                msg.msgText = codeAndMessageArray[1];
                               
                            }
                            
                            else
                            {
                                
                              
                              var text = $A.get("$Label.smsfsc."+codeAndMessageArray[0]);
                              
                              if(($A.util.isEmpty(text)) || ( $A.util.isUndefinedOrNull(text)) ||  text.includes('$Label') || text.startsWith('['))
                              {
                                  
                                
                                 
                                  msg.msgText= codeAndMessageArray[1];
                              }
                                
                                else
                                {
                                    
                                   msg.msgText=text; 
                                }
                            
                            }
                        }

                        }

                        that.processmessage(component, isLightning, msg);
						
                    }
                }
            });
           
            //Finally call the computesPoints Action
            $A.enqueueAction(computePointsAction);

        }
    }



})