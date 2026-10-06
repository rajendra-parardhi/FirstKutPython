import 'package:flutter/material.dart';
// If you want more accurate icons like Font Awesome, add font_awesome_flutter dependency.
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Processing Flow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // Using Roboto as a common sans-serif font
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const FlowScreen(),
    );
  }
}

class FlowScreen extends StatelessWidget {
  const FlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Light off-white background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFlowBlock(
                color: const Color(0xFF5492CE), // Blue
                title: '1. Upload PDF',
                icon: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.description, color: Colors.white, size: 36),
                    Text('PDF', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              _buildArrow(),
              _buildFlowBlock(
                color: const Color(0xFF62B6A6), // Teal
                title: '2. Extract Text from PDF',
                icon: const Icon(Icons.description, color: Colors.white, size: 36),
              ),
              _buildArrow(),
              _buildFlowBlock(
                color: const Color(0xFF77A86A), // Green
                title: '3. Convert to JSON',
                icon: const Text(
                  '{ }',
                  style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
              _buildArrow(),
              _buildFlowBlock(
                color: const Color(0xFFEBA84C), // Orange
                title: '4. Process Query',
                subtitle: 'Ask Questions',
                icon: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.search, color: Colors.white.withOpacity(0.9), size: 36),
                    const Icon(Icons.question_mark, color: Colors.white, size: 20),
                  ],
                ),
              ),
              _buildArrow(),
              _buildFlowBlock(
                color: const Color(0xFFD5665D), // Red
                title: '6. Generate Answer',
                // No icon explicitly shown for this step
              ),
              _buildArrow(),
              _buildExportResultsBlock(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlowBlock({
    required Color color,
    required String title,
    String? subtitle,
    Widget? icon,
  }) {
    return Container(
      width: 320,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ),
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: SizedBox(
                height: 40, // Consistent height for icons
                child: icon,
              ),
            ),
          if (icon == null) // To maintain consistent spacing when there's no icon
            const SizedBox(height: 15.0),
        ],
      ),
    );
  }

  Widget _buildArrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: Icon(Icons.arrow_downward, color: Color(0xFFBBBBBB), size: 30),
    );
  }

  Widget _buildExportResultsBlock() {
    return Container(
      width: 320,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFD88A83), // Darker Red for export block
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '7. Export Results',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildExportButton(
                text: 'JSON',
                color: const Color(0xFFE5E2E2), // Very Light Grey from JSON
                textColor: const Color(0xFF333333),
              ),
              _buildExportButton(
                text: 'PDF',
                color: const Color(0xFFE8E7E7), // Light Grey from JSON
                textColor: const Color(0xFF333333),
              ),
              _buildExportButton(
                text: 'Display\non Web',
                color: const Color(0xFFDAD9D9), // Light Grey from JSON
                textColor: const Color(0xFF333333),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton({required String text, required Color color, required Color textColor}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}