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
      title: 'Sign In App',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
      ),
      home: const SignInScreen(),
    );
  }
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar (id: 3)
            Container(
              height: 77,
              width: double.infinity,
              color: const Color(0xFF007BDC),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.dashboard_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'PORTAL ACCESS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            
            // Main Body Content
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 638),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Floating Decorative Container (id: 0)
                          Positioned(
                            right: -10,
                            bottom: -15,
                            child: Container(
                              width: 54,
                              height: 57,
                              decoration: BoxDecoration(
                                color: const Color(0xFF409EE8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          
                          // Accent Underlay (id: 5)
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: Container(
                              width: 95,
                              height: 109,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0169BB),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                ),
                              ),
                            ),
                          ),
                          
                          // Main Container Box combining Welcome Card & Sign In Box
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left Banner / Welcome Card (id: 8)
                              Expanded(
                                flex: 4,
                                child: Container(
                                  height: 286,
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF1171BF),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Decorative badge (id: 11)
                                      Container(
                                        width: 21,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF88B7D8),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      const Text(
                                        'WELCOME',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'YOUR HEADLINE NAME',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Right Card - Sign In Container (id: 10)
                              Expanded(
                                flex: 6,
                                child: Container(
                                  height: 286,
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF9ABEDB),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          // Accent dot (id: 9)
                                          Container(
                                            width: 14,
                                            height: 14,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF6CA7CE),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Expanded(
                                            child: Text(
                                              'sign in',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xFF10497D),
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          // Avatar/Image Container (id: 1)
                                          Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1371BD),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Icon(
                                              Icons.person_outline_rounded,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          // Form fields section
                                          Expanded(
                                            child: Column(
                                              children: [
                                                // Text Field / Password box (id: 7)
                                                Container(
                                                  height: 36,
                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFE9EAEA),
                                                    borderRadius: BorderRadius.circular(6),
                                                    border: Border.all(color: Colors.white54),
                                                  ),
                                                  child: Row(
                                                    children: const [
                                                      Expanded(
                                                        child: TextField(
                                                          obscureText: true,
                                                          style: TextStyle(fontSize: 12),
                                                          decoration: InputDecoration(
                                                            hintText: 'Password',
                                                            border: InputBorder.none,
                                                            isDense: true,
                                                            contentPadding: EdgeInsets.zero,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        'SHOW',
                                                        style: TextStyle(
                                                          color: Color(0xFF10497D),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 12),

                                                // Primary Sign In Button (id: 2)
                                                SizedBox(
                                                  height: 32,
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: const Color(0xFF10497D),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                      elevation: 0,
                                                    ),
                                                    onPressed: () {},
                                                    child: const Text(
                                                      'sign in',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),

                                                // Secondary Button (id: 4)
                                                SizedBox(
                                                  height: 32,
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: const Color(0xFFEDEDED),
                                                      foregroundColor: const Color(0xFF333333),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                      elevation: 0,
                                                    ),
                                                    onPressed: () {},
                                                    child: const Text(
                                                      'Sign in with other',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Footer Bar (id: 6)
            Container(
              height: 78,
              width: double.infinity,
              color: const Color(0xFF00467E),
              alignment: Alignment.center,
              child: const Text(
                '© 2025 All Rights Reserved',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}