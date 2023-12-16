import 'package:app_dev_alumni_connect_project_sem5/Screens/viewforum.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forumscreen.dart';

class CreateForumScreen extends StatefulWidget {
  @override
  _CreateForumScreenState createState() => _CreateForumScreenState();
}

class _CreateForumScreenState extends State<CreateForumScreen> {
  TextEditingController forumNameController = TextEditingController();
  TextEditingController forumDescriptionController = TextEditingController();

  @override
  void dispose() {
    forumNameController.dispose();
    forumDescriptionController.dispose();
    super.dispose();
  }

  Future<void> createForum() async {
    try {
      // Get the current user ID
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      // Fetch the user document from Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();

      // Retrieve the username from the user document
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data()!;
        String createdBy = userData['username'] ?? '';

        // Create a new forum in the "forums" collection
        DocumentReference forumRef =
            await FirebaseFirestore.instance.collection('forums').add({
          'createdBy': createdBy,
          'forumName': forumNameController.text,
          'forumDescription': forumDescriptionController.text,
          'members': [createdBy], // Add the admin as the first member
        });

        // Navigate to the ViewForum screen with the newly created forumId (forumName)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ForumScreen(),
          ),
        );
      }
    } catch (e) {
      print("Error creating forum: $e");
      // Handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Create Forum',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Navigate back to the previous screen (HomeScreen)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForumScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: forumNameController,
              decoration: InputDecoration(
                hintText: 'Forum Name',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: forumDescriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Forum Description',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Add forum to Firestore
                await createForum();
              },
              child: Text('CREATE FORUM'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 0, 40, 99)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

