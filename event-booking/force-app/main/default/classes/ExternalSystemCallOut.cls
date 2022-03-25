public with sharing class ExternalSystemCallOut {
    
    /**
     * @description This class has a future callout method in order to fire it in the {ExternalSystemService} class.
     * @param caseToBeHandled It takes the Case that need to be handled as parameter
     */

    private static final String NAMED_CREDENTIAL_ANIMALS_URL='callout:ExternalServiceUrl/animals'; 

    @future(callout=true)
    public static void fireCallout(Case caseToBeHandled) {
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
                ExternalSystemHelper.notifyAttendeeByEmail(contact,caseToBeHandled.Id);
            }
        }
    }

}
