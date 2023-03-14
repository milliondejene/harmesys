// ignore_for_file: file_names

class Patient {
  String name;
  int age;
  String gender;
  String diagnosis;
  String phoneNumber;
  String patientId;

  Patient(
      {required this.name,
      required this.age,
      required this.diagnosis,
      required this.gender,
      required this.phoneNumber,
      required this.patientId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['age'] = age;
    data['diagnosis'] = diagnosis;
    data['gender'] = gender;
    data['phoneNumber'] = phoneNumber;
    data['patientId'] = patientId;
    return data;
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      name: json['name'],
      age: json['age'],
      diagnosis: json['diagnosis'],
      gender: json['gender'],
      phoneNumber: json['phoneNumber'],
      patientId: json['patientId'],
    );
  }
}
