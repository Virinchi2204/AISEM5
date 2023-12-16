import 'package:app_dev_alumni_connect_project_sem5/Screens/chat.dart';
import 'package:app_dev_alumni_connect_project_sem5/Screens/chatlist.dart';
import 'package:app_dev_alumni_connect_project_sem5/Screens/createpost.dart';
import 'package:app_dev_alumni_connect_project_sem5/Screens/forumscreen.dart';
import 'package:app_dev_alumni_connect_project_sem5/Screens/search.dart';
import 'package:app_dev_alumni_connect_project_sem5/Screens/viewpost.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset(
          'Assets/iiitlogo.jpeg',
          height: 40,
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            // Open the drawer using the scaffold key
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: BlogList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the create post screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostScreen()),
          );
        },
        child: Icon(
          Icons.create, // Pencil icon
          color: Colors.white,
        ),
        backgroundColor: Color.fromARGB(255, 0, 40, 99),
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
              );// Add actions for Search screen
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 40, 99),
              ),
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    Map<String, dynamic> userData =
                        snapshot.data?.data() as Map<String, dynamic>;
                    String name = userData['name'] ?? 'User Name';
                    String username = userData['username'] ?? '';

                    return GestureDetector(
                      onTap: () {
                        // Add navigation logic or any action when the person icon is tapped
                        print('Person icon tapped');
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            name,
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '@$username',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } catch (e) {
                  print("Error during logout: $e");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BlogList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          var posts = snapshot.data!.docs;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              var post = posts[index];
              // Customize the UI for each post as needed
              return ListTile(
                onTap: () {
                  // Navigate to ViewPostScreen when a post is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewPostScreen(
                        userId: post['userId'],
                        postType: post['postType'],
                        postText: post['postText'],
                      ),
                    ),
                  );
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with person icon, username, and post type
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 0, 40, 99),
                          radius: 7,
                          child:
                              Icon(Icons.person, color: Colors.white, size: 14),
                        ),
                        SizedBox(width: 8),
                        Text('By: ${post['userId']}',
                            style: TextStyle(fontSize: 12)),
                        SizedBox(width: 8),
                        Text('Post Type: ${post['postType']}',
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    // Post text
                    Text(post['postText'], style: TextStyle(fontSize: 16)),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
