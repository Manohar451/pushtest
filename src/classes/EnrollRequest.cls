/**
* @Description This class is used to create the Json body which is sent as body to SessionM platform while performing callout to Enroll user in SessionM platform
* @author Saptaswa
* @date 07-11-2017
*/

public with sharing class EnrollRequest {
    
    public UserToEnroll user;
    private static final String EXT_ID_TYPE = 'sfsc';
    
/**
* @Description Constructor method for EnrollRequest which will set the values of all members of the class
* @author Saptaswa
* @date 07-11-2017
* @param externalId ExternalId of the user 
* @param email Email of the user 
* @param firstName firstname of the user 
* @param lastName lastname of the user 
* @param gender Gender 
* @param dob Date-of-Birth
* @param city City of the user 
* @param state State
* @param zip ZipCode 
* @param country CountryName 
*/

    public EnrollRequest(String externalId,
                         String email,String firstName,String lastName, 
                         String gender,String dob,String city,String state,
                         String zip,String country){
                             
         UserToEnroll user = new UserToEnroll();
         user.external_id = externalId;
         user.external_id_type = EXT_ID_TYPE; 
         user.email =email;
         user.first_name =firstName;
         user.last_name = lastName;
         user.gender = gender;
         user.dob = dob;
         user.city = city;
         user.state =state;
         user.zip = zip;
         user.country = country; 
         user.opted_in = true;
         
         this.user = user;           
                             
                             
    }
    
    
/**
* @Description Inner class of EnrollRequest class that has all data of the user
* @author Saptaswa
* @date 07-11-2017
*/
    
    public class UserToEnroll {
        
        public String external_id;  //1284111
        public String external_id_type; //facebook
        public String email;    //john.smith@test.com
        public String first_name;   //John
        public String last_name;    //Smith
        public String gender;   //m
        public String dob;  //1980-01-01
        public String city; //Boston
        public String state;    //MA
        public String zip;  //02021
        public String country;  //USA
        public Boolean opted_in;
        
    }
    
/**
* @Description This method Serializes the EnrollRequest class in json format 
* @author Saptaswa
* @date 07-11-2017
* @return type String-->Serialized Json String
* @param enrollRequest Object of EnrollRequest class which is to be serialized to JSON format
*/

    public static String serializeEnrollRequest(EnrollRequest enrollRequest){
        
        return JSON.serialize(enrollRequest,true);
        
    }
    
}