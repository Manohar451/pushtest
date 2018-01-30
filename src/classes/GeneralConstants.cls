/**
* @Description This class contains all the constant variables that are used in various service classes 
* @author Oswin
* @date 08-01-2017
*/

public with sharing class GeneralConstants {

  public static final String CONST_FORWARD_SLASH = '/';
  public static final String CONST_PRIV_STRING_FOR_CALL_OUT = System.Label.smsfsc.ReasonCodesContextPath_Priv;
  public static final String CONST_REASON_CODE_URL_CONTEXT = System.Label.smsfsc.ReasonCodesContextPath_Reasons;
  public static final String CONST_APPS_STRING_FOR_CALL_OUT = System.Label.smsfsc.ContextPathApps;
  public static final String CONST_POST_METHOD = 'POST';
  public static final String CONST_PUT_METHOD = 'PUT';
  public static final String CONST_GET_METHOD = 'GET';
  public static final String CONST_SERVICE_TYPE_ENROLL = 'enroll';
  public static final String CONST_SERVICE_TYPE_UPDATE = 'update';
  public static final String CONST_SERVICE_TYPE_VIEW = 'view';
  public static final String CONST_SERVICE_TYPE_REASON_CODE = 'reasonCode';
  public static final String CONST_SERVICE_TYPE_COMP = 'comp';
  public static final String CONST_SERVICE_TYPE_TIMELINE = 'timeline';
  public static final String CONST_CUSTOM_SETTINGS_LABEL_NAME = System.Label.smsfsc.Custom_Setings_Name;

  public static final String CONST_POINTS_CONTEXT_POINTS = System.Label.PointsContextPoint_Users;
  public static final String CONST_POINTS_CONTEXT_POINTS1 = System.Label.PointsContextPath_Points;
  public static final String CONST_TRANSACTION_KEYWORD = 'transaction';
  public static final String CONST_TRANSACTION_KEYWORD_TO_REPLACE ='transaction_z';
  public static final String CONST_APPROVED = 'Approved';

  public static final String CONST_SESSIONM_USERID_PREFIX_URL_PATH = System.Label.smsfsc.PointsContextPoint_Users;
  public static final String CONST_TIMELINE_URL_PATH = System.Label.smsfsc.Context_Path_TimeLine;
  public static final String CONST_TIMELINE_CONTEXT_SLUG_QS = System.Label.smsfsc.Context_Path_Activity_Service;

  public static final String CONST_VIEW_CONTEXT_PATH = System.Label.smsfsc.ViewUserURLSubstringContextPath;
  public static final String CONST_VIEW_QUERY_STRING = System.Label.smsfsc.ViewUserURLSubstringQueryString;

  public static final String CONST_ENROLL_SERVICE_CONTEXT = System.Label.smsfsc.Enroll_Service_Context;
  public static final String CONST_ERROR_FIELD = 'errors';
  public static final String CONST_USER_SECTION = 'user';
  public static final String CONST_ERROR_CODE = 'code';
  public static final String CONST_STATUS_OK = 'ok';
  public static final String CONST_STATUS_ERROR = 'error';
  public static final String CONST_SUCCESS_MSG = 'success';
  public static final String CONST_ERROR_MSG = 'error';
  public static final String CONST_SUCCESS_CODE = '200';
  public static final String CONST_UNHANDLED_ERROR_CODE = '0';
  public static final String CONST_SESSIONM_USER_SOBJ_NAME = 'smsfsc__SessionMUser__c';
  public static final String CONST_SESSIONM_TRANSACTION_SOBJ_NAME = 'smsfsc__SessionM_Transaction__c';
  public static final String CONST_ACCOUNT_OBJ_NAME = 'Account';
  public static final String CONST_JSON_MAP_ATTRIBUTE_TYPE_STANDARD = 'standard';
  public static final String CONST_JSON_MAP_ATTRIBUTE_TYPE_CUSTOM = 'custom';


  public static final String CONST_CONTEXT_PATH_UPDATE = System.Label.smsfsc.PointsURLSubstringUsers;
  public static final Set<String> SESSIONM_USER_READONLY_FIELDS= new Set<String>{'smsfsc__tiersystem__c','smsfsc__tier__c','smsfsc__tierenteredat__c','smsfsc__tierstartsValue__c','smsfsc__verificationmethod__c','createdbyid','lastmodifiedbyid','smsfsc__sessionmid__c','smsfsc__unclaimedachievementcount__c','smsfsc__registeredat__c','smsfsc__nexttierpoints__c','smsfsc__nexttierpoints__c','smsfsc__tierendsvalue__c','smsfsc__externalid__c','smsfsc__externalidtype__c','smsfsc__createdat__c','smsfsc__updatedat__c','smsfsc__availablepoints__c','smsfsc__suspended__c'};


  public static final String CONST_SESSIONM_USER_OBJ_NAME = System.Label.smsfsc.SessionM_User_SObjectType;
  public static final String CONST_USER = System.Label.smsfsc.User_Label;
  public static final String CONST_USER_PROFILE = System.Label.smsfsc.Sm_User_Profile;
  public static final String CONST_ACCOUNT_LOOKUP = System.Label.smsfsc.Account_Lookup;
  public static final String CONST_EMAIL_FIELD_IN_SESSIONM_USER_OBJ = System.Label.smsfsc.Email_Field_of_SessionM_User;
  public static final String CONST_NAME_FIELD = System.Label.smsfsc.Name_Field_In_Account;
  public static final String CONST_EMAIL_SM_FIELD = System.Label.smsfsc.Sm_Email_Field;
  public static final Integer CONST_MAX_RECORDS_TO_DELETE = Limits.getLimitQueryLocatorRows();
  public static final Integer CONST_MIN_RECORDS_TO_DELETE = 2000;
  public static final Integer CONST_TIMEFRAME = 2;
  public static final Integer CONST_MAX_TIMEFRAME = 50;

}