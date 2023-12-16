import 'package:app_dev_alumni_connect_project_sem5/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController postTextController = TextEditingController();
  String selectedPostType = 'General';

  @override
  void dispose() {
    postTextController.dispose();
    super.dispose();
  }

  // Function to add a post to Firestore
  Future<void> addPostToFirestore() async {
    // Get the user document
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      String postText = postTextController.text;

      // Get the current user ID (you need to replace this with your actual user ID retrieval logic)
      String userId = userData['username'] ?? '';

      // Add the post to Firestore
      await FirebaseFirestore.instance.collection('posts').add({
        'userId': userId,
        'postType': selectedPostType,
        'postText': postText,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      // Handle the case where the user document does not exist
      print('User document does not exist.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Navigate back to the previous screen (HomeScreen)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        title: Text(
          'Create Post',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedPostType,
              decoration: InputDecoration(
                labelText: 'Post Type',
              ),
              items: ['General', 'Job/Internship Opportunity', 'Academics']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedPostType = value ?? 'General';
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: postTextController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Post Text',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Add post to Firestore
                await addPostToFirestore();

                // Navigate to the home screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text('POST'),
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
