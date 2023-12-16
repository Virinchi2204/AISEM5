// import 'package:app_dev_alumni_connect_project_sem5/Screens/createforum.dart';
// import 'package:app_dev_alumni_connect_project_sem5/Screens/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ForumScreen extends StatelessWidget {
//   Future<String?> fetchUserType() async {
//     try {
//       // Get the current user ID
//       String? userId = FirebaseAuth.instance.currentUser?.uid;

//       // Fetch the user document from Firestore
//       DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
//           .instance
//           .collection('users')
//           .doc(userId)
//           .get();

//       // Retrieve the userType from the user document
//       if (snapshot.exists) {
//         Map<String, dynamic> userData = snapshot.data()!;
//         return userData['userType'] ?? 'Student';
//       }
//     } catch (e) {
//       print("Error fetching userType: $e");
//       // Handle the error as needed
//     }
//     return 'Student'; // Default value
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           'FORUMS',
//           style: TextStyle(
//             color: Colors.black,
//           ),
//         ),
//         actions: [
//           FutureBuilder<String?>(
//             future: fetchUserType(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Container(); // You can show a loading indicator here
//               }

//               String userType = snapshot.data ?? 'Student';

//               return (userType == 'Alumni')
//                   ? Row(
//                       children: [
//                         IconButton(
//                           color: Colors.black,
//                           icon: Icon(Icons.add),
//                           onPressed: () {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => CreateForumScreen()),
//                             );
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.group),
//                           color: Colors.black,
//                           onPressed: () {
//                             // Handle joining a forum
//                             // For example, show a dialog or navigate to JoinForumScreen
//                           },
//                         ),
//                       ],
//                     )
//                   : IconButton(
//                       icon: Icon(Icons.group),
//                       color: Colors.black,
//                       onPressed: () {
//                         // Handle joining a forum
//                         // For example, show a dialog or navigate to JoinForumScreen
//                       },
//                     );
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: Text('Forum Content Goes Here'),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home, color: Colors.black),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search, color: Colors.black),
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people, color: Colors.black),
//             label: 'Forums',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.notifications, color: Colors.black),
//             label: 'Notifications',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.mail, color: Colors.black),
//             label: 'Chats',
//           ),
//         ],
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.black,
//         onTap: (index) {
//           // Define actions for each item when pressed
//           switch (index) {
//             case 0: // Home
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => HomeScreen()),
//               );
//               break;
//             case 1: // Search
//               // Add actions for the Search screen
//               break;
//             case 2: // Forums
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => ForumScreen()),
//               );
//               break;
//             case 3: // Notifications
//               // Add actions for the Notifications screen
//               break;
//             case 4: // Chats
//               // Add actions for the Chats screen
//               break;
//           }
//         },
//       ),
//     );
//   }
// }
// import 'package:app_dev_alumni_connect_project_sem5/Screens/home_screen.dart';
// import 'package:app_dev_alumni_connect_project_sem5/Screens/search.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'createforum.dart';  // Import the CreateForumScreen if not already imported
// import 'viewforum.dart';  // Import the ViewForumScreen if not already imported

// class ForumScreen extends StatefulWidget {
//   @override
//   _ForumScreenState createState() => _ForumScreenState();
// }

// class _ForumScreenState extends State<ForumScreen> {
//   Future<List<Map<String, dynamic>>> fetchUserForums() async {
//     try {
//       String? userId = FirebaseAuth.instance.currentUser?.uid;

//       // Fetch the user document from Firestore
//       DocumentSnapshot<Map<String, dynamic>> userSnapshot =
//           await FirebaseFirestore.instance.collection('users').doc(userId).get();

//       if (userSnapshot.exists) {
//         Map<String, dynamic> userData = userSnapshot.data()!;
//         String username = userData['username'];

//         // Fetch forums where the user is a member
//         QuerySnapshot<Map<String, dynamic>> forumSnapshot = await FirebaseFirestore
//             .instance
//             .collection('forums')
//             .where('members', arrayContains: username)
//             .get();

//         // Return a list of forums
//         return forumSnapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
//           return {
//             'forumId': doc.id,
//             'forumName': doc['forumName'],
//             'createdBy': doc['createdBy'],
//           };
//         }).toList();
//       }
//     } catch (e) {
//       print("Error fetching user forums: $e");
//     }

