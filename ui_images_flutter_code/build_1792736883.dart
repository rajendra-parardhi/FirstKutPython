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
        scaffoldBackgroundColor: const Color(0xFF1E1926),
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AspectRatio(
              aspectRatio: 738 / 414,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFF6B4A6A),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double w = constraints.maxWidth;
                    final double h = constraints.maxHeight;

                    double scaleX(double x) => (x / 738.0) * w;
                    double scaleY(double y) => (y / 414.0) * h;

                    return Stack(
                      children: [
                        // Bottom background container
                        Positioned(
                          left: scaleX(0),
                          top: scaleY(250),
                          width: scaleX(738),
                          height: scaleY(164),
                          child: Container(
                            color: const Color(0xFFC95C62),
                          ),
                        ),

                        // Top header decorative shape (Left artwork)
                        Positioned(
                          left: scaleX(0),
                          top: scaleY(20),
                          width: scaleX(144),
                          height: scaleY(134),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFD5A6C9),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                              ),
                            ),
                          ),
                        ),

                        // Top header decorative center block
                        Positioned(
                          left: scaleX(305),
                          top: scaleY(66),
                          width: scaleX(119),
                          height: scaleY(79),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFB781A8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        // Small accent dots/containers
                        Positioned(
                          left: scaleX(214),
                          top: scaleY(41),
                          width: scaleX(21),
                          height: scaleY(15),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D2B4B),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        Positioned(
                          left: scaleX(446),
                          top: scaleY(41),
                          width: scaleX(23),
                          height: scaleY(23),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF51335A),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),

                        // Right stacked decorative blocks
                        Positioned(
                          left: scaleX(588),
                          top: scaleY(126),
                          width: scaleX(148),
                          height: scaleY(87),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF7B4568),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: scaleX(588),
                          top: scaleY(184),
                          width: scaleX(148),
                          height: scaleY(90),
                          child: Container(
                            color: const Color(0xFFB16A8D),
                          ),
                        ),
                        Positioned(
                          left: scaleX(588),
                          top: scaleY(227),
                          width: scaleX(148),
                          height: scaleY(144),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFC66C89),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                              ),
                            ),
                          ),
                        ),

                        // Card 1: "Welcome Back"
                        Positioned(
                          left: scaleX(147),
                          top: scaleY(31),
                          width: scaleX(155),
                          height: scaleY(348),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF423341),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 12),
                                const Text(
                                  "Welcome Back",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const Spacer(),
                                // Input bar simulation
                                Container(
                                  height: scaleY(5),
                                  width: scaleX(93),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF554C5B),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const Spacer(),
                                // Button "sontp" / Sign In
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {},
                                    borderRadius: BorderRadius.circular(8),

                                    child: Container(
                                      height: scaleY(32),
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xFFC0648D),
                                          width: 1.5,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        "Sign In",
                                        style: TextStyle(
                                          color: Color(0xFFC0648D),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),

                        // Card 2: "Get Started Free"
                        Positioned(
                          left: scaleX(428),
                          top: scaleY(31),
                          width: scaleX(158),
                          height: scaleY(348),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF423242),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 12),
                                const Text(
                                  "Get Started Free",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const Spacer(),
                                // Input Box
                                Container(
                                  height: scaleY(21),
                                  width: scaleX(119),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF483F4D),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                const Spacer(),
                                // Button "chenup" / Sign Up
                                Material(
                                  color: const Color(0xFFC2658F),
                                  borderRadius: BorderRadius.circular(8),
                                  child: InkWell(
                                    onTap: () {},
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      height: scaleY(32),
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Bottom small accent icon
                                Container(
                                  width: scaleX(23),
                                  height: scaleY(18),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4B3D3F),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 4),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}