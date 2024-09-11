import 'dart:io';
import 'package:bot_app/screen/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final TextEditingController _usernameController = TextEditingController();
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  // Function to pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }
Future<void> _saveProfile() async {
  setState(() {
    isLoading = true;
  });

  String username = _usernameController.text.trim();

  // Validate if the username is empty
  if (username.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter a username')),
    );
    setState(() {
      isLoading = false;
    });
    return;
  }

  // Validate if an image is selected
  if (_profileImage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select a profile image')),
    );
    setState(() {
      isLoading = false;
    });
    return;
  }

  try {
    // Get the user's ID from FirebaseAuth
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Upload the profile image to Firebase Storage
    String fileName = path.basename(_profileImage!.path);
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('profile_images/$userId/$fileName');

    UploadTask uploadTask = storageReference.putFile(_profileImage!);
    TaskSnapshot taskSnapshot = await uploadTask;

    // Get the image URL after uploading
    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    // Update the user's data in Firestore
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'username': username,
      'profilepicture': imageUrl,
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );

    // Navigate to the home page
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomePage()), 
      (_) => false,
    );
  } catch (e) {
    // Handle errors (e.g., network issues, Firebase issues)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error saving profile: $e')),
    );
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}


  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('assets/profile_placeholder.png')
                            as ImageProvider,
                    child: _profileImage == null
                        ? Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.grey[700],
                          )
                        : null,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text('Change Profile Picture')
              ],
            ),
            const SizedBox(height: 20),
            const Text('Edit Username'),
            const SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child:isLoading? const CircularProgressIndicator():ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
