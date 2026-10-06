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
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.25,
                color: Color(0xFFfbfbfb),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Admin Upload New CSV', style: TextStyle(color: Colors.grey[700])),
                      SizedBox(height: 8),
                      Text('Data Source CPCB India', style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.35,
                color: Color(0xFFe5e5e8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Retrain Model', style: TextStyle(color: Colors.grey[700])),
                      SizedBox(height: 8),
                      Text('Data Preprocessing', style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.25,
                color: Color(0xFFf5f5f6),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Prediction Engine', style: TextStyle(color: Colors.grey[700])),
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.25,
                color: Color(0xFFe7e7e9),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Output Realtime AQI Score', style: TextStyle(color: Colors.grey[700])),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}