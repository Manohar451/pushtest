/**
* @Description Parser Class for Enroll response json string which is sent by SessionM platform when user performs callouts to SessionM API
* @author Saptaswa
* @date 07-11-2017
*/
public with sharing class EnrollResponse {
    
    public UserEnrolledResponse user;
    public String status;
    
/**
* @Description Inner Class of EnrollResponse class that contains all the user data received as its member variables
* @author Saptaswa
* @date 07-11-2017
*/
    public class UserEnrolledResponse {
        
        public String external_id;  //1284111
        public String id;   
        public String email;    //john.smith@test.com
        public String first_name;   //John
        public String last_name;    //Smith
        public String gender;   //m
        public String dob;  //1980-01-01
        public String city; //Boston
        public String state;    //MA
        public String zip;  //02021
        public String country;  //USA
        public String account_status;
        public List<Identifiers> identifiers;
        
    }
    
    
/**
* @Description Inner class of EnrollResponse that holds data for identifiers
* @author Saptaswa
* @date 07-11-2017
*/
    public class Identifiers{
        
        public String  external_id;
        public String  external_id_type;
    }
    
 /**
* @Description Method that parses the json string received as response by performing callouts to SessionM API
* @author Saptaswa
* @date 07-11-2017
* @return type EnrollResponse-->deserialized json response which is parsed accroding to EnrollResponse class
* @param json JSON String received from the Response
*/
    public static EnrollResponse parse(String json) {
        return (EnrollResponse) System.JSON.deserialize(json, EnrollResponse.class);
    }
    
    
}