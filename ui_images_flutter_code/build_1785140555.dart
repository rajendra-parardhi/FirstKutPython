import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Color(0xFF0e0f1c),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Color(0xFF1e1925),
                ),
              ),
              Container(
                height: 376,
                width: 220,
                color: Color(0xFF1a1b29),
              ),
              Container(
                height: 60,
                width: 64,
                color: Color(0xFF221f2b),
              ),
              Text('Heading', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              Container(
                height: 262,
                width: 391,
                color: Color(0xFF1f1014),
              ),
            ],
          ),
        ),
      ),
    );
  }
}