//     return []; // Return an empty list if there's an error
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           'FORUMS',
//           style: TextStyle(
//             color: Colors.black,
//           ),
//         ),
//         actions: [
//           Row(
//             children: [
//               IconButton(
//                 color: Colors.black,
//                 icon: Icon(Icons.add),
//                 onPressed: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => CreateForumScreen()),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: fetchUserForums(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           List<Map<String, dynamic>> forums = snapshot.data ?? [];

//           return ListView.builder(
//             itemCount: forums.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(forums[index]['forumName']),
//                 subtitle: Text('Created by: ${forums[index]['createdBy']}'),
//                 onTap: () {
//                   // Navigate to ViewForumScreen with the selected forumId
//                   // Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(
//                   //     builder: (context) => ViewForumScreen(
//                   //       forumId: forums[index]['forumId'],
//                   //     ),
//                   //   ),
//                   // );
//                 },
//               );
//             },
//           );
//         },
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home, color: Colors.black),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search, color: Colors.black),
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people, color: Colors.black),
//             label: 'Forums',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.notifications, color: Colors.black),
//             label: 'Notifications',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.mail, color: Colors.black),
//             label: 'Chats',
//           ),
//         ],
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.black,
//         onTap: (index) {
//           // Define actions for each item when pressed
//           switch (index) {
//             case 0: // Home
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => HomeScreen()),
//               );
//               break;
//             case 1: // Search
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => SearchScreen()),
//               ); // Add actions for Search screen
//               break;
//             case 2: // Forums
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => ForumScreen()),
//               );
//               break;
//             case 3: // Notifications
//               // Add actions for Notifications screen
//               break;
//             case 4: // Chats
//               // Add actions for Chats screen
//               break;
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:app_dev_alumni_connect_project_sem5/Screens/home_screen.dart';
import 'package:app_dev_alumni_connect_project_sem5/Screens/joinforum.dart';
import 'package:app_dev_alumni_connect_project_sem5/Screens/search.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'createforum.dart'; // Import the CreateForumScreen if not already imported
import 'viewforum.dart'; // Import the ViewForumScreen if not already imported

class ForumScreen extends StatefulWidget {
  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  Future<List<Map<String, dynamic>>> fetchUserForums() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      // Fetch the user document from Firestore
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data()!;
        String username = userData['username'];

        // Fetch forums where the user is a member
        QuerySnapshot<Map<String, dynamic>> forumSnapshot =
            await FirebaseFirestore.instance
                .collection('forums')
                .where('members', arrayContains: username)
                .get();

        // Return a list of forums
        return forumSnapshot.docs
            .map((DocumentSnapshot<Map<String, dynamic>> doc) {
          return {
            'forumId': doc.id,
            'forumName': doc['forumName'],
            'createdBy': doc['createdBy'],
          };
        }).toList();
      }
    } catch (e) {
      print("Error fetching user forums: $e");
    }

    return []; // Return an empty list if there's an error
  }

  Future<String?> fetchUserType() async {
    try {
      // Get the current user ID
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      // Fetch the user document from Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();

      // Retrieve the userType from the user document
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data()!;
        return userData['userType'] ?? 'Student';
      }
    } catch (e) {
      print("Error fetching userType: $e");
      // Handle the error as needed
    }
    return 'Student'; // Default value
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'FORUMS',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          FutureBuilder<String?>(
            future: fetchUserType(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); // You can show a loading indicator here
              }

              String userType = snapshot.data ?? 'Student';

              if (userType == 'Alumni') {
                return Row(
                  children: [
                    IconButton(
                      color: Colors.black,
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateForumScreen()),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.group),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JoinForumsScreen()),
                        );
                        // Handle joining a forum
                        // For example, show a dialog or navigate to JoinForumScreen
                      },
                    ),
                  ],
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.group),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => JoinForumsScreen()),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchUserForums(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<Map<String, dynamic>> forums = snapshot.data ?? [];

          return ListView.builder(
            itemCount: forums.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      Colors.grey, // Customize the background color as needed
                  child: Icon(Icons.computer_rounded, color: Colors.white),
                ),
                title: Text(forums[index]['forumName']),
                subtitle: Text('Created by: ${forums[index]['createdBy']}'),
                onTap: () {
                  // Navigate to ViewForumScreen with the selected forumId
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewForumScreen(
                        forumName: forums[index]['forumName'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
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
    );
  }
}
