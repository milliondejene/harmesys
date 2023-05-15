// ignore_for_file: library_private_types_in_public_api, file_names, unused_local_variable, depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import './models/Patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'Controllers/patientSearch.dart';

class HarmeClinicManagementSystem extends StatefulWidget {
  const HarmeClinicManagementSystem({Key? key}) : super(key: key);

  @override
  _HarmeClinicManagementSystemState createState() =>
      _HarmeClinicManagementSystemState();
}

class _HarmeClinicManagementSystemState
    extends State<HarmeClinicManagementSystem> {
  String query = '';
  final List<Patient> _allPatients = [];
  List<Patient> _filteredList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPatientsFromJsonFile();
  }

  void onSearchTextChanged(String query) {
    PatientSearch.onSearchTextChanged(
      _allPatients,
      query,
      (filteredList) {
        setState(() {
          _filteredList = filteredList;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(13, 37, 87, 0.8),
        centerTitle: true,
        title: const Text('Harme Clinic Management System'),
      ),
      backgroundColor: const Color.fromRGBO(255, 255, 255, 0.894),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              controller: _searchController,
              onChanged: onSearchTextChanged,
              decoration: InputDecoration(
                hintText: 'Search by   * Name * Phone * Patient ID',
                hintStyle: const TextStyle(
                  fontSize: 20.0,
                  color: Color.fromRGBO(13, 37, 87, 0.8),
                ),
                prefixIcon: const Icon(
                  color: Color.fromRGBO(13, 37, 87, 0.8),
                  Icons.search,
                  size: 30,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredList.length,
              itemBuilder: (context, index) {
                final patient = _filteredList.map((patient) => patient);
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      _editPatient(index);
                    } else {
                      _removePatient(index);
                    }
                  },
                  background: Container(
                    color: const Color.fromRGBO(13, 37, 87, 0.8),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 36),
                    child:
                        const Icon(Icons.edit, size: 38.0, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: const Color.fromRGBO(209, 106, 98, 0.7),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 36),
                    child: const Icon(Icons.delete,
                        size: 38.0, color: Colors.white),
                  ),
                  child: Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(241, 241, 241, 0.8),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        title: Text(
                          _filteredList[index].name,
                          style: const TextStyle(
                            color: Color.fromRGBO(13, 37, 87, 0.7),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Patient ID: ${_filteredList[index].patientId}",
                              style: const TextStyle(
                                color: Color.fromRGBO(13, 37, 87, 0.9),
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              "Phone Number: ${_filteredList[index].phoneNumber}",
                              style: const TextStyle(
                                color: Color.fromRGBO(13, 37, 87, 0.6),
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              "Gender: ${_filteredList[index].gender}",
                              style: const TextStyle(
                                color: Color.fromRGBO(13, 37, 87, 0.6),
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              "Age: ${_filteredList[index].age}",
                              style: const TextStyle(
                                color: Color.fromRGBO(13, 37, 87, 0.6),
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              "Diagnosis: ${_filteredList[index].diagnosis}",
                              style: const TextStyle(
                                color: Color.fromRGBO(13, 37, 87, 0.6),
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FloatingActionButton(
                backgroundColor: const Color.fromRGBO(13, 37, 87, 0.8),
                onPressed: () => _savePatientsCopyToLocal(context),
                heroTag: "fab1",
                child: const Icon(
                  Icons.settings_backup_restore_rounded,
                  size: 38.0,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FloatingActionButton(
                backgroundColor: const Color.fromRGBO(13, 37, 87, 0.8),
                onPressed: () => _addPatient(),
                heroTag: "fab2",
                child: const Icon(
                  Icons.add,
                  size: 38.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addPatient() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    TextEditingController diagnosisController = TextEditingController();
    TextEditingController genderController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController patientIdController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
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
                    setState(() {
                      _allPatients.add(newPatient);
                    });
                    _savePatientsToJsonFile();
                    Navigator.pop(context);
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
      },
    );
  }

  void _editPatient(int index) async {
    TextEditingController nameController =
        TextEditingController(text: _allPatients[index].name);
    TextEditingController ageController =
        TextEditingController(text: _allPatients[index].age.toString());
    TextEditingController genderController =
        TextEditingController(text: _allPatients[index].gender);
    TextEditingController phoneNumberController =
        TextEditingController(text: _allPatients[index].phoneNumber.toString());
    TextEditingController diagnosisController =
        TextEditingController(text: _allPatients[index].diagnosis);
    TextEditingController patientIdController =
        TextEditingController(text: _allPatients[index].patientId.toString());
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Patient'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Patient updatedPatient = Patient(
                  name: nameController.text,
                  phoneNumber: phoneNumberController.text,
                  patientId: patientIdController.text,
                  age: int.parse(ageController.text),
                  diagnosis: diagnosisController.text,
                  gender: genderController.text,
                );
                setState(() {
                  _allPatients[index] = updatedPatient;
                });
                _savePatientsToJsonFile();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _removePatient(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Patient'),
          content: const Text('Are you sure you want to delete this patient?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  _allPatients.removeAt(index);
                });
                _savePatientsToJsonFile();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    if (kDebugMode) {
      print(directory);
    }
    final file = File('${directory.path}/patients.json');
    if (kDebugMode) {
      print(file);
    }
    if (!file.existsSync()) {
      await file.create();
    }
    return file;
  }

  void _loadPatientsFromJsonFile() async {
    try {
      final file = await _getLocalFile();
      String contents = await file.readAsString();
      final data = await json.decode(contents);
      setState(() {
        for (Map<String, dynamic> patient in data) {
          _allPatients.add(Patient.fromJson(patient));
        }
        _filteredList = _allPatients;
      });
      if (kDebugMode) {
        print('Loaded ${_allPatients.length} patients');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _savePatientsCopyToLocal(BuildContext context) async {
    try {
      // Ask user for the file name
      String? fileName = await _getFileNameFromUser();
      if (fileName != null && fileName.isNotEmpty) {
        // Get the directory where the user wants to save the file
        Directory? directory;
        if (await Permission.manageExternalStorage.request().isGranted) {
          // If the app has permission to access external storage, use SAF to let the user choose a directory
          final result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: [''],
            allowMultiple: false,
          );

          if (result != null && result.files.isNotEmpty) {
            final path = result.files.single.path;
            if (path != null) {
              directory = Directory(path);
            }
          }
        } else {
          // If the app doesn't have permission to access external storage, show an error message
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Permission to access storage denied.'),
          ));
        }

        if (directory != null) {
          // Create the file path by joining the directory path and file name
          String filePath = p.join(directory.path, '$fileName.json');

          // Check if file with same name already exists
          if (await File(filePath).exists()) {
            if (kDebugMode) {
              print('File already exists, copy operation cancelled');
            }
          } else {
            // Read the contents of the patient file
            String contents =
                await _getLocalFile().then((file) => file.readAsString());
            List<dynamic> patients = json.decode(contents);

            // Create a new file and write the contents to it
            await File(filePath).writeAsString(json.encode(patients));

            if (kDebugMode) {
              print('Patients copied successfully to $filePath');
            }
          }
        }
      } else {
        if (kDebugMode) {
          print('Invalid file name, copy operation cancelled');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<String> _getFileNameFromUser() async {
    String? fileName = await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text("Save JSON file as..."),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: "File name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim()),
            ),
          ],
        );
      },
    );
    return fileName ?? "";
  }

  void _savePatientsToJsonFile() async {
    final file = await _getLocalFile();
    List<Map<String, dynamic>> jsonList =
        _allPatients.map((patient) => patient.toJson()).toList();
    String jsonStr = jsonEncode(jsonList);
    file.writeAsString(jsonStr);
  }
}
