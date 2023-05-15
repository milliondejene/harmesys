import 'package:flutter/material.dart';

import '../models/Patient.dart';

class AddPatientDialog extends StatefulWidget {
  const AddPatientDialog({Key? key}) : super(key: key);

  @override
  _AddPatientDialogState createState() => _AddPatientDialogState();
}

class _AddPatientDialogState extends State<AddPatientDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController patientIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: const Text(
          'Add Patient',
          style: TextStyle(
            color: Color.fromRGBO(13, 37, 87, 0.9),
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: patientIdController,
              decoration: const InputDecoration(
                labelText: 'Patient ID',
              ),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: genderController,
              decoration: const InputDecoration(
                labelText: 'Gender',
              ),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
              ),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            TextField(
              controller: diagnosisController,
              decoration: const InputDecoration(
                labelText: 'Diagnosis',
              ),
            ),
          ],
        ),
        actions: [
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            child: const Text('Cancel'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              try {
                if (patientIdController.text.isEmpty) {
                  throw Exception("Please enter patient ID.💳");
                } else if (nameController.text.isEmpty) {
                  throw Exception("Please enter patient name.");
                } else if (genderController.text.isEmpty) {
                  throw Exception("Please enter patient Gender.⚥");
                } else if (ageController.text.isEmpty) {
                  throw Exception("Please enter patient Age.");
                } else if (phoneNumberController.text.isEmpty) {
                  throw Exception("Please enter patient Phone Number.📱");
                } else if (diagnosisController.text.isEmpty) {
                  throw Exception("Please enter a diagnosis.🤒");
                }
                Patient newPatient = Patient(
                  name: nameController.text,
                  phoneNumber: phoneNumberController.text,
                  patientId: patientIdController.text,
                  age: int.parse(ageController.text),
                  diagnosis: diagnosisController.text,
                  gender: genderController.text,
                );
                Navigator.pop(context, newPatient);
              } catch (e) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Error"),
                      content: Text(
                        e.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(" _OK "),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                const Color.fromRGBO(13, 37, 87, 0.8),
              ),
            ),
            child: const Text(' _Save '),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
