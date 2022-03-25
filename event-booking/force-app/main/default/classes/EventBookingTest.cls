@isTest
public class EventBookingTest {  

        @isTest
        public static void refuseCaseCreationWhenAnAccountIsNotAttachedToACase(){
            //Given 
            Case req1 =TestDataFactory.createCase('Phone'); 
            // When 
            Test.startTest();
            Database.SaveResult result = Database.insert(req1, false);
            Test.stopTest();
            // Then
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('You cannot create a request without attaching an account',
            result.getErrors()[0].getMessage());
        }
        
        @isTest
        public static void refuseCaseCreationWhenNoContactIsAttachedToAnAccount(){
            //Given
            Case req2 = TestDataFactory.createCaseWithAccount('Phone');
            // When 
            Test.startTest();
            Database.SaveResult result = Database.insert(req2, false);
            Test.stopTest();
            // Then
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('You cannot create a request for accounts without contacts',
            result.getErrors()[0].getMessage());
        }
        
        @isTest
        public static void bookEventFromPhone(){
             //Given 
             Case req3 =TestDataFactory.createCaseWithAccountAndContacts(
                                3,
                                'Phone',
                                'Book Spots for Company A1 & their 3 employees');
            // When 
            Test.startTest();
            Database.SaveResult result = Database.insert(req3, false);
            Test.stopTest();
            // Then
            System.assertEquals(result.getErrors()[0].message,
                            'Unknown Error: Cannot handle this case');    
        }


        @isTest
        public static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanThreeForPhoneCases(){
            //Given
            Case req4 = TestDataFactory.createCaseWithAccountAndContacts(
                            4,
                            'Phone',
                            'Book Spots for Company A1 & their 4 employees');
            // When 
            Test.startTest();
            Database.SaveResult result = Database.insert(req4, false);
            Test.stopTest();
            // Then
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('Phone request are only allowed to have three attendee',
            result.getErrors()[0].getMessage());
        }
        
        @isTest
        public static void bookEventFromTheWeb(){
            //Given 
            Case req5 = TestDataFactory.createCaseWithAccountAndContacts(
                                1,
                                'Web',
                                'Book One Spot for Company A1');
            // When 
            Test.startTest();
            Database.SaveResult result = Database.insert(req5, false);
            Test.stopTest();
            // Then
            System.assertEquals(result.getErrors()[0].message,'Unknown Error: Cannot handle this case');  
        }
            
        @isTest
        public static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanOneForWebCases(){
            //Given 
            Case req6 = TestDataFactory.createCaseWithAccountAndContacts(
                                    3,
                                    'Web',
                                    'Book Spots for Company A1 & their 3 employees');
            // When 
            Test.startTest();
            Database.SaveResult result = Database.insert(req6, false);
            Test.stopTest();
            // Then
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('Web request are only allowed to have one attendee',
            result.getErrors()[0].getMessage());
        } 
    

    
}
