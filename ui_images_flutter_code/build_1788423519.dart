import 'package:flutter/material.dart';

class GeneratedUIScreen extends StatelessWidget {
  const GeneratedUIScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 512),
            child: Stack(
              children: [
          Positioned(
            left: 0.0, top: 0.0, width: 419.0, height: 419.0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFb6b6b6),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: const Text("", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}