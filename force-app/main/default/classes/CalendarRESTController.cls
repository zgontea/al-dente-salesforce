@RestResource(urlMapping = '/Calendar/*')
global without sharing class CalendarRESTController {
    private static final String VISIT_FIELDS_TO_QUERY = 'Consulting_Room__c, Start_Time__c, End_Time__c, Status__c, Patient__c, Patient__r.First_Name__c, Patient__r.Last_Name__c, Patient__r.PESEL__c, Patient__r.Phone_Number__c, Doctor__c, Doctor__r.Name';

    @HttpGet
    global static void getCalendarData() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        try {
            Datetime selectedDay = RESTResponseWrappers.getDatetimeFromString(req.params.get('selectedDay'));
            Datetime selectedDayTo = selectedDay.addDays(1);
            Map<String, List<RESTResponseWrappers.VisitWrapper>> visitsByDoctor = new Map<String, List<RESTResponseWrappers.VisitWrapper>>();

            FilteredQueryBuilder queryBuilder = new FilteredQueryBuilder().setParams(req.params).setSObjectType('Visit__c').setFields(VISIT_FIELDS_TO_QUERY).setWhereField('Start_Time__c >= :selectedDay AND End_Time__c <= :selectedDayTo').setSortField('Start_Time__c').setSortType('ASC');
            List<SObject> queriedVisits = Database.query(queryBuilder.buildSOQL());

            for (Visit__c visit : (List<Visit__c>) queriedVisits) {
                String doctorName = visit.Doctor__r.Name;
                if (!visitsByDoctor.containsKey(doctorName)) {
                    visitsByDoctor.put(doctorName, new List<RESTResponseWrappers.VisitWrapper>());
                }
                visitsByDoctor.get(doctorName).add(new RESTResponseWrappers.VisitWrapper(visit));
            }

            res.responseBody = Blob.valueOf(JSON.serializePretty(visitsByDoctor, true));
        } catch(Exception ex) {
            res.statusCode = 422;
            res.responseBody = Blob.valueOf('Unprocessable Content');
            res.responseBody = Blob.valueOf(ex.getMessage());
        }
    }
}