public with sharing class OrderSelector {
        public static Order__c getOrderByNumber(String orderNumber){
            List<Order__c> orders = [
            SELECT Id, Name, Order_Date__c, Status__c
            FROM Order__c
            WHERE Name = :orderNumber
            LIMIT 1
        ];

        if (orders.isEmpty()) {
            // the "not found" decision goes here
            return null; // or throw, or return something else — your call
        }
        return orders[0];
    }
}
