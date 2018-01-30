/**
* @Description Wrapper/Parser Class for parsing the json resource in custom metadata,SessionM to Salesforce API Mapping.
* @author Saptaswa
* @date 11-11-2017
*/

public with sharing class SmToSfFieldJsonParser {
    
    public SmToSfFieldMappings smToSfFieldMappings;

/**
* @Description Used to parse json response
* @author Saptaswa
* @date 11-11-2107
* @return SmToSfFieldJsonParser-->Parsed json string data
* @param json jsonstring that needs to be parsed 
*/

    public static SmToSfFieldJsonParser parse(String json) {
        return (SmToSfFieldJsonParser) System.JSON.deserialize(json, SmToSfFieldJsonParser.class);
    }
    
/**
* @Description Inner class that has list of json mappings
* @author Saptaswa
* @date 11-11-2017
*/
    public class SmToSfFieldMappings {
        public List<Mappings> mappings;
    }

/**
* @Description This is inner class of SmToSfFieldJsonParser that holds Mappings from SessionM to Salesforce
* @author Saptaswa
* @date 11-11-2017
*/
    public class Mappings {
        public String smApiName;
        public String sfApiName;
        public string attributeType;
    }
}