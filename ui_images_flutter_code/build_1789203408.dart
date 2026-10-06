import 'package:flutter/material.dart';

class ReconstructedUIScreen extends StatelessWidget {
  const ReconstructedUIScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: SizedBox(
          width: 512,
          height: 1024,
          child: Stack(
            children: [
          Positioned(left: 0.0, top: 0.0, width: 1916.0, height: 1916.0, child: Container(decoration: BoxDecoration(color: Color(0xFF918e8f), borderRadius: BorderRadius.circular(6.0)), child: Center(child: Text("Starred Snoozed D Important Sent Bo Scheduled 0 Drafts Q All Mail Spam Trash Message clipped View entire message 8 Social Updates 659 Reply Forward Forums More 29 ENG 13.50 Rain showers Search IN 6 d 0 12-09-2026", style: const TextStyle(color: Colors.white, fontSize: 12))))),
            ],
          ),
        ),
      ),
    );
  }
}