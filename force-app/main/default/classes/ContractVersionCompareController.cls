public with sharing class ContractVersionCompareController {

    /* ================= CACHE ================= */
    private static Map<String, List<String>> layoutFieldCache = new Map<String, List<String>>();
    private static Map<String, Map<String, Schema.SObjectField>> objectFieldCache = new Map<String, Map<String, Schema.SObjectField>>();

    /* ================= PUBLIC METHOD ================= */
    @AuraEnabled(cacheable=true)
    public static CompareWrapper compareContracts(Id contractId1, Id contractId2) {

        if (contractId1 == null || contractId2 == null) {
            return new CompareWrapper();
        }

        // Get base contracts
        Contract c1 = [SELECT Id, RecordTypeId FROM Contract WHERE Id = :contractId1 LIMIT 1];
        Contract c2 = [SELECT Id, RecordTypeId FROM Contract WHERE Id = :contractId2 LIMIT 1];

        // Get fields dynamically from layout
        List<String> contractFields = prepareFields('Contract', c1.RecordTypeId);

        // Query contracts dynamically
        Contract v1 = queryRecord(contractId1, 'Contract', contractFields);
        Contract v2 = queryRecord(contractId2, 'Contract', contractFields);

        // CPS records
        Map<String, Contract_Program_Service__c> cps1 = getCPSMap(contractId1);
        Map<String, Contract_Program_Service__c> cps2 = getCPSMap(contractId2);

        List<String> cpsFields = prepareFields('Contract_Program_Service__c', getAnyRecordTypeId(cps1, cps2));

        CompareWrapper result = new CompareWrapper();
        result.contractFields = compareFields(v1, v2, contractFields, 'Contract');
        result.cpsRecords = compareCPS(cps1, cps2, cpsFields);

        return result;
    }

    /* ================= FIELD PREPARATION ================= */
    private static List<String> prepareFields(String objectName, Id recordTypeId) {

        List<String> fields = getLayoutFields(objectName, recordTypeId);
        fields = filterAccessibleFields(objectName, fields);
        fields = enrichRelationshipFields(objectName, fields);

        return new List<String>(new Set<String>(fields)); // dedupe
    }

    /* ================= LAYOUT FIELDS ================= */
    private static List<String> getLayoutFields(String objectName, Id recordTypeId) {

        String key = objectName + '_' + recordTypeId;

        if (layoutFieldCache.containsKey(key)) {
            return layoutFieldCache.get(key);
        }

        List<String> fields = new List<String>();

        Schema.DescribeLayoutResult layout =
            Schema.describeLayout(objectName, recordTypeId);

        for (Schema.DescribeLayoutSection section : layout.getSections()) {
            for (Schema.DescribeLayoutRow row : section.getRows()) {
                for (Schema.DescribeLayoutItem item : row.getLayoutItems()) {
                    if (item.getField() != null) {
                        fields.add(item.getField());
                    }
                }
            }
        }

        // Remove unwanted system fields
        fields.removeAll(new List<String>{
            'LastModifiedById', 'CreatedById', 'OwnerId'
        });

        layoutFieldCache.put(key, fields);
        return fields;
    }

    /* ================= FIELD MAP ================= */
    private static Map<String, Schema.SObjectField> getFieldMap(String objectName) {

        if (!objectFieldCache.containsKey(objectName)) {
            objectFieldCache.put(
                objectName,
                Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap()
            );
        }

        return objectFieldCache.get(objectName);
    }

    /* ================= FILTER FIELDS ================= */
    private static List<String> filterAccessibleFields(String objectName, List<String> fields) {

        Map<String, Schema.SObjectField> fieldMap = getFieldMap(objectName);
        List<String> accessible = new List<String>();

        for (String f : fields) {
            if (fieldMap.containsKey(f) &&
                fieldMap.get(f).getDescribe().isAccessible()) {
                accessible.add(f);
            }
        }

        return accessible;
    }

    /* ================= RELATIONSHIP HANDLING ================= */
    private static List<String> enrichRelationshipFields(String objectName, List<String> fields) {

        Map<String, Schema.SObjectField> fieldMap = getFieldMap(objectName);
        List<String> enriched = new List<String>();

        for (String f : fields) {
            if (!fieldMap.containsKey(f)) continue;

            enriched.add(f);

            Schema.DescribeFieldResult d = fieldMap.get(f).getDescribe();

            if (d.getType() == Schema.DisplayType.REFERENCE) {
                String rel = d.getRelationshipName();
                if (rel != null) {
                    enriched.add(rel + '.Name');
                }
            }
        }

        return enriched;
    }

    /* ================= QUERY ================= */
    private static SObject queryRecord(Id recordId, String objectName, List<String> fields) {

        if (recordId == null || fields.isEmpty()) return null;

        String soql =
            'SELECT ' + String.join(fields, ',') +
            ' FROM ' + objectName +
            ' WHERE Id = :recordId';

        return Database.query(soql);
    }

    /* ================= CPS MAP ================= */
    private static Map<String, Contract_Program_Service__c> getCPSMap(Id contractId) {

        Map<String, Contract_Program_Service__c> result = new Map<String, Contract_Program_Service__c>();

        List<Contract_Program_Service__c> listRec = [
            SELECT Id, MCFD_CPS_Number__c
            FROM Contract_Program_Service__c
            WHERE Contract__c = :contractId
        ];

        for (Contract_Program_Service__c rec : listRec) {
            if (rec.MCFD_CPS_Number__c != null) {
                result.put(rec.MCFD_CPS_Number__c, rec);
            }
        }

        return result;
    }

    private static Id getAnyRecordTypeId(
        Map<String, Contract_Program_Service__c> m1,
        Map<String, Contract_Program_Service__c> m2
    ) {
        if (!m1.isEmpty()) return m1.values()[0].RecordTypeId;
        if (!m2.isEmpty()) return m2.values()[0].RecordTypeId;
        return null;
    }

    /* ================= COMPARE ================= */
    private static List<FieldCompare> compareFields(
        SObject v1,
        SObject v2,
        List<String> fields,
        String objectName
    ) {

        Map<String, Schema.SObjectField> fieldMap = getFieldMap(objectName);
        List<FieldCompare> result = new List<FieldCompare>();

        for (String f : fields) {

            if (!fieldMap.containsKey(f)) continue;

            Schema.DescribeFieldResult d = fieldMap.get(f).getDescribe();

            FieldCompare fc = new FieldCompare();
            fc.fieldApi = f;
            fc.label = d.getLabel();

            fc.valueV1 = getDisplayValue(v1, f, d);
            fc.valueV2 = getDisplayValue(v2, f, d);

            fc.isMatch = String.valueOf(fc.valueV1) == String.valueOf(fc.valueV2);

            result.add(fc);
        }

        return result;
    }

    private static Object getDisplayValue(SObject record, String field, Schema.DescribeFieldResult d) {

        if (record == null) return null;

        Object val = record.get(field);
        if (val == null) return null;

        if (d.getType() == Schema.DisplayType.REFERENCE) {
            String rel = d.getRelationshipName();
            if (rel != null && record.getSObject(rel) != null) {
                return record.getSObject(rel).get('Name');
            }
        }

        if (d.getType() == Schema.DisplayType.ADDRESS) {
            Address a = (Address) val;
            return String.join(new List<String>{
                a.street, a.city, a.state, a.postalCode, a.country
            }, ', ');
        }

        return String.valueOf(val);
    }

    /* ================= CPS COMPARE ================= */
    private static List<CPSCompare> compareCPS(
        Map<String, Contract_Program_Service__c> m1,
        Map<String, Contract_Program_Service__c> m2,
        List<String> fields
    ) {

        Set<String> keys = new Set<String>();
        keys.addAll(m1.keySet());
        keys.addAll(m2.keySet());

        List<CPSCompare> result = new List<CPSCompare>();

        for (String key : keys) {

            Contract_Program_Service__c c1 = m1.get(key);
            Contract_Program_Service__c c2 = m2.get(key);

            CPSCompare rec = new CPSCompare();
            rec.cpsNumber = key;

            if (c1 == null) rec.cpsNewV2 = 'NEW';
            else if (c2 == null) rec.cpsNewV1 = 'REMOVED';

            rec.fields = compareFields(c1, c2, fields, 'Contract_Program_Service__c');

            result.add(rec);
        }

        return result;
    }

    /* ================= WRAPPERS ================= */
    public class CompareWrapper {
        @AuraEnabled public List<FieldCompare> contractFields;
        @AuraEnabled public List<CPSCompare> cpsRecords;
    }

    public class FieldCompare {
        @AuraEnabled public String fieldApi;
        @AuraEnabled public String label;
        @AuraEnabled public Object valueV1;
        @AuraEnabled public Object valueV2;
        @AuraEnabled public Boolean isMatch;
    }

    public class CPSCompare {
        @AuraEnabled public String cpsNumber;
        @AuraEnabled public String cpsNewV1;
        @AuraEnabled public String cpsNewV2;
        @AuraEnabled public List<FieldCompare> fields;
    }
}