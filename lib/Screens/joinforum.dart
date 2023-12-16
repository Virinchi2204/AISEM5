import 'package:app_dev_alumni_connect_project_sem5/Screens/forumscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JoinForumsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Join a Forum',
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
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('forums').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No forums available.'));
          }

          List<DocumentSnapshot<Map<String, dynamic>>> forumDocs =
              snapshot.data!.docs;

          return ListView.builder(
            itemCount: forumDocs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> forumData = forumDocs[index].data()!;
              String forumName = forumData['forumName'];

              return ListTile(
                title: Text(forumName),
                onTap: () {
                  // Show confirmation dialog when a forum is tapped
                  showJoinConfirmationDialog(context, forumName);
                },
              );
            },
          );
        },
      ),
    );
  }

  void showJoinConfirmationDialog(BuildContext context, String forumName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Join'),
          content: Text('Confirm you would like to join $forumName?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                // Add user to forumMembers list in Firestore
                await joinForum(forumName);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForumScreen()),
                );
                ; // Close the dialog
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> joinForum(String forumName) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      // Fetch the user document from Firestore
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      if (userSnapshot.exists) {
        String username = userSnapshot['username'];

        // Add user to forumMembers list in the selected forum
        await FirebaseFirestore.instance
            .collection('forums')
            .where('forumName', isEqualTo: forumName)
            .limit(1)
            .get()
            .then((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            DocumentReference forumRef = snapshot.docs.first.reference;
            forumRef.update({
              'members': FieldValue.arrayUnion([username]),
            });
          }
        });
      }
    } catch (e) {
      print("Error joining forum: $e");
      // Handle the error as needed
    }
  }
}
