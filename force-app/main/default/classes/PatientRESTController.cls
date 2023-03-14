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
        insert patientWrapper.createPatientObject();

        res.statusCode = 201;
    }

    private static void setHeaders() {
        RestResponse res = RestContext.response;
        res.addHeader('Access-Control-Allow-Origin', '*');
        res.addHeader('Content-Type', 'application/json');
    }
}