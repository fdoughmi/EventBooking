public with sharing class ExternalSystemCallOut {
    /**
     * @description future callout to external service
     * @param accountIdsSet set of Account Ids
     */

    private static final String NAMED_CREDENTIAL_ANIMALS_URL='callout:ExternalServiceUrl/animals'; 

    @future(callout=true)
    public static void fireCallout(Case caseToBeHandled) {
        List<Account> accountList = [SELECT id FROM Account where id = :caseToBeHandled.AccountId];
        Set<Id> setOfAccountsIdSet = (new Map<Id,SObject>(accountList)).keySet();
        List<Contact> contactList = [SELECT id,name, email, AccountId FROM Contact where AccountId IN : setOfAccountsIdSet ];
        for(Contact contact: contactList) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(NAMED_CREDENTIAL_ANIMALS_URL);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');    
            // Set the body as a JSON object
            request.setBody('{"name":"'+ contact.name + '-' + contact.email  +'"}');
            HttpResponse response = http.send(request);
            // Parse the JSON response
            if (response.getStatusCode() != 201) {
                Logger.error('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
            } else {
                // Everything went as expected.
                notifyAttendeeByEmail(contact);
            }
        }
    }

   /**
     * @description Notify attendee by email
     * @param contact creating a Task for this specific contact
     */
    public static void notifyAttendeeByEmail(Contact contact){
        Task task = new Task();
        task.Subject = 'Send Email To' + contact.name;
        task.Status = 'Open';
        task.Priority = 'Normal';
        task.WhoId = contact.Id;
        task.WhatId = contact.AccountId;
        insert task;
    } 
}
