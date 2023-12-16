import 'package:app_dev_alumni_connect_project_sem5/Screens/forumscreen.dart';
import 'package:app_dev_alumni_connect_project_sem5/Screens/home_screen.dart';
import 'package:app_dev_alumni_connect_project_sem5/Screens/viewuser.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _usersList = [];

  @override
  void initState() {
    super.initState();
    // Load users list from Firestore on screen initialization
    _loadUsersList();
  }

  void _loadUsersList() async {
    // Retrieve users from Firestore
    QuerySnapshot usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    // Convert users data to a list
    List<Map<String, dynamic>> usersList = [];
    usersSnapshot.docs.forEach((DocumentSnapshot document) {
      Map<String, dynamic> userData = document.data() as Map<String, dynamic>;
      usersList.add(userData);
    });

    // Update the state with the loaded users list
    setState(() {
      _usersList = usersList;
    });
  }

  void _filterUsers(String query) {
    // Filter users based on the search query
    List<Map<String, dynamic>> filteredUsers = _usersList
        .where((user) =>
            user['name'].toLowerCase().contains(query.toLowerCase()) ||
            user['username'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Update the state with the filtered users list
    setState(() {
      _usersList = filteredUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.search, color: Colors.black),
          onPressed: () {
            // // Navigate back to the previous screen (HomeScreen)
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => ForumScreen()),
            // );
          },
        ),
        title: TextField(
          controller: _searchController,
          onChanged: _filterUsers,
          decoration: InputDecoration(
            hintText: 'Search users...',
            border: InputBorder.none,
          ),
        ),
        backgroundColor: Colors.white,
      ),
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
              // Add actions for Chats screen
              break;
          }
        },
      ),
      body: ListView.builder(
        itemCount: _usersList.length,
        itemBuilder: (context, index) {
          var user = _usersList[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  Colors.grey, // Customize the background color as needed
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(user['name']),
            subtitle: Text('@${user['username']}'),
            // You can customize the UI for each user as needed
            onTap: () {
              // Navigate to ViewUserScreen when tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ViewUserScreen(username: user['username']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
