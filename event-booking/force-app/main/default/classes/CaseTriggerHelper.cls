public with sharing class CaseTriggerHelper {

    /**
     * @description This method handles before inserting errors
     */
    public static void beforeInsertChecker(Case caseBeforeInsert) {
        if(caseBeforeInsert != null && caseBeforeInsert.AccountId != null){
            Account accounts =  [SELECT ID, (select id from contacts) FROM Account where id = :caseBeforeInsert.AccountId LIMIT 1];
            Integer contactListSize = accounts.Contacts.size();
            handleCaseErrors(caseBeforeInsert,contactListSize);
        } else {
            caseBeforeInsert.addError('You cannot create a request without attaching an account');
        }
    }

    /**
     * @description Handling before Insert Case errors
     */
    public static void handleCaseErrors(Case caseBeforeInsert, Integer contactListSize) {
        if(contactListSize == 0) {
            caseBeforeInsert.addError('You cannot create a request for accounts without contacts');
        } else if(caseBeforeInsert.Origin == 'Web' && contactListSize >= 2) {
            caseBeforeInsert.addError('Web request are only allowed to have one attendee');
        } else if(caseBeforeInsert.Origin == 'Phone' && contactListSize >= 4) {
            caseBeforeInsert.addError('Phone request are only allowed to have three attendee');
        }else{
            caseBeforeInsert.addError('Unknown Error');
        }
    }

    /**
     * @description This method checks whether case status is Closed or not, and start the register Attendees if its the case
     */
    public static void beforeUpdateChecker(Case caseBeforeUpdate) {
        Case effectiveCase = [SELECT AccountId, Status FROM Case where id=:caseBeforeUpdate.ID];
        if(effectiveCase.Status == 'Closed'){
            ExternalSystemService externalSystemService = new ExternalSystemService();
            externalSystemService.registerAttendees(effectiveCase);
        }else{
            Log.error('Case status is not closed yet');
        }
    }

}
