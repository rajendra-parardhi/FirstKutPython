import 'package:flutter/material.dart';

class ReconstructedUIScreen extends StatelessWidget {
  const ReconstructedUIScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d0d12),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
          Positioned(
            left: 0.0, top: 0.0, width: 500.0, height: 1596.0,
            child: TextField(
              decoration: InputDecoration(
                hintText: "12.30 Slot Booking Full Name Email Mobile Number Location Slot Message Write a message",
                filled: true,
                fillColor: const Color(0xFF1e293b),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
              ),
            ),
          ),
          Positioned(
            left: 43.0, top: 256.0, width: 496.0, height: 71.0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF292b34),
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text("Enter your name", style: const TextStyle(color: Color(0xFFf8fafc))),
            ),
          ),
          Positioned(
            left: 43.0, top: 403.0, width: 496.0, height: 71.0,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Enter email address",
                filled: true,
                fillColor: const Color(0xFF1e293b),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
              ),
            ),
          ),
          Positioned(
            left: 43.0, top: 553.0, width: 496.0, height: 68.0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF272830),
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text("Enter you number", style: const TextStyle(color: Color(0xFFf8fafc))),
            ),
          ),
          Positioned(
            left: 43.0, top: 700.0, width: 496.0, height: 71.0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF23232a),
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text("Select location", style: const TextStyle(color: Color(0xFFf8fafc))),
            ),
          ),
          Positioned(
            left: 43.0, top: 846.0, width: 496.0, height: 81.0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF222229),
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text("Select slot", style: const TextStyle(color: Color(0xFFf8fafc))),
            ),
          ),
          Positioned(
            left: 484.0, top: 871.0, width: 34.0, height: 31.0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF56575c),
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text("", style: const TextStyle(color: Color(0xFFf8fafc))),
            ),
          ),
          Positioned(
            left: 21.0, top: 1493.0, width: 540.0, height: 75.0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFe65c55),
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text("Send", style: const TextStyle(color: Color(0xFFf8fafc))),
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }
}