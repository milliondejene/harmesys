import '../models/Patient.dart';

class PatientSearch {
  static void onSearchTextChanged(List<Patient> allPatients, String query,
      Function(List<Patient>) onFilteredListChanged) {
    List<Patient> filteredList;
    if (query.isNotEmpty) {
      filteredList = allPatients
          .where((patient) =>
              patient.name
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              patient.patientId
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              patient.phoneNumber
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    } else {
      filteredList = allPatients;
    }

    onFilteredListChanged(filteredList);
  }
}
