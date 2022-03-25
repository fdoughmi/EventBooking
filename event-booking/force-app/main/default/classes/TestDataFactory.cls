@isTest
public with sharing class TestDataFactory {

    private static final String EVENT_BOOKING ='Event Booking';
    private static final String DESCRIPTION ='Book Spots';

    public static Case createCase(String caseOrigin) {
        return new Case(Origin = caseOrigin, Subject = EVENT_BOOKING, Description = DESCRIPTION);
    }
    
    public static Case createCaseWithAccount(String caseOrigin) {
        Account account = insertAccountSFIntoDB();
        return new Case(Origin = caseOrigin, Subject = EVENT_BOOKING, Description = DESCRIPTION, AccountId = account.ID);
    }

    public static Case createCaseWithAccountAndContacts(Integer numOfContactsToBeCreated, String caseOrigin, String description) {
        Account account = insertAccountSFIntoDB();
        insertListOfContactsIntoDB(numOfContactsToBeCreated, account);
        return new Case(Origin = caseOrigin, Subject = EVENT_BOOKING, Description = description, AccountId = account.ID);
    }

    public static void insertListOfContactsIntoDB(Integer numOfContactsToBeCreated, Account account) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i=0;i<numOfContactsToBeCreated;i++) {
            contacts.add(new Contact(LastName = 'Contact '+i, AccountId = account.ID));
        }
        insert contacts;
    }

    private static Account insertAccountSFIntoDB(){
        Account account = new Account(Name = 'Salesforce');
        insert account;
        return account;
    }
}
