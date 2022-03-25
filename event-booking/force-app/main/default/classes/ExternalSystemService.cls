public  class ExternalSystemService {
   /**
     * @description This class call a Callout method from the {ExternalSystemCallout} class.
     * @param caseToBeHandled : Case that need to be handled
     */
    public void registerAttendees(Case caseToBeHandled){
        List<Account> accountList = [SELECT id FROM Account where id = :caseToBeHandled.AccountId];
        Set<Id> setOfAccountsIdSet = (new Map<Id,SObject>(accountList)).keySet();
        Id caseToBeHandledId = caseToBeHandled.Id;
        ExternalSystemCallout.fireCallout(caseToBeHandledId,setOfAccountsIdSet);
    } 
}
