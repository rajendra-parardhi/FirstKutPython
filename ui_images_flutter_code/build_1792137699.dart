import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign In Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const SignInScreen(),
    );
  }
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Container(
              height: 77,
              width: double.infinity,
              color: const Color(0xFF007BDC),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              alignment: Alignment.centerLeft,
              child: const Text(
                'APP HEADER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 638),
                      child: AspectRatio(
                        aspectRatio: 638 / 310,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Left Welcome Banner (id: 8)
                            Positioned(
                              left: 20,
                              top: 0,
                              width: 240,
                              height: 242,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1171BF),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Small accent tag (id: 11)
                                    Container(
                                      width: 21,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF88B7D8),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'WELCOME',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Your HeadLine NaME',
                                      style: TextStyle(
                                        color: Color(0xFFE0F0FF),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Accent Box Left Bottom (id: 5)
                            Positioned(
                              left: 20,
                              top: 177,
                              width: 95,
                              height: 109,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0169BB),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),

                            // Main Sign In Card (id: 10)
                            Positioned(
                              left: 140,
                              top: 0,
                              width: 412,
                              height: 286,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF9ABEDB),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.12),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    // Top Accent Tag (id: 9)
                                    Positioned(
                                      left: 23,
                                      top: 60,
                                      width: 14,
                                      height: 14,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF6CA7CE),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),

                                    // Avatar/Image Container (id: 1)
                                    Positioned(
                                      left: 29,
                                      top: 130,
                                      width: 114,
                                      height: 114,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1371BD),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          size: 60,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),

                                    // Form Area
                                    Positioned(
                                      left: 170,
                                      top: 20,
                                      right: 20,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Sign in',
                                            style: TextStyle(
                                              color: Color(0xFF003366),
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 16),

                                          // Input Container (id: 7)
                                          Container(
                                            height: 40,
                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE9EAEA),
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(
                                                color: const Color(0xFFCCCCCC),
                                              ),
                                            ),
                                            child: const TextField(
                                              decoration: InputDecoration(
                                                hintText: 'Enter account detail',
                                                border: InputBorder.none,
                                                isDense: true,
                                                contentPadding: EdgeInsets.symmetric(vertical: 10),
                                              ),
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                          const SizedBox(height: 16),

                                          // Sign in Button (id: 2)
                                          SizedBox(
                                            width: double.infinity,
                                            height: 38,
                                            child: ElevatedButton(
                                              onPressed: () {},
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFF10497D),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                elevation: 0,
                                              ),
                                              child: const Text(
                                                'Sing in',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),

                                          // Secondary Button (id: 4)
                                          SizedBox(
                                            width: double.infinity,
                                            height: 38,
                                            child: OutlinedButton(
                                              onPressed: () {},
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: const Color(0xFFEDEDED),
                                                side: const BorderSide(color: Color(0xFFCCCCCC)),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                              ),
                                              child: const Text(
                                                'sing Kin other',
                                                style: TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Accent Box Bottom Right (id: 0)
                            Positioned(
                              left: 498,
                              top: 230,
                              width: 54,
                              height: 57,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF409EE8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Footer Bar (id: 6)
            Container(
              height: 78,
              width: double.infinity,
              color: const Color(0xFF00467E),
              alignment: Alignment.center,
              child: const Text(
                '© 2025 All Rights Reserved',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}