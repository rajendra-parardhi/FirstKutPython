import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth Screen',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF6B4A6A),
      ),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 738),
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF6B4A6A),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  // Decorative top/right shapes
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 144,
                      height: 134,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD5A6C9),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(32),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 148,
                          height: 87,
                          decoration: const BoxDecoration(
                            color: Color(0xFF7B4568),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 148,
                          height: 90,
                          decoration: const BoxDecoration(
                            color: Color(0xFFB16A8D),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 148,
                          height: 144,
                          decoration: const BoxDecoration(
                            color: Color(0xFFC66C89),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main Content Layout
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 32.0,
                          horizontal: 24.0,
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            bool isWide = constraints.maxWidth > 500;
                            return Flex(
                              direction: isWide ? Axis.horizontal : Axis.vertical,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Welcome Back Card
                                Expanded(
                                  flex: isWide ? 1 : 0,
                                  child: const AuthCard(
                                    title: "Welcome Back",
                                    buttonText: "Sign In",
                                    buttonColor: Color(0xFFC0648D),
                                    accentColor: Color(0xFF554C5B),
                                    cardColor: Color(0xFF423341),
                                  ),
                                ),
                                const SizedBox(width: 
24, height: 24),
                                // Get Started Free Card
                                Expanded(
                                  flex: isWide ? 1 : 0,
                                  child: const AuthCard(
                                    title: "Get Started Free",
                                    buttonText: "Sign Up",
                                    buttonColor: Color(0xFFC2658F),
                                    accentColor: Color(0xFF483F4D),
                                    cardColor: Color(0xFF423242),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      // Bottom Accent Bar
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: const Color(0xFFC95C62),
                      ),
                    ],
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

class AuthCard extends StatelessWidget {
  final String title;
  final String buttonText;
  final Color buttonColor;
  final Color accentColor;
  final Color cardColor;

  const AuthCard({
    Key? key,
    required this.title,
    required this.buttonText,
    required this.buttonColor,
    required this.accentColor,
    required this.cardColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            decoration: InputDecoration(
              hintText: "Email / Username",
              filled: true,
              fillColor: Colors.black12,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password",
              filled: true,
              fillColor: Colors.black12,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                padding: const EdgeInsets.vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}