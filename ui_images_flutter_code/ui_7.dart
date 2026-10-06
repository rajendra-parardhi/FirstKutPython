import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // A common modern sans-serif font
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Light grey background for the whole page
      body: Center(
        child: Container(
          width: 380, // Approximate width of the card on a typical screen
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0), // Internal padding for the card
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the column take minimum vertical space
              children: <Widget>[
                // Blue Header with User Icon
                Container(
                  width: double.infinity, // Full width of the card's padding area
                  height: 150, // Height of the blue box
                  decoration: BoxDecoration(
                    color: const Color(0xFF3187E9), // Blue from JSON elements[3]
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 90, // Size of the user icon
                    ),
                  ),
                ),
                const SizedBox(height: 30), // Spacing below the blue header

                // Username Input Field
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5), // Very light grey background for input
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter username',
                      hintStyle: TextStyle(color: Color(0xFF888888)),
                      border: InputBorder.none, // Remove default border
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 20), // Spacing between input fields

                // Password Input Field
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5), // Very light grey background for input
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    obscureText: true, // Hide password
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      hintStyle: TextStyle(color: Color(0xFF888888)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      suffixIcon: Icon(
                        Icons.visibility,
                        color: Color(0xFF888888), // Eye icon color
                      ),
                    ),
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 30), // Spacing before the login button

                // Login Button
                SizedBox(
                  width: double.infinity, // Make button full width
                  height: 55, // Height of the button
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle login logic
                      print('Login button pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3187E9), // Blue color from JSON elements[3]
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Button border radius
                      ),
                      elevation: 0, // No shadow for a flat modern look, or add a subtle one
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600, // Semi-bold text
                      ),
                    ),
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