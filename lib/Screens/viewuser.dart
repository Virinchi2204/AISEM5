import 'package:app_dev_alumni_connect_project_sem5/Screens/chat.dart';
import 'package:app_dev_alumni_connect_project_sem5/Screens/search.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewUserScreen extends StatelessWidget {
  final String username;

  ViewUserScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'User Profile',
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
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          },
        ),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: username)
            .limit(1)
            .get()
            .then((snapshot) => snapshot.docs.first),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('User not found.'));
          }

          Map<String, dynamic> userData = snapshot.data!.data()!;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 100,
                  child: Icon(Icons.person, color: Colors.white, size: 100),
                ),
                SizedBox(height: 30),
                Text(
                  userData['name'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '@${userData['username']}',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${userData['branch']} ${userData['graduationYear']}',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 30),
                IconButton(
                  icon: Icon(
                    Icons.mail,
                    size: 50,
                  ),
                  onPressed: () {
                    // Navigate to the ChatPage with the selected user's information
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          receiverUserEmail: userData['email'],
                          receiverUserId: userData['uid'],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

