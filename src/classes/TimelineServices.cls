/**
* @Description Service Class which drives the functionality to fetch Activity records for the SessionMuser
* @author Saptaswa
* @date 20-12-2017
*/


public with sharing class TimelineServices {
    
/**
* @Description This method returns the endpoint URL for callout to Activity API in the SessionM platform
* @author Saptaswa
* @date 20-12-2017
* @See Generalutility
* @return String-->URL used to fetch the Activity records
* @param sessionMId SessionMId of the User 
* @param count Number of records to be fecthed 
*/
    private static String getUrlForTimeline(String sessionMId,Integer count){
        
        String endPointUrl = GeneralUtility.correctEndPointURL()+
                             GeneralConstants.CONST_PRIV_STRING_FOR_CALL_OUT+
                             GeneralUtility.API_VERSION+
                             GeneralConstants.CONST_APPS_STRING_FOR_CALL_OUT+
                             GeneralUtility.API_KEY+
                             GeneralConstants.CONST_SESSIONM_USERID_PREFIX_URL_PATH +
                             sessionMId+
                             GeneralConstants.CONST_TIMELINE_URL_PATH +
                             String.valueOf(count) +
                             GeneralConstants.CONST_TIMELINE_CONTEXT_SLUG_QS
                             ;
                             
        return endPointUrl;

    }
    
/**
* @Description This method fetches activity data from SessionM platform
* @author Saptaswa
* @date 20-12-2017
* @return ActivityUtilityWrapper-->Wrapper object that holds all the activity records
* @param accountId AccountId of the account record
* @param count number of records to be fetched
*/

    public static ActivityUtilityWrapper fetchActivities(Id accountId,Integer count){
		
        HttpResponse response = null;
        List<Message> postMsgs = new  List<Message>();
        APIResult postResultToReturn = new  APIResult(true, postMsgs);
        Exception exp = null;
        TimelineResponse responseTimeline =null;
        ActivityUtilityWrapper activityUtilityWrpr = new ActivityUtilityWrapper();
        activityUtilityWrpr.activityList= new List<TimeLineWrapperDetails>(); 

        try{

        	  smsfsc__SessionMUser__c sessionMUserObj = GeneralUtility.getSessionMUserRecordByAccountId(accountId);
        
        	  
		
			 if(sessionMUserObj != Null){
				 
				 response = GeneralUtility.makeCalloutToSessionM(getUrlForTimeline(sessionMUserObj.smsfsc__SessionMID__c,count), GeneralConstants.CONST_GET_METHOD, GeneralUtility.getCommonHeadersForRequest(), Null);
				 
				 if(response != null && 
				 	response.getBody() != null &&
					!String.isEmpty(response.getBody()) && 
					response.getStatusCode() == 200  &&
				 	response.getStatus() == GeneralConstants.CONST_STATUS_OK){ 
				 
					responseTimeline  = TimelineResponse.parse(response.getBody());

					if(responseTimeline != null && responseTimeline.result != null){
						
						List<TimeLineWrapperDetails>  timelines = new List<TimeLineWrapperDetails>();
						
						Integer counter = 1;
						TimeLineWrapperDetails timelineWrapper = null;

						for(TimelineResponse.TimeLineResult timelineResult :responseTimeline.result){

							timelineWrapper = new TimeLineWrapperDetails();
							timelineWrapper.index = counter;
							timelineWrapper.eventTypeName = timelineResult.event_stream_payload != null  ? 
															timelineResult.event_stream_payload.event_type_name : '';
							timelineWrapper.type = timelineResult.contexts.isEmpty() ? '':timelineResult.contexts[0].value;
							timelineWrapper.timestamp = timelineResult.timestamp != null ? 
														DateTime.newInstance(Long.valueOf(String.ValueOf(timelineResult.timestamp))).format():
														'';
							timelines.add(timelineWrapper);

							counter = counter + 1;
						}
						
						activityUtilityWrpr.activityList = timelines;
						
					}
					
				 }
				 postResultToReturn.isSuccess = true;
			}

		}catch(Exception e){
			
			  system.debug('Exception error is : '+e.getMessage());
              exp = e;
              postResultToReturn.isSuccess = false;
			
		}


	  if(responseTimeline != null){
			
            /***In case of any native errors or erroneous response received from SessionM Platform handle and display those 
             * errors in the UI****/
            GeneralUtility.handleHttpErrors(response,responseTimeline.status, 
            								postResultToReturn,exp,GeneralConstants.CONST_SERVICE_TYPE_TIMELINE);

	  }else{
      		 /***In case of any exceptions handle and display corresponding 
             * errors in the UI****/
            GeneralUtility.handleHttpErrors(response,null, postResultToReturn,exp,
        								GeneralConstants.CONST_SERVICE_TYPE_TIMELINE);

      }



        activityUtilityWrpr.msg = postResultToReturn.messages.get(0);


        return activityUtilityWrpr;
    }
}