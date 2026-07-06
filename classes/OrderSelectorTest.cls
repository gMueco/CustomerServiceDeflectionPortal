@isTest
public with sharing class OrderSelectorTest {
    @TestSetup
    static void makeData() {
        insert new Order__c(Name = '01', Order_Date__c = Date.today(), Status__c = 'Shipped');
    }

    @isTest
    static void getOrderByNumber_found() {
        Order__c result = OrderSelector.getOrderByNumber('01');
        System.assertNotEquals(null, result, 'Should find the order named 01');
        System.assertEquals('01', result.Name, 'Returned order should be the one queried for');
    }

    @isTest
    static void getOrderByNumber_notFound() {
        Order__c result = OrderSelector.getOrderByNumber('00');
        System.assertEquals(null, result, 'Nonexistent order number should return null');
    }
}
