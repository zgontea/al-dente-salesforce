@RestResource(urlMapping = '/Visit/*')
global without sharing class VisitRESTController {

    @HttpGet
    global static void getAll() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        List<RESTResponseWrappers.VisitWrapper> visitWrappers = new List<RESTResponseWrappers.VisitWrapper>();
        for (Visit__c visit : [SELECT Start_Time__c, End_Time__c, Status__c, Patient__c, Patient__r.First_Name__c, Patient__r.Last_Name__c, Patient__r.PESEL__c, Patient__r.Phone_Number__c FROM Visit__c]) {
            visitWrappers.add(new RESTResponseWrappers.VisitWrapper(visit));
        }

        res.responseBody = Blob.valueOf(JSON.serializePretty(visitWrappers, true));
    }

    @HttpPost
    global static void createVisit() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        RESTResponseWrappers.VisitWrapper visitWrapper = (RESTResponseWrappers.VisitWrapper) JSON.deserialize(req.requestBody.toString(), RESTResponseWrappers.VisitWrapper.class);
        Visit__c visit = visitWrapper.createVisitObject();
        visit.Patient__c = visitWrapper.patient.id;

        insert visit;

        res.statusCode = 201;
    }
}