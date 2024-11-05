// ignore: file_names
import 'package:flutter/material.dart';
import 'package:learning_app/styles.dart';

class LoginSplash extends StatelessWidget {
  const LoginSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Route Sense"),centerTitle: true ,),
      body: const Center(
        child: StylizedText("Loading..."),
        ),
      );
  }
}