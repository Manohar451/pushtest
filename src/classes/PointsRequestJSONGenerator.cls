/**
* @Description This class is used to create the json request which is sent as body when performing callout to SessionM points API
* @author Manohar Pandurangi
* @date 11-11-2107
*/
 
public with sharing class PointsRequestJSONGenerator {
    
/**
* @Description This method is used to create the json request which is sent as body when performing callout to SessionM points API
* @author Manohar Pandurangi
* @date 11-11-2017
* @return type String
* @param points Points that are added 
* @param userId Id of the user 
* @param freeForm The reason why he is being added/removed points 
*/
 
   public static String generatePointsJsonRequest(Long points,String userId,String freeForm) {
        // Create a JSONGenerator object.
        // Pass true to the constructor for pretty print formatting.
        JSONGenerator pointsRequestJson = JSON.createGenerator(true);        
        // Create a list of integers to write to the JSON string.
        
        // Create an object to write to the JSON string.
        PointsRequestHelper pointsReqHelper = new PointsRequestHelper(points,userId,freeForm);
       
        // Write data to the JSON string.
        pointsRequestJson.writeStartObject();
        
        pointsRequestJson.writeFieldName('transaction');
        
        pointsRequestJson.writeObject(pointsReqHelper);
        
        pointsRequestJson.writeEndObject();
      // Get the JSON string.
        return pointsRequestJson.getAsString();
        
    }  
}