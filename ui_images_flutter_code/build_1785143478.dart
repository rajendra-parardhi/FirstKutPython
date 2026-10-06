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
          color: Color(0xFFFBF8FC),
          child: Column(
            children: [
              Spacer(flex: 1),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 39, vertical: 211),
                decoration: BoxDecoration(color: Color(0xFFE78DE8)),
                child: Text('Welcome Back', style: TextStyle(fontSize: 48)),
              ),
              Spacer(flex: 1),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 1756, vertical: 161),
                decoration: BoxDecoration(color: Color(0xFFECECEE)),
                child: Text('Please login to continue', style: TextStyle(fontSize: 48)),
              ),
              Spacer(flex: 1),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 334, vertical: 446),
                decoration: BoxDecoration(color: Color(0xFFE3E3E4)),
                child: Text('AI Model XGBoost Regressor', style: TextStyle(fontSize: 48)),
              ),
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}