import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final _usernameController = TextEditingController();
  File? _imageFile;
  bool _isSaving = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async { //uploads image to Firestore
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = await storageRef.putFile(image);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> _saveProfile() async { //saves profile picture and username to Firestore
    setState(() {
      _isSaving = true;
    });

    try {
      String? profileImageUrl;

      if (_imageFile != null) {
        final uploadedImageUrl = await _uploadImage(_imageFile!);
        if (uploadedImageUrl != null) {
          profileImageUrl = uploadedImageUrl;
        }
      }

      final userData = {
        'username': _usernameController.text,
        'profileImageUrl': profileImageUrl ?? '',
      };

      await FirebaseFirestore.instance.collection('users').add(userData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile saved successfully!')),
      );

      setState(() {
        _usernameController.clear();
        _imageFile = null;
      });
    } catch (e) {
      print("Error saving profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile.')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_imageFile != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: FileImage(_imageFile!),
              )
            else
              CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            TextButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image),
              label: Text('Select Profile Picture'),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Enter your name'),
            ),
            SizedBox(height: 20),
            if (_isSaving) CircularProgressIndicator(),
            if (!_isSaving)
              ElevatedButton(
                onPressed: _saveProfile,
                child: Text('Save'),
              ),
          ],
        ),
      ),
    );
  }
}
