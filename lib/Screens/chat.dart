import 'package:app_dev_alumni_connect_project_sem5/Screens/chatlist.dart';
import 'package:app_dev_alumni_connect_project_sem5/chat/chatservice.dart';
import 'package:app_dev_alumni_connect_project_sem5/chat/components/chatbubble.dart';
import 'package:app_dev_alumni_connect_project_sem5/chat/components/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;

  const ChatPage({
    Key? key,
    required this.receiverUserEmail,
    required this.receiverUserId,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    // Only send a message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverUserId,
        _messageController.text,
      );

      // Clear the text controller after sending the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: _buildMessageList(),
          ),

          // User input
          _buildMessageInput(),

          const SizedBox(height: 25),
        ],
      ),
    );
  }

  // Build the app bar with username
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: FutureBuilder(
        // Fetch the username based on receiverUserId
        future: _getUsername(widget.receiverUserId),
        builder: (context, usernameSnapshot) {
          if (usernameSnapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading username..');
          }

          String username = usernameSnapshot.data.toString();

          return Text(
            username,
            style: TextStyle(
              color: Colors.black,
            ),
          );
        },
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          // Navigate back to the previous screen (HomeScreen)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Chatlist()),
          );
        },
      ),
    );
  }

  // Build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.receiverUserId,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // Build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // Align messages to the right if the sender is the current user, otherwise left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          mainAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(height: 5),
            ChatBubble(message: data['message']),
          ],
        ),
      ),
    );
  }

  // Build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          // Textfield
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Enter text',
              obscureText: false,
            ),
          ),

          // Send button
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_upward,
              size: 40,
            ),
          )
        ],
      ),
    );
  }

  Future<String> _getUsername(String userId) async {
    // Replace 'users' with the actual collection name where user information is stored
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc['username'].toString();
  }
}
