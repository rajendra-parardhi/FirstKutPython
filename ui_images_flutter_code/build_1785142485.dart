import 'package:flutter/material.dart';

class FirstKutAI_Generated_Layout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Color(0xFFf5f7fa),
            height: 1534,
          ),
          Container(
            color: Colors.white,
            width: 253,
            height: 1534,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Color(0xFFc2dbf6),
                width: 670,
                height: 1158,
              ),
              Container(
                color: Color(0xFF3c8eea),
                width: 571,
                height: 271,
              ),
            ],
          ),
          Column(
            children: [
              Text(
                '',
                style: TextStyle(color: Color(0xFFf3f3f3)),
              ),
              SizedBox(height: 60),
              Text(
                '',
                style: TextStyle(color: Color(0xFFf1f1f1)),
              ),
              SizedBox(height: 75),
              ElevatedButton(
                onPressed: () {},
                child: Text('Login'),
                style: ElevatedButton.styleFrom(primary: Color(0xFF3187e9)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}