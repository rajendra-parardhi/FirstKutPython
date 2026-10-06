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
        fontFamily: 'Roboto', // Assuming Roboto is available or similar sans-serif
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  // Colors derived from DesignIR and visual analysis
  static const Color _primaryBlue = Color(0xFF3b8dea); // From DesignIR
  static const Color _inputFieldBackground = Color(0xFFf3f3f3); // From DesignIR
  static const Color _placeholderTextColor = Color(0xFFA0A0A0); // Visual inference
  static const Color _screenBackground = Color(0xFFf9f9f9); // Visual inference for subtle off-white

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _screenBackground,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Make column only take needed space
                children: [
                  // Profile Icon Container
                  Container(
                    width: 150,
                    height: 100,
                    decoration: BoxDecoration(
                      color: _primaryBlue,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ),
                  const SizedBox(height: 35.0), // Spacing below icon container

                  // Username Input Field
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter username',
                      hintStyle: const TextStyle(color: _placeholderTextColor),
                      filled: true,
                      fillColor: _inputFieldBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none, // No border
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    ),
                    style: const TextStyle(color: Color(0xFF333333)), // Darker text for input
                  ),
                  const SizedBox(height: 20.0), // Spacing between input fields

                  // Password Input Field
                  TextFormField(
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      hintStyle: const TextStyle(color: _placeholderTextColor),
                      filled: true,
                      fillColor: _inputFieldBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none, // No border
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: _placeholderTextColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(color: Color(0xFF333333)), // Darker text for input
                  ),
                  const SizedBox(height: 30.0), // Spacing before login button

                  // Login Button
                  SizedBox(
                    width: double.infinity, // Make button take full width
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18.0), // Larger padding
                        elevation: 5, // Subtle shadow for the button
                      ),
                      onPressed: () {
                        // Handle login logic
                        debugPrint('Login button pressed');
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
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
      ),
    );
  }
}