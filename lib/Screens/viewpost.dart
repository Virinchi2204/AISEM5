import 'package:app_dev_alumni_connect_project_sem5/Screens/home_screen.dart';
import 'package:flutter/material.dart';

class ViewPostScreen extends StatelessWidget {
  final String userId;
  final String postType;
  final String postText;

  ViewPostScreen({
    required this.userId,
    required this.postType,
    required this.postText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.white,
  title: Text(
    'Post',
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
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
    },
  ),
),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with person icon, username, and post type
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 0, 40, 99),
                  radius: 15,
                  child: Icon(Icons.person, color: Colors.white, size: 14),
                ),
                SizedBox(width: 8),
                Text('By: $userId', style: TextStyle(fontSize: 12)),
                SizedBox(width: 8),
                Text('Post Type: $postType', style: TextStyle(fontSize: 12)),
              ],
            ),
            // Post text
            SizedBox(height: 10),
            Text(postText, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
