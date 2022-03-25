public with sharing class ExternalSystemCallOut {
    
    /**
     * @description This class has a future callout method in order to fire it in the {ExternalSystemService} class.
     * @param caseToBeHandled It takes the Case that need to be handled as parameter
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
                notifyAttendeeByEmail(contact,caseToBeHandled.Id);
            }
        }
    }

   /**
     * This method is created in order to send an Email to a Contact(s)
     */
    public static void sendMail(String contactEmail, Id caseToBeHandledId) {
        // Retrieving the domain from the current URL
        String caseRoute = URL.getSalesforceBaseUrl().toExternalForm() + '/' + caseToBeHandledId;
        String[] contactEmailList = new String[] {contactEmail};
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSenderDisplayName('SF Support Team');
        mail.setSubject('Case Closed');
        mail.setToAddresses(contactEmailList);
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setHtmlBody('Case <b>'+ caseToBeHandledId +'</b> has been closed!'+'<p>Case Link : <a href='+caseRoute+'>.</a></p>');  
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

   /**
     * @description Notify attendee by email
     * @param contact creating a Task for this specific contact
     */
    public static void notifyAttendeeByEmail(Contact contact, Id caseToBeHandledId){
        Task task = new Task();
        task.Subject = 'Send Email To' + contact.name;
        task.Status = 'Open';
        task.Priority = 'Normal';
        task.WhoId = contact.Id;
        task.WhatId = contact.AccountId;
        insert task;
        // After inserting the task, we should send automatic email to the contact
        sendMail(contact.email, caseToBeHandledId);
    } 

}
