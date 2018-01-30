/**
* @Description Parser Class for response json string which is sent by SessionM platform when user performs callouts to SessionM points API
* @author Manohar Pandurangi
* @date 11-11-2017
*/

public with sharing class PointsResponse {
    
    public TransactionResponse user;
    public String status;
    public TransactionError errors;
    @AuraEnabled
    public APIResult apiResult;
    
  /**
* @Description Inner class of PointsResponse that holds the userId,points and testpoints as its member variables
* @author Manohar Pandurangi
* @date 11-11-2017
*/

    public class TransactionResponse{
        
        public String user_id;
        public Integer available_points;
        public Integer test_points;
    }
    
    
 /**
* @Description Inner class of PointsResponse that conatains member variables which is used to handle error response
* @author Manohar Pandurangi
* @date 11-11-2017
*/

    public class TransactionError{
        
      public TransactionPoints transaction_z;
      public String code;
      public string message;
    
    }
    
    
 /**
* @Description Inner class of PointsResponse that holds the error message and validation code received from SessionM API
* @author Manohar Pandurangi
* @date 11-11-2017
*/

    public class TransactionPoints{
        public string points;
        public string base;
    }
    
    
    /**
* @Description Parser method which parses the json response received by performing callouts to SessionM points API
* @author Manohar Pandurangi
* @date 11-11-2017
* @return PointsResponse-->Deserialized json response received from callouts
* @param json Response String which is received from API Request
*/

    public static PointsResponse parse(String json) {
        return (PointsResponse) System.JSON.deserialize(json, PointsResponse.class);
    }
    
}