@isTest
public class EventBookingTest {  

        static Case requestCase1=null;
        static Case requestCase2=null;
        static Case requestCase3=null;
        static Case requestCase4=null;
        static Case requestCase5=null;
        static Case requestCase6=null;

        //Given for all the suite cases
        @TestSetup static void setup(){
            //refuseCaseCreationWhenAnAccountIsNotAttachedToACase --------------- Test 1
            requestCase1 = TestDataFactory.createCase('Phone'); 
            //refuseCaseCreationWhenNoContactIsAttachedToAnAccount -------------- Test 2
            requestCase2 = TestDataFactory.createCaseWithAccount('Phone');
            //bookEventFromPhone ------------------------------------------------ Test 3
            requestCase3 = TestDataFactory.createCaseWithAccountAndContacts(
                                3,
                                'Phone',
                                'Book Spots for Company A1 & their 3 employees');
            //refuseEventBookingWhenNumberOfAttendeesIsMoreThanThreeForPhoneCases-Test 4
            requestCase4 = TestDataFactory.createCaseWithAccountAndContacts(
                                4,
                                'Phone',
                                'Book Spots for Company A1 & their 4 employees');
            //bookEventFromTheWeb ----------------------------------------------- Test 5
            requestCase5 = TestDataFactory.createCaseWithAccountAndContacts(
                                1,
                                'Web',
                                'Book One Spot for Company A1');
            //refuseEventBookingWhenNumberOfAttendeesIsMoreThanOneForWebCases --- Test 6
            requestCase6 = TestDataFactory.createCaseWithAccountAndContacts(
                                3,
                                'Web',
                                'Book Spots for Company A1 & their 3 employees');
        }

        @isTest
        public static void refuseCaseCreationWhenAnAccountIsNotAttachedToACase(){
            // When 
            Test.startTest();
            Database.SaveResult result = Database.insert(this.requestCase1, false);
            Test.stopTest();
            // Then
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('You cannot create a request without attaching an account',
            result.getErrors()[0].getMessage());
        }
        
        @isTest
        public static void refuseCaseCreationWhenNoContactIsAttachedToAnAccount(){
            // When 
            Test.startTest();
            Database.SaveResult result = Database.insert(this.requestCase2, false);
            Test.stopTest();
            // Then
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('You cannot create a request for accounts without contacts',
            result.getErrors()[0].getMessage());
        }
        
        @isTest
        public static void bookEventFromPhone(){
            // When 
            Test.startTest();
            Database.SaveResult result = Database.insert(this.requestCase3, false);
            Test.stopTest();
            // Then
            System.assert(result.isSuccess(),
                            'Case creation should be successful');
        }


        @isTest
        public static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanThreeForPhoneCases(){
            // When 
            Test.startTest();
            Database.SaveResult result = Database.insert(this.requestCase4, false);
            Test.stopTest();
            // Then
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('Phone request are only allowed to have three attendee',
            result.getErrors()[0].getMessage());
        }
        
        @isTest
        public static void bookEventFromTheWeb(){
            // When 
            Test.startTest();
            Database.SaveResult result = Database.insert(this.requestCase5, false);
            Test.stopTest();
            // Then
            System.assert(result.isSuccess(),
                            'Case creation should successful.');       
        }
            
        @isTest
        public static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanOneForWebCases(){
            // When 
            Test.startTest();
            Database.SaveResult result = Database.insert(this.requestCase6, false);
            Test.stopTest();
            // Then
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('Web request are only allowed to have one attendee',
            result.getErrors()[0].getMessage());
        } 
    

    
}
