public  class ExternalSystemService {
   /**
     * @description This class call a Callout method from the {ExternalSystemCallout} class.
     * @param caseToBeHandled : Case that need to be handled
     */
    public void registerAttendees(Case caseToBeHandled){
        ExternalSystemCallout.fireCallout(caseToBeHandled);
    } 
}
