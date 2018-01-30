/**
* @Description This class will be used to generate json request for Comp Points which is sent as body to SessionM Points API during callouts
* @author Manohar
* @date 18-12-2017
*/


public with sharing class PointsRequestHelper {
    
    
  public Long points;
  public String user_id;
  public String free_form;
    
 /**
* @Description Constructor method for PointsRequestHelper class that sets the points added/removed,UserId user for which comping is done,Reason for comping
* @author Manohar
* @date 18-12-2017
* @param points number of points to be added 
* @param userId Id of the user whose points are updated 
* @param freeForm Reason for which the user is added/removed points
*/

    public PointsRequestHelper(Long points,String userId,String freeForm) {
        
        this.points=points;
        this.user_id=userId;
        this.free_form=freeForm ;
    }
}