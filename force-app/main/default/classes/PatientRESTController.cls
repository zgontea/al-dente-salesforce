@RestResource(urlMapping = '/Patient/*')
global without sharing class PatientRESTController {
    private static final String PATIENT_FIELDS_TO_QUERY = 'Id, First_Name__c, Last_Name__c, Gender__c, Birth_Date__c, PESEL__c, Phone_Number__c';

    @HttpGet
    global static void getPatients() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        FilteredQueryBuilder queryBuilder = new FilteredQueryBuilder().setParams(req.params).setSObjectType('Patient__c').setFields(PATIENT_FIELDS_TO_QUERY);
        List<SObject> queriedPatients = new List<SObject>();
        if (req.params.containsKey('searchValue')) {
            queriedPatients = Search.query(queryBuilder.buildSOSL())[0];
        } else if (req.params.containsKey('id')) {
            queriedPatients = [SELECT Id, First_Name__c, Last_Name__c, Gender__c, Birth_Date__c, PESEL__c, Phone_Number__c, (SELECT Id, Start_Time__c, End_Time__c, Status__c FROM Visits__r) FROM Patient__c WHERE Id = :req.params.get('id')];
            RESTResponseWrappers.PatientInfoWrapper responseWrapper = new RESTResponseWrappers.PatientInfoWrapper((Patient__c) queriedPatients.get(0));
            res.responseBody = Blob.valueOf(JSON.serializePretty(responseWrapper, true));
            return;
        } else {
            queriedPatients = Database.query(queryBuilder.buildSOQL());
        }

        List<RESTResponseWrappers.PatientWrapper> patientWrappers = new List<RESTResponseWrappers.PatientWrapper>();

        for (Patient__c patient : (List<Patient__c>) queriedPatients) {
            patientWrappers.add(new RESTResponseWrappers.PatientWrapper(patient));
        }

        res.responseBody = Blob.valueOf(JSON.serializePretty(patientWrappers, true));
    }

    @HttpPost
    global static void createPatient() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        RESTResponseWrappers.PatientWrapper patientWrapper = (RESTResponseWrappers.PatientWrapper) JSON.deserialize(req.requestBody.toString(), RESTResponseWrappers.PatientWrapper.class);
        upsert patientWrapper.createPatientObject();

        res.statusCode = 201;
    }
}
