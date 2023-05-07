public class RESTResponseWrappers {
    public class PatientWrapper {
        public Id id;
        public String firstName;
        public String lastName;
        public String gender;
        public String pesel;
        public String phoneNumber;
        public Date birthdate;

        public PatientWrapper(Patient__c patient) {
            id = patient.Id;
            firstName = patient.First_Name__c;
            lastName = patient.Last_Name__c;
            gender = patient.Gender__c;
            phoneNumber = patient.Phone_Number__c;
            birthdate = patient.Birth_Date__c;
            pesel = patient.PESEL__c;
        }

        public Patient__c createPatientObject() {
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

    public class PatientInfoWrapper {
        public Id id;
        public String firstName;
        public String lastName;
        public String gender;
        public String pesel;
        public String phoneNumber;
        public Date birthdate;

        public List<Object> visits;

        public PatientInfoWrapper(Patient__c patient) {
            id = patient.Id;
            firstName = patient.First_Name__c;
            lastName = patient.Last_Name__c;
            gender = patient.Gender__c;
            phoneNumber = patient.Phone_Number__c;
            birthdate = patient.Birth_Date__c;
            pesel = patient.PESEL__c;

            visits = new List<VisitWrapper>();
            for (Visit__c visit : patient.Visits__r) {
                VisitWrapper wrapper = new VisitWrapper();
                wrapper.visitId = visit.Id;
                wrapper.startTime = getTime(visit.Start_Time__c);
                wrapper.endTime = getTime(visit.End_Time__c);
                wrapper.status = visit.Status__c;

                visits.add(wrapper);
            }
        }

        public Patient__c createPatientObject() {
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

    public class VisitWrapper {
        public Id visitId;
        public Id patientId;
        public Id doctorId;
        public String doctorName;
        public String consultingRoom;
        public String startTime;
        public String endTime;
        public String status;
        public String patientName;
        public String firstName;
        public String lastName;
        public String pesel;
        public String phoneNumber;

        public VisitWrapper() {}

        public VisitWrapper(Visit__c visit) {
            visitId = visit.Id;
            patientId = visit.Patient__c;
            doctorId = visit.Doctor__c;
            doctorName = visit.Doctor__r.Name;
            consultingRoom = visit.Consulting_Room__c;
            startTime = getTime(visit.Start_Time__c);
            endTime = getTime(visit.End_Time__c);
            status = visit.Status__c;
            firstName = visit.Patient__r.First_Name__c;
            lastName = visit.Patient__r.Last_Name__c;
            phoneNumber = visit.Patient__r.Phone_Number__c;
            pesel = visit.Patient__r.PESEL__c;
        }

        public Visit__c createVisitObject() {
            return new Visit__c(
                Patient__c = patientId,
                Doctor__c = doctorId,
                Start_Time__c = Datetime.valueOf(startTime),
                End_Time__c = Datetime.valueOf(endTime),
                Status__c = status,
                Consulting_Room__c = consultingRoom
            );
        }
    }

    public class VisitDateWrapper {
        public String day;
        public List<VisitWrapper> visits;

        public VisitDateWrapper(String day, List<VisitWrapper> visits) {
            this.day = day;
            this.visits = visits;
        }
    }

    public static String getTime(Datetime dt) {
        return String.valueOf(dt.hour()).leftPad(2, '0') + ':' + String.valueOf(dt.minute()).leftPad(2, '0');
    }

    public static String getDateAndDay(Datetime dt) {
        return dt.year() + '-' + String.valueOf(dt.month()).leftPad(2, '0') + '-' + String.valueOf(dt.day()).leftPad(2, '0') + ' ' + dt.format('EEEE');
    }

    public static Datetime getDatetimeFromString(String value) {
        List<String> selectedDayValues = value.split('-');
        return Datetime.newInstance(Integer.valueOf(selectedDayValues[2]), Integer.valueOf(selectedDayValues[1].replaceFirst('^0+', '')), Integer.valueOf(selectedDayValues[0].replaceFirst('^0+', '')));
    }
}
