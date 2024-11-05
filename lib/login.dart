// ignore_for_file: body_might_complete_normally_nullable, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:learning_app/forgot_pass.dart';
import 'package:learning_app/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _fireBase = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  var _enteredEmail = "";
  var _enteredPassWord = "";

  Future<void> _submit() async {
    final isValid = _form.currentState!.validate();

    if (isValid) {
      _form.currentState!.save();
      try {
        // ignore: unused_local_variable
        final userCredential = await _fireBase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassWord);

        print(userCredential.user?.uid);
      } on FirebaseAuthException catch (error) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).clearSnackBars();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? "Authentication failed."),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ), // language setting here.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // add padding like this const SizedBox(height:20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
              ),
            ),
            const StylizedText(
              "Sign in to app",
            ),
            Form(
              key: _form,
              child: Column(
                children: [
                  // Email Address field
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.10,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')) {
                          return "Enter a valid email address";
                        }
                      },
                      onSaved: (newValue) {
                        _enteredEmail = newValue!;
                      },
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      cursorColor: const Color.fromARGB(255, 87, 87, 87),
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(188, 185, 185, 185),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        labelText: 'Email Address',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(150, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),

                  // Password field
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.11,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().length < 6) {
                          return "Password invalid";
                        }
                      },
                      onSaved: (newValue) {
                        _enteredPassWord = newValue!;
                      },
                      cursorColor: const Color.fromARGB(255, 87, 87, 87),
                      obscureText: true,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(188, 185, 185, 185),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(150, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                      ),
                      onPressed: _submit,
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: TextButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgotPass()),
                        );
                      },
                      child: const Text(
                        "Forgot Password",
                        style: TextStyle(
                          color: Color.fromARGB(150, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
