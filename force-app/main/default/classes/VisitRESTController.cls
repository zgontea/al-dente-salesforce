@RestResource(urlMapping = '/Visit/*')
global without sharing class VisitRESTController {
    private static final String VISIT_FIELDS_TO_QUERY = 'Consulting_Room__c, Start_Time__c, End_Time__c, Status__c, Patient__c, Patient__r.First_Name__c, Patient__r.Last_Name__c, Patient__r.PESEL__c, Patient__r.Phone_Number__c, Doctor__c, Doctor__r.Name';
    private static final String PATIENT_FIELDS_TO_QUERY = 'Id, First_Name__c, Last_Name__c, Gender__c, Birth_Date__c, PESEL__c, Phone_Number__c';

    @HttpGet
    global static void getAll() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        FilteredQueryBuilder visitQueryBuilder = new FilteredQueryBuilder().setParams(req.params).setSObjectType('Visit__c').setFields(VISIT_FIELDS_TO_QUERY).setSortField('Start_Time__c').setSortType('ASC');
        
        FilteredQueryBuilder patientQueryBuilder = new FilteredQueryBuilder().setSObjectType('Patient__c').setFields(PATIENT_FIELDS_TO_QUERY);
        List<Patient__c> foundPatients = new List<Patient__c>();
        if (req.params.containsKey('searchValue')) {
            patientQueryBuilder.setParams(req.params);
            foundPatients = (List<Patient__c>) Search.query(patientQueryBuilder.buildSOSL())[0];
            visitQueryBuilder.setWhereField('Patient__c IN :foundPatients');
        }

        // TODO from to date filter

        List<SObject> queriedVisits = Database.query(visitQueryBuilder.buildSOQL());

        List<RESTResponseWrappers.VisitDateWrapper> visitResponseWrappers = new List<RESTResponseWrappers.VisitDateWrapper>();

        Map<String, List<RESTResponseWrappers.VisitWrapper>> visitsByDatetime = new Map<String, List<RESTResponseWrappers.VisitWrapper>>();
        for (Visit__c visit : (List<Visit__c>) queriedVisits) {
            String startTime = RESTResponseWrappers.getDateAndDay(visit.Start_Time__c);
            if (!visitsByDatetime.containsKey(startTime)) {
                visitsByDatetime.put(startTime, new List<RESTResponseWrappers.VisitWrapper>());
            }
            visitsByDatetime.get(startTime).add(new RESTResponseWrappers.VisitWrapper(visit));
        }

        for (String startTime : visitsByDatetime.keySet()) {
            visitResponseWrappers.add(new RESTResponseWrappers.VisitDateWrapper(startTime, visitsByDatetime.get(startTime)));
        }

        res.responseBody = Blob.valueOf(JSON.serializePretty(visitResponseWrappers, true));
    }

    @HttpPost
    global static void createVisit() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        RESTResponseWrappers.VisitWrapper visitWrapper = (RESTResponseWrappers.VisitWrapper) JSON.deserialize(req.requestBody.toString(), RESTResponseWrappers.VisitWrapper.class);

        upsert visitWrapper.createVisitObject();

        res.statusCode = 201;
    }
}
