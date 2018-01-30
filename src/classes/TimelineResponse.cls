/**
* @Description  Parser Class for json string which is sent by SessionM platform when user performs callouts to SessionM Activity API
* @author Saptaswa
* @date 10-12-2017
*/

public with sharing class TimelineResponse {
    
    public List<TimeLineResult> result{get;set;}
    public String status {get;set;}
    public TransactionError errors;


/**
* @Description Inner Class of TimelineResponse Class which has variables that are displayed on Activity Page as its memeber variables
* @author Saptaswa
* @date 10-12-2017
*/
    public class TimeLineResult{
        public List<Context> contexts{get;set;}
        public EventStreamPayload event_stream_payload{get;set;}
        // below is used for display.
        public Long timestamp {get;set;}

    }

    
/**
* @Description Inner class of TimelineResponse class that handles error response json sent by SessionM platform 
* @author Saptaswa
* @date 10-12-2017
*/
     public class TransactionError{
        
      public String code;
      public string message;
    
    }
    
/**
* @Description Inner class of TimelineResponse that has properies of id,name and value to display as its member variables
* @author Saptaswa
* @date 10-12-2017
*/

    public class Context{
        public Integer id {get;set;}
        public String name {get;set;}
        // value is used for display
        public String value {get;set;}
    }

/**
* @Description Inner class that has type of event as its member variable
* @author Saptaswa 
* @date 10-12-2017
*/
    public class EventStreamPayload{

        // below is used for display
        public  String event_type_name {get;set;}

    }
   
    
/**
* @Description Method That parses the json string received in response from SessionMAPI
* @author Saptaswa
* @date 10-12-2017
* @return type TimelineResponse-->Wrapper class of TimelineResponse class
* @param json JSON String received from the Response
*/
    public static TimelineResponse parse(String json) {
        return (TimelineResponse) System.JSON.deserialize(json, TimelineResponse.class);
    }
    

}