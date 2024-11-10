/* Must ensure users have access to this Apex Class in the Security settings */
public with sharing class AccountController {

    /**
     * Assume that Apex methods provision immutable data, even if it's possible
     * to mutate the data today. It's a best practice to treat all data that a 
     * component receives as immutable. To mutate the data, make a shallow copy 
     * of the objects you want to mutate. It’s important to understand this concept 
     * when working with data.
     *
     * LWC STARTER KIT NOTE: This code is only provided as an example of how to
     * call Apex from LWC. Developers are highly encouraged to strictly
     * use Lightning Web Components for operations that can modify data while offline
     *
     * For more information, please visit:
     * https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.apex
     */
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList() {
        return [
            SELECT
                Id,
                Name,
                PPSTN_License_Type_SF__c,
                PPSTN_LegalEntityType__c,
                PPSTN_COR__c,
                Type,
                PPSTN_ClientId__c
            FROM Account
            where PPSTN_ClientId__c != NULL
            ORDER BY CreatedDate DESC
            LIMIT 10
        ];
    }
}