import 'package:app_dev_alumni_connect_project_sem5/Screens/forumscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewForumScreen extends StatelessWidget {
  final String forumName;

  ViewForumScreen({required this.forumName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Forum',
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.computer,
              size: 300,
              color: Color.fromARGB(255, 0, 40, 99),
            ),
            SizedBox(height: 20),
            Text(
              forumName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('forums')
                  .where('forumName', isEqualTo: forumName)
                  .limit(1)
                  .get()
                  .then((snapshot) => snapshot.docs.first),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Text('Error loading forum details.');
                }

                Map<String, dynamic> forumData = snapshot.data!.data()!;

                return Column(
                  children: [
                    Text('${forumData['forumDescription']}'),
                    Text('Created by: ${forumData['createdBy']}'),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        // Handle showing members as dropdown
                        showMembersDropdown(context, forumData['members']);
                      },
                      child: Text(
                        'Members',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 40, 99),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void showMembersDropdown(BuildContext context, List<dynamic> members) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Members',
            style: TextStyle(color: Color.fromARGB(255, 0, 40, 99)),
          ),
          content: Column(
            children: members.map((member) => Text(member)).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
