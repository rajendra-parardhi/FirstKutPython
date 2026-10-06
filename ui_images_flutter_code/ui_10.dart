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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto', // Using Roboto for consistency with web example
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Define colors based on JSON and visual inspection
    const Color primaryBlue = Color(0xFF3186EC); // #3186ec
    const Color buttonBlue = Color(0xFF2780EC);  // #2780ec
    const Color inputBg = Color(0xFFF0F0F1);     // #f0f0f1
    const Color placeholderColor = Color(0xFFA0A0A0); // #a0a0a0
    const Color pageBg = Color(0xFFF0F2F5);      // Similar to #eef1f6 for page background

    const double cardContentWidth = 309.0; // Based on bbox width
    const double cardPadding = 30.0;
    const double cardWidth = cardContentWidth + (2 * cardPadding); // 309 + 60 = 369

    return Scaffold(
      backgroundColor: pageBg,
      body: Center(
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Card border radius
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: cardWidth,
            padding: const EdgeInsets.all(cardPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Blue header container with user icon
                Container(
                  width: cardContentWidth,
                  height: 156, // From JSON bbox
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(15), // Rounded corners for logo container
                  ),
                  margin: const EdgeInsets.only(bottom: 30), // Space before first input
                  child: const Icon(
                    Icons.person,
                    size: 80, // Large user icon
                    color: Colors.white,
                  ),
                ),

                // Username Input Field
                SizedBox(
                  width: cardContentWidth,
                  height: 58, // From JSON bbox
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter username',
                      hintStyle: const TextStyle(color: placeholderColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Input field border radius
                        borderSide: BorderSide.none, // No border
                      ),
                      filled: true,
                      fillColor: inputBg,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                    cursorColor: primaryBlue,
                    keyboardType: TextInputType.text,
                  ),
                ),

                const SizedBox(height: 20), // Space between input fields

                // Password Input Field
                SizedBox(
                  width: cardContentWidth,
                  height: 58, // From JSON bbox
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      hintStyle: const TextStyle(color: placeholderColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Input field border radius
                        borderSide: BorderSide.none, // No border
                      ),
                      filled: true,
                      fillColor: inputBg,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      suffixIcon: const Icon(Icons.visibility, color: placeholderColor), // Eye icon
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                    cursorColor: primaryBlue,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ),

                const SizedBox(height: 30), // Space before login button

                // Login Button
                SizedBox(
                  width: cardContentWidth,
                  height: 66, // From JSON bbox
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle login logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonBlue, // Button background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16), // Button border radius
                      ),
                      padding: EdgeInsets.zero, // Remove default padding as size is fixed
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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