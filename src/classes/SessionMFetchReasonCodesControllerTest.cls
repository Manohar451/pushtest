/**
* @Description This is test class for SessionMFetchReasonCodesController,ReasonCodeResponse
* @author Manohar Pandurangi
* @date 11-11-2017
*/


@isTest
private class SessionMFetchReasonCodesControllerTest {
    @testSetup static void setup(){
        
        String name = String.valueOf('\'') +'System Administrator'+ String.valueOf('\'');
        List<Profile> profileList = Database.query('Select Id,Name from Profile  where Name = '+name);
        
        Profile profile = null;
        if(profileList != null && profileList.size()>0){
            profile = profileList.get(0);
        } 
        System.assert(profile!=null);
        
        User usr = new User(LastName ='lastName', email='email@email.com', 
                            ProfileId=profile.id  ,Username='john4444444666@acme.com',CommunityNickname='cmn',
                            TimeZoneSidKey='America/Los_Angeles',LocaleSidKey='en_US',Alias='als',
                            EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
        
        insert usr;
        
    }
    
    
    
 /**
* @Description This method tests positive scenario i.e when the result of callout is succesful
* @author Manohar Pandurangi
* @date 11-11-2017
*/

    
 @isTest
    private static void ReasonCodeAPICallTest()
    {

            String lastName = String.valueOf('\'') +'lastName'+ String.valueOf('\'');
        List<User> userList = Database.query('Select Id from User where lastName ='+lastName);
        
        User user = null;
        if(userList != null && userList.size()>0){
            user = userList.get(0);
        }
        
        System.runAs(user){    
            Test.startTest();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();//Setting static resource as response for mock callouts
            mock.setStaticResource('ReasonCodeAPIResponse');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            mock.setStatus('OK');
            // Associate the callout with a mock response
            Test.setMock(HttpCalloutMock.class, mock);
           ReasonCodeResponse fetchReasonCodePickListValues = SessionMFetchReasonCodesController.fetchReasonCodePickListValues();
           
            string json = '{"status":"ok","reasons":[{"id":533,"text":"Invalid Points","target_type":"point s_deduction"},{"id":534,"text":"Limit Reached","target_type":"points_deduction"} ,{"id":535,"text":"No Transaction Found","target_type":"points_deduction"},{"id" :536,"text":"Agent Comp Error","target_type":"points_deduction"},{"id":537,"text ":"Fraudulent Activity","target_type":"points_deduction"},{"id":538,"text":"Dedu ction - Other","target_type":"points_deduction"},{"id":539,"text":"Duplicate Use r","target_type":"account_status"},{"id":540,"text":"Invalid Phone Number","targ et_type":"account_status"},{"id":541,"text":"Location Not Supported","target_typ e":"account_status"},{"id":542,"text":"Account Update","target_type":"account_st atus"},{"id":543,"text":"Customer Account Request","target_type":"account_status "},{"id":544,"text":"Reward Redemption Issue","target_type":"account_status"},{" id":545,"text":"Tier Status Request","target_type":"account_status"},{"id":546," text":"Promo Code Inquiry","target_type":"account_status"},{"id":547,"text":"Rew ards Redemption Issue","target_type":"account_status"},{"id":548,"text":"Point B alance Question","target_type":"account_status"},{"id":549,"text":"Point Adjustm ent","target_type":"account_status"},{"id":550,"text":"Campaign Error","target_t ype":"account_status"},{"id":551,"text":"Access Issue","target_type":"account_st atus"},{"id":552,"text":"Communication Preference Update","target_type":"account _status"},{"id":553,"text":"Other","target_type":"account_status"},{"id":554,"te xt":"Good Will","target_type":"points_compensation"},{"id":555,"text":"Qualifyin g Purchase not posted - System Error","target_type":"points_compensation"},{"id" :556,"text":"Qualifying Purchase not posted - ID NOt Provided","target_type":"po ints_compensation"},{"id":557,"text":"Refunded Reward","target_type":"points_com pensation"},{"id":558,"text":"Reward not posted","target_type":"points_compensat ion"},{"id":559,"text":"Transfer from Duplicate Member Account","target_type":"p oints_compensation"},{"id":560,"text":"Compensation - Other","target_type":"poin ts_compensation"}]}';
            ReasonCodeResponse parsedresponse = ReasonCodeResponse.parse(json);
            string status = parsedresponse.status;
            System.assert(status!=null);
            List<ReasonCodeResponse.ReasonsPickListValues> reasons = parsedresponse.reasons;
            ReasonCodeResponse.ReasonsPickListValues innerclass = new  ReasonCodeResponse.ReasonsPickListValues();
            Integer Id = innerclass.id;
            string text = innerclass.text;
            
            string target = innerclass.target_type;
            Test.stopTest();
        }     
    }
}