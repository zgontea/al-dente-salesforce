@RestResource(urlMapping = '/Patient/*')
global without sharing class PatientRESTController {

    @HttpGet
    global static List<PatientWrapper> getAll() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<PatientWrapper> patientWrappers = new List<PatientWrapper>();
        for (Patient__c patient : [SELECT First_Name__c, Last_Name__c, Gender__c, Birth_Date__c, PESEL__c FROM Patient__c]) {
            patientWrappers.add(new PatientWrapper(patient));
        }
        return patientWrappers;
    }

    @HttpPost
    global static void createPatient() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        PatientWrapper patientWrapper = (PatientWrapper) JSON.deserialize(req.requestBody.toString(), PatientWrapper.class);
        insert patientWrapper.createPatientObject();

        res.statusCode = 201;
    }

    global class PatientWrapper {
        String firstName;
        String lastName;
        String gender;
        String pesel;
        Date birthdate;

        public PatientWrapper(Patient__c patient) {
            firstName = patient.First_Name__c;
            lastName = patient.Last_Name__c;
            gender = patient.Gender__c;
            birthdate = patient.Birth_Date__c;
            pesel = patient.PESEL__c;
        }

        public Patient__c createPatientObject() {
            return new Patient__c(
                Name = firstName + ' ' + lastName,
                First_Name__c = firstName,
                Last_Name__c = lastName,
                Gender__c = gender,
                PESEL__c = pesel,
                Birth_Date__c = birthdate
            );
        }
    }
}