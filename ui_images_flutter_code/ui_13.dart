import 'package:flutter/material.dart';
import 'dart:math'; // For tan in CustomPainter (though simplified to fixed points)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mahindra University Exam Attendance',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto', // Recommended sans-serif font
      ),
      home: const ExamAttendanceScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ExamAttendanceScreen extends StatelessWidget {
  const ExamAttendanceScreen({super.key});

  // Colors from JSON and visual inspection
  static const Color primaryRed = Color(0xFFB71C32); // From JSON
  static const Color cardBg = Color(0xFFF7EEF0); // Adjusted from F7EEF to F7EEF0 for a valid color
  static const Color bodyBg = Color(0xFFF8F2F8); // Light purple/pink from visual
  static const Color textDarkGrey = Color(0xFF4A4A4A);
  static const Color textMediumGrey = Color(0xFF8A8A8A);
  static const Color textLightGrey = Color(0xFFC0C0C0);
  static const Color statusBarText = Color(0xFFB1A7B1); // From JSON
  static const Color bottomNavBg = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBg,
      body: Column(
        children: [
          // Custom Status Bar (mimicking phone status bar)
          _buildStatusBar(),
          // Red Header
          Container(
            height: 120, // Approx. height from screenshot
            width: double.infinity,
            color: primaryRed,
          ),
          // Main Content Area with Card
          Expanded(
            child: SingleChildScrollView( // Allow scrolling if content is too large
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0), // Spacing below red header
                child: Center(
                  child: Card(
                    color: cardBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 8, // Subtle shadow
                    shadowColor: Colors.black.withOpacity(0.08),
                    margin: const EdgeInsets.symmetric(horizontal: 20), // Horizontal margin for the card
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Wrap content vertically
                        children: [
                          // Card Header (Logo & Exam System)
                          _buildCardHeader(),
                          const SizedBox(height: 30),
                          // Invigilator Tap Section
                          _buildInvigilatorTapSection(),
                          const SizedBox(height: 30),
                          // Card Footer
                          _buildCardFooter(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Bottom Navigation Bar
          _buildBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 15),
      color: Colors.transparent, // Assumes the area under the system status bar is transparent
      child: SafeArea( // Ensures content is not obscured by system UI
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '15:17',
                  style: TextStyle(color: statusBarText, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 5),
                // Placeholder for 'a' icon/notification
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusBarText.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.wifi, color: statusBarText, size: 18),
                const SizedBox(width: 5),
                Icon(Icons.signal_cellular_alt, color: statusBarText, size: 18),
                const SizedBox(width: 5),
                Text(
                  '69%',
                  style: TextStyle(color: statusBarText, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 2),
                Icon(Icons.battery_full, color: statusBarText, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color.fromARGB(255, 230, 230, 230), width: 1), // Subtle separator
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Mahindra University Logo & Text
          Row(
            children: [
              // Mahindra Logo - Custom painting for complex shape
              _buildMahindraLogo(),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Mahindra',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: textDarkGrey),
                  ),
                  Text(
                    'University',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: textDarkGrey),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Global Thinkers. Engaged Leaders.',
                    style: TextStyle(
                        fontSize: 11,
                        color: textMediumGrey),
                  ),
                ],
              ),
            ],
          ),
          // Exam Attendance System
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text(
                'Q-Top',
                style: TextStyle(fontSize: 10, color: textLightGrey, height: 1.0),
              ),
              Text(
                'Exam Attendance System',
                style: TextStyle(fontSize: 12, color: textLightGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Custom painter for the Mahindra University logo shape
  Widget _buildMahindraLogo() {
    return CustomPaint(
      size: const Size(45, 45), // Define the size of the logo
      painter: _MahindraLogoPainter(primaryRed: primaryRed),
    );
  }

  Widget _buildInvigilatorTapSection() {
    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: primaryRed,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryRed.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Inner wave
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
                // Middle wave
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
                // Outer wave
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Column(
          children: const [
            Text(
              'Tap Invigilator ID Card',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500, // Medium weight
                color: primaryRed,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              'Please tap your institutional ID card to continue',
              style: TextStyle(
                fontSize: 14,
                color: textMediumGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardFooter() {
    return Column(
      children: const [
        Text(
          'Powered by Q-Tap',
          style: TextStyle(fontSize: 12, color: textMediumGrey),
        ),
        SizedBox(height: 3),
        Text(
          'v1.0.0',
          style: TextStyle(fontSize: 10, color: textMediumGrey),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 50,
      width: double.infinity,
      color: bottomNavBg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.menu, color: Colors.white, size: 24),
          Icon(Icons.square_outlined, color: Colors.white, size: 24),
          Icon(Icons.change_history, color: Colors.white, size: 24), // Triangle-like icon
        ],
      ),
    );
  }
}

// Custom Painter for Mahindra University Logo (stylized 'U' shape)
class _MahindraLogoPainter extends CustomPainter {
  final Color primaryRed;

  _MahindraLogoPainter({required this.primaryRed});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = primaryRed;

    final double baseWidth = size.width;
    final double baseHeight = size.height;

    // Left trapezoid (shorter bar)
    Path pathA = Path();
    pathA.moveTo(0, 0); // Top-left
    pathA.lineTo(baseWidth * 0.3, 0); // Top-right
    pathA.lineTo(baseWidth * 0.2, baseHeight * 0.7); // Bottom-right (shorter)
    pathA.lineTo(0, baseHeight * 0.7); // Bottom-left
    pathA.close();
    canvas.drawPath(pathA, paint);

    // Right trapezoid (taller bar)
    Path pathB = Path();
    pathB.moveTo(baseWidth * 0.4, 0); // Top-left (offset to create gap)
    pathB.lineTo(baseWidth * 0.7, 0); // Top-right
    pathB.lineTo(baseWidth * 1.0, baseHeight); // Bottom-right (full height)
    pathB.lineTo(baseWidth * 0.7, baseHeight); // Bottom-left
    pathB.close();
    canvas.drawPath(pathB, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}