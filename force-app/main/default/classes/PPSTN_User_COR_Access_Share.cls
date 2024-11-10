trigger user_CORS_RestrictionApexSharing on PPSTN_User_COR_Restrictions__c (after insert, before delete) {
    
 if (trigger.isDelete) {
    
    List<AccountShare> accShrs  = new List<AccountShare>();
    for (PPSTN_User_COR_Restrictions__c user_CORS_Restriction : trigger.old){
    
        List<Account> accs = [select id from account where PPSTN_License_Type_SF__c=:user_CORS_Restriction.License_Type__c and PPSTN_COR__c=:user_CORS_Restriction.Country_Code__c];
        
        for(Account acc:accs) {
            accShares= [select id from AccountShare where AccountId=:acc.id and UserOrGroupId=:user_CORS_Restriction.Pepperstone_User__c and AccountRowCause='Manual'];  
        }
        delete accShares;

 
 }

    if(trigger.isInsert){
        // Create a new list of sharing objects for user_CORS_Restriction
        List<AccountShare> accShrs  = new List<AccountShare>();
        
        // Declare variables for recruiting and hiring manager sharing
        AccountShare accShare;
        
        //not bulkified!! this is for demo purposes
        
        for (PPSTN_User_COR_Restrictions__c user_CORS_Restriction : trigger.new){
            System.debug('======'+user_CORS_Restriction);
            List<Account> accs = [select id from account where PPSTN_License_Type_SF__c=:user_CORS_Restriction.License_Type__c and PPSTN_COR__c=:user_CORS_Restriction.Country_Code__c];
            for(Account acc:accs){
            // Instantiate the sharing objects
            System.debug('======'+acc);
            accShare = new AccountShare();
            // Set the ID of record being shared
            accShare.AccountId = acc.Id;
            
            // Set the ID of user or group being granted access
            accShare.UserOrGroupId = user_CORS_Restriction.Pepperstone_User__c;
            
            // Set the access level
            accShare.AccountAccessLevel = user_CORS_Restriction.AccessLevel__c;
accShare.OpportunityAccessLevel=user_CORS_Restriction.AccessLevel__c;
accShare.ContactAccessLevel=user_CORS_Restriction.AccessLevel__c;
accShare.CaseAccessLevel=user_CORS_Restriction.AccessLevel__c;

            // Set the Apex sharing reason for hiring manager and recruiter
            accShare.RowCause = Schema.AccountShare.RowCause.Manual;
            // Add objects to list for insert
            accShrs.add(accShare);
        }
        
        // Insert sharing records and capture save result 
        // The false parameter allows for partial processing if multiple records are passed 
        // into the operation 
        Database.SaveResult[] lsr = Database.insert(accShrs,false);
        
        // Create counter
        Integer i=0;
        
        // Process the save results
        for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){
                // Get the first save result error
                Database.Error err = sr.getErrors()[0];
                
                // Check if the error is related to a trivial access level
                // Access levels equal or more permissive than the object's default 
                // access level are not allowed. 
                // These sharing records are not required and thus an insert exception is 
                // acceptable. 
                if(!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  
                                               &&  err.getMessage().contains('AccountAccessLevel'))){
                    // Throw an error when the error is not related to trivial access level.
                    trigger.newMap.get(accShrs[i].AccountId).
                      addError(
                       'Unable to grant sharing access due to following exception: '
                       + err.getMessage());
                }
            }
            i++;
        }   
    }
    
}
}