import 'package:app_dev_alumni_connect_project_sem5/Screens/chat.dart';
import 'package:app_dev_alumni_connect_project_sem5/Screens/forumscreen.dart';
import 'package:app_dev_alumni_connect_project_sem5/Screens/home_screen.dart';
import 'package:app_dev_alumni_connect_project_sem5/Screens/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chatlist extends StatefulWidget {
  const Chatlist({Key? key}) : super(key: key);

  @override
  State<Chatlist> createState() => _ChatlistState();
}

class _ChatlistState extends State<Chatlist> {
  // Instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Sign user out

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Chats',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: _buildUserList(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.black),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people, color: Colors.black),
            label: 'Forums',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color: Colors.black),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail, color: Colors.black),
            label: 'Chats',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: (index) {
          // Define actions for each item when pressed
          switch (index) {
            case 0: // Home
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1: // Search
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              ); // Add actions for Search screen
              break;
            case 2: // Forums
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ForumScreen()),
              );
              break;
            case 3: // Notifications
              // Add actions for Notifications screen
              break;
            case 4: // Chats
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Chatlist()),
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading..');
          // CircularProgressIndicator();
        }
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  // Build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // Display all users except the current user
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        leading: Icon(Icons.person), // Add a person icon
        title: Text(data['name'] ?? ''), // Use 'name' field from Firestore
        onTap: () {
          // Pass the clicked user's UID to the chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserEmail: data['email'],
                receiverUserId: data['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
