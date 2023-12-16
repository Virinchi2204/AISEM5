import 'package:app_dev_alumni_connect_project_sem5/Screens/home_screen.dart';
import 'package:app_dev_alumni_connect_project_sem5/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'welcomescreen.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController graduationYearController = TextEditingController();
  TextEditingController userTypeController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    graduationYearController.dispose();
    userTypeController.dispose();
    branchController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Account',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Name',
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Email',
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: graduationYearController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Year of Graduation',
            ),
          ),
          SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: userTypeController.text.isNotEmpty
                ? userTypeController.text
                : null,
            decoration: InputDecoration(
              hintText: 'You Are',
            ),
            items: ['Current Student', 'Alumni'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                userTypeController.text = value ?? '';
              });
            },
          ),
          SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value:
                branchController.text.isNotEmpty ? branchController.text : null,
            decoration: InputDecoration(
              hintText: 'Branch',
            ),
            items: ['CSE', 'DSAI', 'ECE'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                branchController.text = value ?? '';
              });
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: usernameController,
            decoration: InputDecoration(
              hintText: 'Choose a Username',
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Enter Password',
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Re-enter Password',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              int graduationYear =
                  int.tryParse(graduationYearController.text) ?? 0;

              if ((graduationYear >= 2025 &&
                      userTypeController.text == 'Alumni') ||
                  (graduationYear < 2025 &&
                      userTypeController.text == 'Current Student')) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Please enter valid data.'),
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
              } else {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  User? user = userCredential.user;
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user?.uid)
                      .set({
                    'uid': userCredential.user!.uid,
                    'name': nameController.text,
                    'email': emailController.text,
                    'graduationYear': graduationYearController.text,
                    'userType': userTypeController.text,
                    'branch': branchController.text,
                    'username': usernameController.text,
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } catch (e) {
                  print("Error creating account: $e");
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text(
                            'An error occurred while creating the account.'),
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
                ;
              }
            },
            child: Text('Create Account'),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 0, 40, 99)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text(
              'Already have an account? Log In',
              style: TextStyle(color: Color.fromARGB(255, 0, 40, 99)),
            ),
          ),
        ],
      ),
    );
  }
}
