/**
 * This Class gathers the {sendMail} method and the {notifyAttendeeByEmail} method in order to keep the CallOut Class clean
 */
public with sharing class ExternalSystemHelper {
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
