<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>SessionM to Salesforce API Mapping</label>
    <protected>false</protected>
    <values>
        <field>FieldMappingsJson__c</field>
        <value xsi:type="xsd:string">{
	&quot;SmToSfFieldMappings&quot;: {
		&quot;Mappings&quot;: [{
			&quot;smApiName&quot;: &quot;id&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__SessionMID__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;external_id&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__ExternalID__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;available_points&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__AvailablePoints__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;unclaimed_achievement_count&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__UnclaimedAchievementCount__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;email&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__Email__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;locale&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__Locale__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;external_id_type&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__ExternalIDType__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;gender&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__CustomerGender__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;dob&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__DateOfBirth__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;created_at&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__CreatedAt__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;updated_at&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__UpdatedAt__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;address&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__Address__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;city&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__City__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;zip&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__ZipCode__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;dma&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__Dma__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;state&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__State__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;country&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__CustomerCountry__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;suspended&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__Suspended__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;last_name&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__LastName__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;first_name&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__FirstName__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;registered_at&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__RegisteredAt__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;verification_method&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__VerificationMethod__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;profile_photo_url&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__ProfilePhotoURL__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;account_status&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__AccountStatus__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;current_state&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__CurrentState__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;current_country&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__CustomerCurrentCountry__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;opted_in&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__OptedIn__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;tier&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__Tier__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;tier_system&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__TierSystem__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;next_tier_percentage&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__NextTierPercentage__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;next_tier_points&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__NextTierPoints__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;tier_starts_value&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__TierStartsValue__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;tier_ends_value&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__TierEndsValue__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;tier_entered_at&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__TierEnteredAt__c&quot;,
			&quot;attributeType&quot;: &quot;standard&quot;
		},
		{
			&quot;smApiName&quot;: &quot;_version&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__CustomInteger1__c&quot;,
			&quot;attributeType&quot;: &quot;custom&quot;
		},
		{
			&quot;smApiName&quot;: &quot;birthday&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__CustomDate1__c&quot;,
			&quot;attributeType&quot;: &quot;custom&quot;
		},
		{
			&quot;smApiName&quot;: &quot;companyName&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__CustomText1__c&quot;,
			&quot;attributeType&quot;: &quot;custom&quot;
		},
		{
			&quot;smApiName&quot;: &quot;fax&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__CustomText10__c&quot;,
			&quot;attributeType&quot;: &quot;custom&quot;
		},
		{
			&quot;smApiName&quot;: &quot;firstName&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__CustomText2__c&quot;,
			&quot;attributeType&quot;: &quot;custom&quot;
		},
		{
			&quot;smApiName&quot;: &quot;jobTitle&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__CustomText4__c&quot;,
			&quot;attributeType&quot;: &quot;custom&quot;
		},
		{
			&quot;smApiName&quot;: &quot;nextBirthday&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__CustomDate2__c&quot;,
			&quot;attributeType&quot;: &quot;custom&quot;
		},
		{
			&quot;smApiName&quot;: &quot;phoneBusiness&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__CustomText11__c&quot;,
			&quot;attributeType&quot;: &quot;custom&quot;
		},
		{
			&quot;smApiName&quot;: &quot;phoneHome&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__CustomText12__c&quot;,
			&quot;attributeType&quot;: &quot;custom&quot;
		},
		{
			&quot;smApiName&quot;: &quot;phoneMobile&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__CustomText13__c&quot;,
			&quot;attributeType&quot;: &quot;custom&quot;
		},
		{
			&quot;smApiName&quot;: &quot;salutation&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__CustomText5__c&quot;,
			&quot;attributeType&quot;: &quot;custom&quot;
		},
		{
			&quot;smApiName&quot;: &quot;secondName&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__CustomText14__c&quot;,
			&quot;attributeType&quot;: &quot;custom&quot;
		},
		{
			&quot;smApiName&quot;: &quot;suffix&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__CustomText6__c&quot;,
			&quot;attributeType&quot;: &quot;custom&quot;
		},
		{
			&quot;smApiName&quot;: &quot;email&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__CustomText7__c&quot;,
			&quot;attributeType&quot;: &quot;custom&quot;
		},
		{
			&quot;smApiName&quot;: &quot;title&quot;,
			&quot;sfApiName&quot;: &quot;smsfsc__CustomText8__c&quot;,
			&quot;attributeType&quot;: &quot;custom&quot;
		}]
	}
}</value>
    </values>
</CustomMetadata>
