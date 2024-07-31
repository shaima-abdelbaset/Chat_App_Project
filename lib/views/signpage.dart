import 'package:cubitchatapp/constant.dart';
import 'package:cubitchatapp/views/chatpage.dart';
import 'package:cubitchatapp/widgets/customwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/showsnackbar.dart';
import '../widgets/CustomButton.dart';

class RegisterPage extends StatefulWidget {
  static String id = 'RegisterPage';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email;
  String? password;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: KPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                SizedBox(height: 80),
                Image.asset('assets/images/scholar.png', height: 120),
                Center(
                  child: Text(
                    'Scholar Chat',
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
                      'Signup',
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
                    email = data;
                  },
                  hinttxt: 'Email',
                ),
                SizedBox(height: 15),
                CustomFormTextField(
                  onChanged: (data) {
                    password = data;
                  },
                  hinttxt: 'Password',
                 // obscureText: true, // Added to obscure password input
                ),
                SizedBox(height: 15),
                CustomButton(
                  onTap: () async {
                    var auth = FirebaseAuth.instance;
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await RegisterUser(auth);

                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          ShowSnackBar(context, 'The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          ShowSnackBar(context, 'The account already exists for that email.');
                        } //else {
                          //ShowSnackBar(context, e.message!); // Display other Firebase exceptions
                        //}
                      } catch (e) {
                        ShowSnackBar(context, 'There was an error.');
                      }
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  text: 'Register',
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        ' Login',
                        style: TextStyle(
                          color: Color(0xffC7EDE6),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 180),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> RegisterUser(FirebaseAuth auth) async {
    UserCredential user = await auth.createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
