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
          color: Color(0xFF1c1e22),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'AirAware Al Smart Dashbc localhost 8501 8 0 Chat Deploy AirAware Smart Air Quality Analytics Control Panel Dashboard Status Active Target City Ahmedabad Enable Admin Mode',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Container(
                color: Color(0xFFa4757b),
                width: 41,
                height: 99,
              ),
              Text(
                'Ahmedabad',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              Text(
                '105',
                style: TextStyle(color: Color(0xFF3c302c), fontSize: 20),
              ),
              Container(
                color: Color(0xFF6b8a72),
                width: 103,
                height: 180,
              ),
              Text(
                'DAAn',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              Spacer(),
              Container(
                color: Color(0xFF1d1d1d),
                height: 427,
              ),
            ],
          ),
        ),
      ),
    );
  }
}