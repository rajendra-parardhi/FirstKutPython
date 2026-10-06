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
            left: 0.0, top: 0.0, width: 1916.0, height: 1076.0,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cten 6 Coda Cimthecic HTMI Flutter 34 ENG 1302 Partly sunny Search IN c c 30062026",
                filled: true,
                fillColor: const Color(0xFF242228),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
          ),
          Positioned(
            left: 0.0, top: 1083.0, width: 1916.0, height: 412.0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
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