import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facial Enrollment',
      theme: ThemeData(
        // Using 'Inter' as a custom font. For a real app, you would load it via pubspec.yaml.
        // For this example, if 'Inter' is not available, it will fall back to default sans-serif.
        fontFamily: 'Inter',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: const Color(0xFFF4F7F9), // Corresponds to --background-light
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Color(0xFF333333)), // Welcome, Steve Carell
          headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF333333)), // Card titles
          bodyLarge: TextStyle(fontSize: 15, color: Color(0xFF666666), height: 1.5), // Welcome paragraph
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF333333)), // Default body text
          bodySmall: TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)), // Small helper text
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.zero,
        ),
      ),
      home: const FacialEnrollmentScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FacialEnrollmentScreen extends StatelessWidget {
  const FacialEnrollmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Row(
        children: [
          _buildSidebar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(context),
                  const SizedBox(height: 30),
                  _buildContentGrid(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0E6C7C), // --primary-dark
      toolbarHeight: 50,
      titleSpacing: 0,
      title: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'eHero',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Row(
              children: [
                Text(
                  'Group Name',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                SizedBox(width: 5),
                Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.calendar_today_outlined, color: Colors.white, size: 20),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 20),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.white, size: 20),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 20),
          onPressed: () {},
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          alignment: Alignment.center,
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            'DP',
            style: TextStyle(
              color: const Color(0xFF0E6C7C), // --primary-dark
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 60,
      padding: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE0E0E0), width: 1)), // --border-color
      ),
      child: Column(
        children: [
          _sidebarIcon(Icons.person_outline, isActive: false),
          const SizedBox(height: 20),
          _sidebarIcon(Icons.person_outline, isActive: true),
          const SizedBox(height: 20),
          _sidebarIcon(Icons.person_outline, isActive: false),
          const SizedBox(height: 20),
          _sidebarIcon(Icons.person_outline, isActive: false),
          const SizedBox(height: 20),
          _sidebarIcon(Icons.person_outline, isActive: false),
        ],
      ),
    );
  }

  Widget _sidebarIcon(IconData iconData, {bool isActive = false}) {
    return Container(
      width: 40,
      height: 40,
      decoration: isActive
          ? BoxDecoration(
              color: const Color(0xFF52C3C9), // --primary-light
              borderRadius: BorderRadius.circular(20),
            )
          : null,
      child: Icon(
        iconData,
        color: isActive ? Colors.white : const Color(0xFFAAAAAA), // --text-light
        size: 24,
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome, Steve Carell',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 10),
        Text(
          'For facial enrollment, high-quality facial images need to be captured.\nKindly follow the instructions below to proceed.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildContentGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) { // Adjust breakpoint as needed
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: _buildLeftCard(context),
              ),
              const SizedBox(width: 30),
              Expanded(
                flex: 2,
                child: _buildRightCard(context),
              ),
            ],
          );
        } else {
          // Stack cards vertically on smaller screens
          return Column(
            children: [
              _buildLeftCard(context),
              const SizedBox(height: 30),
              _buildRightCard(context),
            ],
          );
        }
      },
    );
  }

  Widget _buildLeftCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Instructions', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            _buildInstructionItem(context, 'Good lighting'),
            _buildInstructionItem(context, 'Uncluttered background'),
            _buildInstructionItem(context, 'Proper face alignment in the image capture box'),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Capture Progress', style: Theme.of(context).textTheme.headlineSmall),
                Text('1/3', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 20),
            _buildProgressItem(
              context,
              title: 'Front view',
              status: 'Completed',
              details: 'System will capture automatically',
              isCompleted: true,
              iconWidget: ClipOval(
                child: Image.network(
                  'https://via.placeholder.com/45/cccccc/ffffff?text=U', // Placeholder image
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 45,
                    height: 45,
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ),
              ),
            ),
            _buildProgressItem(
              context,
              title: 'Right view',
              details: 'System will capture automatically',
              isCompleted: false,
              iconWidget: const Icon(Icons.person_outline, color: Color(0xFFAAAAAA), size: 24),
            ),
            _buildProgressItem(
              context,
              title: 'Left view',
              details: 'System will capture automatically',
              isCompleted: false,
              iconWidget: const Icon(Icons.person_outline, color: Color(0xFFAAAAAA), size: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFFF2994A), size: 18), // --orange-check
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF666666)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(
      BuildContext context, {
        required String title,
        String? status,
        required String details,
        required bool isCompleted,
        required Widget iconWidget,
      }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isCompleted ? Colors.transparent : const Color(0xFFE0E0E0), // --border-color
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7F9), // --background-light
              borderRadius: BorderRadius.circular(22.5),
            ),
            child: Center(child: iconWidget),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    if (status != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF27AE60), // --green-completed
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ),
                    if (status != null) const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        details,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF666666)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isCompleted)
            const Icon(Icons.check_circle, color: Color(0xFF27AE60), size: 16), // --green-completed
        ],
      ),
    );
  }

  Widget _buildRightCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 450), // Max dimensions for square
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0), // Placeholder background
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: const Offset(0, 0), // inner shadow effect
                  ),
                ],
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      'https://via.placeholder.com/600x600/333333/ffffff?text=Face+Placeholder', // Placeholder for camera feed
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[800],
                        child: const Center(child: Text('Camera Feed', style: TextStyle(color: Colors.white))),
                      ),
                    ),
                    // Face capture box and landmarks
                    FractionallySizedBox(
                      widthFactor: 0.7, // 70% of parent width
                      heightFactor: 0.7, // 70% of parent height
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF52C3C9), width: 2), // --primary-light
                        ),
                        child: CustomPaint(
                          painter: _FaceLandmarksPainter(const Color(0xFF52C3C9).withOpacity(0.8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF52C3C9), // --primary-light
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.info_outline, color: Colors.white, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    'The camera will automatically capture your best face position',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    side: const BorderSide(color: Color(0xFFE0E0E0)), // --border-color
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: Text(
                    'Clear all',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E6C7C), // --primary-dark
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: Text(
                    'Submit',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for Face Landmarks (simplified)
class _FaceLandmarksPainter extends CustomPainter {
  final Color lineColor;

  _FaceLandmarksPainter(this.lineColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    // Define relative positions for landmarks
    final List<Offset> points = [
      Offset(size.width * 0.2, size.height * 0.2), // Top-left
      Offset(size.width * 0.8, size.height * 0.2), // Top-right
      Offset(size.width * 0.2, size.height * 0.8), // Bottom-left
      Offset(size.width * 0.8, size.height * 0.8), // Bottom-right
      Offset(size.width * 0.5, size.height * 0.3), // Forehead/nose bridge
      Offset(size.width * 0.4, size.height * 0.5), // Left cheek
      Offset(size.width * 0.6, size.height * 0.5), // Right cheek
      Offset(size.width * 0.5, size.height * 0.7), // Chin
    ];

    // Draw lines
    canvas.drawLine(points[0], points[4], paint);
    canvas.drawLine(points[1], points[4], paint);
    canvas.drawLine(points[2], points[5], paint);
    canvas.drawLine(points[3], points[6], paint);
    canvas.drawLine(points[5], points[7], paint);
    canvas.drawLine(points[6], points[7], paint);

    // Draw circles at points
    for (var point in points) {
      canvas.drawCircle(point, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Only repaint if line color changes
  }
}