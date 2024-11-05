



import 'package:flutter/material.dart';

class StylizedText extends StatelessWidget {
  const StylizedText(this.text, {super.key});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:  const TextStyle(
        color: Color.fromARGB(150, 0, 0, 0),
        fontSize: 22,
        height: 5
      ),
    );
  }
}
