global class RESTResponseWrappers {

    global class PatientWrapper {
        public Id id;
        public String firstName;
        public String lastName;
        public String gender;
        public String pesel;
        public String phoneNumber;
        public Date birthdate;

        global PatientWrapper(Patient__c patient) {
            id = patient.Id;
            firstName = patient.First_Name__c;
            lastName = patient.Last_Name__c;
            gender = patient.Gender__c;
            phoneNumber = patient.Phone_Number__c;
            birthdate = patient.Birth_Date__c;
            pesel = patient.PESEL__c;
        }

        global PatientWrapper(Visit__c visit) {
            firstName = visit.Patient__r.First_Name__c;
            lastName = visit.Patient__r.Last_Name__c;
            phoneNumber = visit.Patient__r.Phone_Number__c;
            pesel = visit.Patient__r.PESEL__c;
        }

        global Patient__c createPatientObject() {
            return new Patient__c(
                Name = firstName + ' ' + lastName,
                First_Name__c = firstName,
                Last_Name__c = lastName,
                Phone_Number__c = phoneNumber,
                Gender__c = gender,
                PESEL__c = pesel,
                Birth_Date__c = birthdate
            );
        }
    }

    global class VisitWrapper {
        public Id id;
        public Id patientId;
        public Datetime startTime;
        public Datetime endTime;
        public String status;
        public PatientWrapper patient;

        global VisitWrapper(Visit__c visit) {
            id = visit.Id;
            patientId = visit.Patient__c;
            startTime = visit.Start_Time__c;
            endTime = visit.End_Time__c;
            status = visit.Status__c;
            patient = new PatientWrapper(visit);
        }

        global Visit__c createVisitObject() {
            return new Visit__c(
                Start_Time__c = startTime,
                End_Time__c = endTime,
                Status__c = status
            );
        }
    }
}