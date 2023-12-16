import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'createaccount.dart'; // Import your create account screen file
import 'home_screen.dart'; // Import your home screen file

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _showErrorDialog(String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showForgotPasswordDialog() async {
    // Implement the logic to reset the password here
    // You can use Firebase authentication service to send a password reset email
    // Example: await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> _loginUser() async {
    try {
      UserCredential userCredential;

      // Check if the entered value in usernameController is an email
      if (usernameController.text.contains('@')) {
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernameController.text,
          password: passwordController.text,
        );
      } else {
        // If not an email, assume it's a username
        // You should implement your own logic for fetching user information using the username
        // For simplicity, I'm assuming the username is stored in the 'username' field in Firestore
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: usernameController.text)
            .get();

        if (querySnapshot.docs.isEmpty) {
          // Username not found
          throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'No user found with this username.',
          );
        }

        String userEmail = querySnapshot.docs.first['email'];

        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userEmail,
          password: passwordController.text,
        );
      }

      User? user = userCredential.user;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      print("Error logging in: $e");
      String errorMessage = 'An error occurred while logging in.';

      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found with this email/username.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Incorrect password.';
        }
      }

      _showErrorDialog(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'Assets/iiitlogo.jpeg',
                height: 100,
                width: 100,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Username/Email',
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loginUser,
                child: Text('LOG IN'),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color.fromARGB(255, 0, 40, 99)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: _showForgotPasswordDialog,
                child: Text('Forgot Password?'),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateAccountScreen()),
                  );
                },
                child: Text(
                  'Do not have an account yet?',
                  style: TextStyle(color: Color.fromARGB(255, 0, 40, 99)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
