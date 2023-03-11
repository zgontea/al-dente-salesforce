@RestResource(urlMapping = '/Patient/*')
global without sharing class PatientRESTController {

    @HttpGet
    global static List<RESTResponseWrappers.PatientWrapper> getAll() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<RESTResponseWrappers.PatientWrapper> patientWrappers = new List<RESTResponseWrappers.PatientWrapper>();
        for (Patient__c patient : [SELECT First_Name__c, Last_Name__c, Gender__c, Birth_Date__c, PESEL__c, Phone_Number__c FROM Patient__c]) {
            patientWrappers.add(new RESTResponseWrappers.PatientWrapper(patient));
        }
        return patientWrappers;
    }

    @HttpPost
    global static void createPatient() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        RESTResponseWrappers.PatientWrapper patientWrapper = (RESTResponseWrappers.PatientWrapper) JSON.deserialize(req.requestBody.toString(), RESTResponseWrappers.PatientWrapper.class);
        insert patientWrapper.createPatientObject();

        res.statusCode = 201;
    }
}