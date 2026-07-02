public class ReturnEligibility {

    public static Boolean isEligible(Order__c order) {
        // Guard: an order with no date can't be evaluated for a return window.
        // Treating missing date as ineligible — a stakeholder might instead want
        // this flagged for manual review. Documenting the assumption.
        if (order.Order_Date__c == null) {
            return false;
        }
    
        Date returnDeadline = order.Order_Date__c.addDays(30); // 30 day return window
        if (returnDeadline < Date.today()) {
            return false;
        }
    
        List<String> ineligibleStatuses = new List<String>{'Cancelled', 'Processing'};
        if (ineligibleStatuses.contains(order.Status__c)) {
            return false;
        }
    
        return true;
    }
}
