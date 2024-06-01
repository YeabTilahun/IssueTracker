import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:issuetracker/service/auth.dart';
import 'package:issuetracker/theme.dart';

class ReportIssue extends StatefulWidget {
  const ReportIssue({super.key});

  @override
  State<ReportIssue> createState() => _ReportIssueState();
}

void showOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              // Navigate to profile screen
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              AuthService().signout();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
        ],
      );
    },
  );
}

// ignore: camel_case_types
class _ReportIssueState extends State<ReportIssue> {
  late String _selectedCategory = 'Pothole';
  final List<String> _categories = [
    'Pothole',
    'Damaged road',
    'Damaged traffic light',
    'Light outages',
    'Water shortage',
    'Blocked road',
    'Blocked drain',
    'Blocked sewer',
    'Flood',
    'Blocked storm drain',
    'Blocked water main',
    'Blocked fire hydrant',
    'Blocked sidewalk',
    'Damaged traffic signal',
    'Blocked crosswalk',
    'Blocked bike lane',
    'Broken street light',
  ];
  CollectionReference issues = FirebaseFirestore.instance.collection('issues');
  String imageUrl = '';
  File? get imageFile => _imageFile;
  File? _imageFile;
  String? get description => _descriptionController.text;
  String? get location => _locationController.text;
  String? get Category => _locationController.text;
  String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

  final ImagePicker _imagePicker = ImagePicker();

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  Future<void> _pickImage() async {
    final XFile? pickedFile;

    pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
    // handle the database image upload
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child("Images");
    Reference referenceImageToUpload = referenceDirImages.child(uniqueId);
    try {
      // this get the image url from database
      await referenceImageToUpload.putFile(_imageFile!);
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (e) {}
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          // backgroundColor: const Color.fromRGBO(96, 125, 139, 1),
          title: const Text('Report Issue'),
          actions: <Widget>[
            GestureDetector(
                onTap: () {
                  showOptions(context);
                },
                child: SizedBox(
                  height: 45,
                  width: 45,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      user?.photoURL ??
                          'https://www.gravatar.com/avatar/placeholder',
                    ),
                  ),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Select Issue Type',
                  ),
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(13.0),
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.image,
                            size: 100,
                          ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    if (imageUrl == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select an image'),
                        ),
                      );
                      return;
                    }
                    Map<String, String> dataToSend = {
                      'name': user!.displayName!
                          .substring(0, user.displayName!.indexOf(' ')),
                      'email': user.email!,
                      'description': _descriptionController.text,
                      'location': _locationController.text,
                      'category': _selectedCategory,
                      'imageUrl': imageUrl,
                      'status': 'pending'
                    };
                    issues.add(dataToSend);
                    _descriptionController.text = '';
                    _locationController.text = '';
                    imageUrl = '';
                    _imageFile = null;

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Issue has been added successfully. Thank you!',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.black,
                    ));
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(
                  FontAwesomeIcons.exclamationCircle,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/issue');
                },
              ),
              label: 'Issue',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(
                  FontAwesomeIcons.user,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              label: 'profile',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(
                  FontAwesomeIcons.bell,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/notification');
                },
              ),
              label: 'notification',
            ),
          ],
        ),
      ),
    );
  }
}
