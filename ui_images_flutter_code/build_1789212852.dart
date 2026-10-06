import 'package:flutter/material.dart';

void main() {
  runApp(const FirstKutAIApp());
}

class FirstKutAIApp extends StatelessWidget {
  const FirstKutAIApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FirstKutAI Pipeline Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1C1A21),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Courier', color: Colors.white70),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Main Dashboard Workspace (1920x1080 canvas ratio)
            AspectRatio(
              aspectRatio: 1920 / 1080,
              child: Container(
                color: const Color(0xFF1C1A21),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double w = constraints.maxWidth;
                    final double h = constraints.maxHeight;

                    // Helper function to scale coordinates from design to actual screen size
                    Positioned scaledPosition({
                      required double left,
                      required double top,
                      required double width,
                      required double height,
                      required Widget child,
                    }) {
                      return Positioned(
                        left: (left / 1920) * w,
                        top: (top / 1080) * h,
                        width: (width / 1920) * w,
                        height: (height / 1080) * h,
                        child: child,
                      );
                    }

                    return Stack(
                      children: [
                        // Subtle Background Telemetry Text overlay representing root component 7 context
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.05,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(
                                "Completed FirstKutAI Pipeline Integration\n"
                                "PIPELINE EXECUTION STAGES\n"
                                "Stage 1 Layout Segmentation SAM 45.42s\n"
                                "Stage 2 Text Extraction OCR 187.46s\n"
                                "Stage 3 Element Color Profiling 143.24s\n"
                                "Stage 4 Intelligent Orchestration Synthesis 17.19s\n"
                                "Stage 5 Visual Alignment Check CLIP 0.38s\n"
                                "Stage 6 Reconciliation Promotion\n"
                                "SYNTHESIS ENGINE: gemini-1.5-flash\n"
                                "SELECTION REASON CONTEXT: High structural match 89.59%\n"
                                "Fast DOM refinement applied",
                                style: TextStyle(fontSize: w * 0.015, fontWeight: FontWeight.bold, height: 1.4),
                              ),
                            ),
                          ),
                        ),

                        // Component 1: Workspace Header & Log Panel
                        scaledPosition(
                          left: 0,
                          top: 0,
                          width: 1916,
                          height: 416,
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D2328).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white10),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "UI Image Parser Workspace",
                                      style: TextStyle(fontSize: w * 0.014, fontWeight: FontWeight.bold, color: Colors.amberAccent),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(color: Colors.black25, borderRadius: BorderRadius.circular(4)),
                                      child: const Text("API: http://localhost:8000", style: TextStyle(fontSize: 10, color: Colors.greenAccent)),
                                    ),
                                  ],
                                ),
                                const Divider(color: Colors.white24, height: 16),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Text(
                                      "SYSTEM LOGS & PIPELINE LIVE TELEMETRY STREAM:\n"
                                      "SAM Segmentation: OK\n"
                                      "OCR Text Similarity Analyzer: Active\n"
                                      "Figma Compiler initialized\n"
                                      "Layout JSON generated\n"
                                      "Target output formatting: HTML, CSS, Dart Code Copy",
                                      style: TextStyle(fontSize: w * 0.009, height: 1.5, color: Colors.white70),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Component 4: Browser Bar Mockup
                        scaledPosition(
                          left: 0,
                          top: 0,
                          width: 1916,
                          height: 176,
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF482D2A),
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    _buildWindowButton(Colors.red),
                                    const SizedBox(width: 6),
                                    _buildWindowButton(Colors.yellow),
                                    const SizedBox(width: 6),
                                    _buildWindowButton(Colors.green),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Container(
                                        height: 24,
                                        decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(12)),
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.only(left: 12),
                                        child: Text(
                                          "localhost:5173 - Unified Code Generation Studio",
                                          style: TextStyle(fontSize: w * 0.007, color: Colors.white55),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      "Google AI Studio  |  presingirajakumar@gmail.com  |  Ask Gemini  |  Chrome status: Restored tabs",
                                      style: TextStyle(fontSize: w * 0.008, color: Colors.white38),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        // Component 5: Synthesis Error Panel
                        scaledPosition(
                          left: 555,
                          top: 408,
                          width: 1331,
                          height: 581,
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF090A0F),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.redAccent.withOpacity(0.5), width: 1.5),
                            ),
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                                const SizedBox(height: 16),
                                Text(
                                  "Code synthesis failed on model tier gemini-1.5-flash",
                                  style: TextStyle(fontSize: w * 0.015, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Click to retry orchestration or fallback to stable synthesis engine.",
                                  style: TextStyle(fontSize: w * 0.01, color: Colors.white54),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),

                        // Component 3: Screenshot Uploader Button
                        scaledPosition(
                          left: 22,
                          top: 828,
                          width: 457,
                          height: 135,
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF14151C),
                              border: Border.all(color: Colors.blueAccent.withOpacity(0.5), style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.cloud_upload_outlined, color: Colors.blueAccent, size: 28),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Click to Upload UI Screenshot",
                                    style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: w * 0.01),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Component 2: Flutter Output Tab indicator
                        scaledPosition(
                          left: 1200,
                          top: 270,
                          width: 150,
                          height: 60,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF1B151A),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FlutterLogo(size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  "Flutter Output",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: w * 0.009),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Component 9: SOURCE UI CONTROL PANEL Header Label
                        scaledPosition(
                          left: 18,
                          top: 292,
                          width: 240,
                          height: 18,
                          child: Container(
                            color: const Color(0xFF34384B).withOpacity(0.2),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              "SOURCE UI CONTROL PANEL",
                              style: TextStyle(color: const Color(0xFF34384B), fontWeight: FontWeight.bold, fontSize: w * 0.0075),
                            ),
                          ),
                        ),

                        // Component 10: Go to Settings
                        scaledPosition(
                          left: 1278,
                          top: 138,
                          width: 101,
                          height: 15,
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              alignment: Alignment.center,
                              color: const Color(0xFF7A5450).withOpacity(0.3),
                              child: Text(
                                "go to Settings",
                                style: TextStyle(color: const Color(0xFF7A5450), fontSize: w * 0.006, decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        ),

                        // Component 8: Colors Indicator Tag
                        scaledPosition(
                          left: 858,
                          top: 296,
                          width: 48,
                          height: 15,
                          child: Container(
                            alignment: Alignment.center,
                            color: const Color(0xFF303547),
                            child: Text(
                              "Colors",
                              style: TextStyle(color: Colors.white70, fontSize: w * 0.006),
                            ),
                          ),
                        ),

                        // Component 6: Subtle System Status Square
                        scaledPosition(
                          left: 536,
                          top: 131,
                          width: 26,
                          height: 22,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF96807C),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // Component 0: Lower Workspace Sandbox Panel (White theme/preview sandbox)
            Container(
              width: double.infinity,
              height: 412,
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.terminal, color: Colors.black87),
                      SizedBox(width: 12),
                      Text(
                        "Workspace Sandbox Output Area",
                        style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.black12, thickness: 1, height: 24),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: const SingleChildScrollView(
                        child: Text(
                          "Ready for synthesis pipeline instructions. Please upload a snapshot or verify model endpoints to begin code extraction.\n\n"
                          "Supported export frameworks: Flutter widgets, responsive HTML/CSS structures, system logs JSON, layout specifications.",
                          style: TextStyle(color: Colors.black54, height: 1.5),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWindowButton(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}