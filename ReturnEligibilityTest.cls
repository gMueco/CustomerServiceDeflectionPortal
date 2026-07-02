@isTest
public with sharing class ReturnEligibilityTest {

    //no @testSetup needed since this just tests pure logic, no database stuff involved
    //for the same reason, since the tests and data are so straightforward, we'll keep it at one test method with multiple assertions
    @isTest
    static void isEligibleTest(){
        //negative tests
        //test null
        Order__c orderNull = new Order__c(Name = '01', Order_Date__c = null);
        System.assertEquals(false, ReturnEligibility.isEligible(orderNull));
        //test date > 30
        Order__c orderPastWindow = new Order__c(Name = '02', Order_Date__c = Date.today().addDays(-40), Status__c = 'Delivered');
        System.assertEquals(false, ReturnEligibility.isEligible(orderPastWindow));
        //test status=='Cancelled'
        Order__c orderCancelled = new Order__c(Name = '03', Order_Date__c = Date.today(), Status__c = 'Cancelled');
        System.assertEquals(false, ReturnEligibility.isEligible(orderCancelled));
        //test status=='Processing'
        Order__c orderProcessing = new Order__c(Name = '04', Order_Date__c = Date.today(), Status__c = 'Processing');
        System.assertEquals(false, ReturnEligibility.isEligible(orderProcessing));

        //positive tests
        //test status=='Shipped'
        Order__c orderShipped = new Order__c(Name = '05', Order_Date__c = Date.today(), Status__c = 'Shipped');
        System.assertEquals(true, ReturnEligibility.isEligible(orderShipped));
        //test status=='Delivered'
        Order__c orderDelivered = new Order__c(Name = '06', Order_Date__c = Date.today(), Status__c = 'Delivered');
        System.assertEquals(true, ReturnEligibility.isEligible(orderDelivered));
    }

    //typical best practice pattern for testing methods that CRUD or query, but is actually bloated here
    /*@TestSetup
    static void makeData(){
        List<Order__c> orderList = new List<Order__c>();
        Order__c orderNull = new Order__c(Name = '01', Order_Date__c = null);
        orderList.add(orderNull);
        Order__c orderPastWindow = new Order__c(Name = '02', Order_Date__c = Date.today().addDays(-31), Status__c = 'Delivered');
        orderList.add(orderPastWindow);
        Order__c orderCancelled = new Order__c(Name = '03', Order_Date__c = Date.today(), Status__c = 'Cancelled');
        orderList.add(orderCancelled);
        Order__c orderProcessing = new Order__c(Name = '04', Order_Date__c = Date.today(), Status__c = 'Processing');
        orderList.add(orderProcessing);
        Order__c orderShipped = new Order__c(Name = '05', Order_Date__c = Date.today(), Status__c = 'Shipped');
        orderList.add(orderShipped);
        Order__c orderDelivered = new Order__c(Name = '06', Order_Date__c = Date.today(), Status__c = 'Delivered');
        orderList.add(orderDelivered);
        insert orderList;
    }
    @isTest
    static void isEligibleTest(){
        List<Order__c> orders = [SELECT Id, Name, Order_Date__c, Status__c FROM Order__c];
        for(Order__c o : orders){
            //negative tests
            //test null
            if(o.Name == '01'){
                System.assertEquals(false, ReturnEligibility.isEligible(o));
            }
            //test date > 30
            if(o.Name == '02'){
                System.assertEquals(false, ReturnEligibility.isEligible(o));
            }
            //test status=='Cancelled'
            if(o.Name == '03'){
                System.assertEquals(false, ReturnEligibility.isEligible(o));
            }
            //test status=='Processing'
            if(o.Name == '04'){
                System.assertEquals(false, ReturnEligibility.isEligible(o));
            }

            //positive tests
            //test status=='Shipped'
            if(o.Name == '05'){
                System.assertEquals(true, ReturnEligibility.isEligible(o));
            }
            //test status=='Delivered'
            if(o.Name == '06'){
                System.assertEquals(true, ReturnEligibility.isEligible(o));
            }
        }

    }*/
}