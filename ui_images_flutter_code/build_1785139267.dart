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
          color: Color(0xFF987568),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4.0)],
                  ),
                  color: Color(0xFF888490),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4.0)],
                  ),
                  color: Color(0xFF9695A4),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4.0)],
                  ),
                  color: Color(0xFF9B8C8D),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4.0)],
                  ),
                  color: Color(0xFF747C94),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4.0)],
                  ),
                  color: Color(0xFF6D768F),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4.0)],
                  ),
                  color: Color(0xFF987F79),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}