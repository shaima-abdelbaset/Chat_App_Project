import 'package:cubitchatapp/constant.dart';
import 'package:cubitchatapp/helper/showsnackbar.dart';
import 'package:cubitchatapp/views/chatpage.dart';
import 'package:cubitchatapp/views/signpage.dart';
import 'package:cubitchatapp/widgets/customwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widgets/CustomButton.dart';

class Loginpage extends StatefulWidget {
  Loginpage({Key? key}) : super(key: key);
  static String id = 'login Page';

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  String? email;
  String? password;
  bool isLoading = false; // Renamed to `isLoading` for better readability
  GlobalKey<FormState> formKey = GlobalKey(); // Correctly defined the form key

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      // Used `isLoading` to show/hide the progress indicator
      child: Scaffold(
        backgroundColor: KPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formKey, // Assigned the form key here
            child: ListView(
              children: [
                SizedBox(height: 80),
                Image.asset(
                  'assets/images/scholar.png',
                  height: 120,
                ),
                Center(
                  child: Text(
                    'Scholar Chat', // Corrected spelling to 'Scholar'
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 60),
                Row(
                  children: [
                    Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
                SizedBox(height: 15),
                CustomFormTextField(
                  onChanged: (data) {
                    email = data; // Capture email input
                  },
                  hinttxt: 'Email', // Corrected hint text
                ),
                SizedBox(height: 15),
                CustomFormTextField(
                  obsecur: true,
                  onChanged: (data) {
                    password = data; // Capture password input
                  },
                  hinttxt: 'Password', // Corrected hint text
                  //obscureText: true, // Added to obscure password input
                ),
                SizedBox(height: 15),
                CustomButton(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true; // Show loading indicator
                      });
                      try {
                        await loginUser();
                        Navigator.pushNamed(context, Chatpage.id,arguments:email );

                        // Navigate to the chat page upon successful login
                      } on FirebaseAuthException catch (e) {

                        // Handle specific FirebaseAuth exceptions
                        if (e.code == 'user-not-found') {
                          ShowSnackBar(context, 'No user found for that email');
                        } else if (e.code == 'wrong-password') {
                          ShowSnackBar(context, 'Wrong password provided for that user.');
                        }
                        else{
                          ShowSnackBar(context, 'There was an error');
                        }
                      }
                      catch (e) {
                        print(e);
                        ShowSnackBar(context, 'There was an error');
                      }
                      setState(() {
                        isLoading = false; // Hide loading indicator
                      });
                    }
                  },
                  text: 'LOGIN',
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterPage.id); // Navigate to the register page
                      },
                      child: Text(
                        '  Register',
                        style: TextStyle(color: Color(0xffC7EDE6)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
