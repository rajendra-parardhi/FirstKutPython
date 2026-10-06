import 'package:flutter/material.dart';

void main() {
  runApp(const CodeGenStudioApp());
}

class CodeGenStudioApp extends StatelessWidget {
  const CodeGenStudioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ListContext) {
    return MaterialApp(
      title: 'Unified Code Generation Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF242228),
        cardColor: const Color(0xFF14151c),
      ),
      home: const CodeGenStudioDashboard(),
    );
  }
}

class CodeGenStudioDashboard extends StatelessWidget {
  const CodeGenStudioDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Check if screen is wide enough for landscape desktop layout
          bool isDesktop = constraints.maxWidth > 1000;
          return Container(
            color: const Color(0xFF242228),
            child: isDesktop 
                ? _buildDesktopLayout(context, constraints) 
                : _buildMobileLayout(context),
          );
        },
      ),
    );
  }

  // Desktop layout matches the spatial layout from coordinates
  Widget _buildDesktopLayout(BuildContext context, BoxConstraints constraints) {
    final double widthScale = constraints.maxWidth / 1920;
    final double heightScale = constraints.maxHeight / 1080;

    return Stack(
      children: [
        // ID 1: Top Navigation / Header Bar background
        Positioned(
          top: 0,
          left: 0,
          width: constraints.maxWidth,
          height: 220 * heightScale,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF201B22),
              border: Border(
                bottom: BorderSide(color: Color(0xFF322A36), width: 1.5),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.code_rounded, color: Color(0xFFEF7521), size: 28),
                        const SizedBox(width: 12),
                        const Text(
                          "Unified Code Generation Studio",
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, py: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF7521).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFFEF7521), width: 1),
                          ),
                          child: const Text(
                            "Ask Gemini",
                            style: TextStyle(fontSize: 11, color: Color(0xFFEF7521), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    // ID 3: API Status
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, py: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF191E28),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.emerald.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.emerald,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "API: localhost:8000",
                            style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.emerald),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildNavTab("Figma Compiler", true, const Color(0xFF171A25)),
                    const SizedBox(width: 10),
                    _buildNavTab("Upload & Analyze", false, const Color(0xFF1C1B24)),
                    const SizedBox(width: 10),
                    _buildNavTab("Workspace View", false, const Color(0xFF1C1B24)),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Left Panel: Image dropzone, Configuration and Logs
        Positioned(
          top: 230 * heightScale,
          left: 20 * widthScale,
          width: 440 * widthScale,
          height: 810 * heightScale,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ID 9: Click to Upload UI Screenshot
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF14151C),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF2C2E3E), width: 2),
                  ),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cloud_upload_outlined, size: 48, color: Color(0xFFEF7521)),
                        const SizedBox(height: 12),
                        const Text(
                          "Click to Upload UI Screenshot",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "PNG, JPG or SVG up to 10MB",
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ID 12: Uploaded Input Image Tracker
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF474D62).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.image, size: 16, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      "Uploaded Input Image (Active)",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ID 11 & 7: Configuration, RuleBased Image Parsing & Mockup LLM settings
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECE6DD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "PIPELINE PARSING CONFIG",
                            style: TextStyle(
                              color: Color(0xFF242228), 
                              fontWeight: FontWeight.extrabold, 
                              fontSize: 12,
                              letterSpacing: 1.0,
                            ),
                          ),
                          // ID 7: Notification project wide marker
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFFC3616D),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.notification_important_rounded, size: 12, color: Colors.white),
                          )
                        ],
                      ),
                      const Divider(color: Color(0xFF242228), thickness: 1),
                      const SizedBox(height: 8),
                      _buildConfigItem("Parser Engine", "SAM Segmentation (RuleBased)", true),
                      _buildConfigItem("OCR Processor", "Google Lens Model v4", false),
                      _buildConfigItem("RAG Memory Search", "ChromaDB Memory", true),
                      _buildConfigItem("UI Synthesis Model", "Gemini 1.5 Pro AI", true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ID 2: Run Code Engine Pipeline Button
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF7521),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEF7521).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                      SizedBox(width: 8),
                      Text(
                        "Run Code Engine Pipeline",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ID 6: SYSTEMLOGS Terminal Console
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B2B39),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF2A3E50)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.yellow, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                          const SizedBox(width: 10),
                          const Text(
                            "SYSTEM LOGS",
                            style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              _LogLine(step: "Step 1", desc: "Layout Segmentation SAM done", duration: "0.533s"),
                              _LogLine(step: "Step 2", desc: "Text Extraction OCR complete", duration: "0.804s"),
                              _LogLine(step: "Step 3", desc: "Element Color Profiling completed", duration: "0.003s"),
                              _LogLine(step: "Step 4", desc: "ChromaDB Memory Search", duration: "0.376s"),
                              _LogLine(step: "Step 5", desc: "UI Blueprint Synthesis finalized", duration: "0.003s"),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ID 8: Main Live Code Output Canvas Editor View
        Positioned(
          top: 230 * heightScale,
          left: 480 * widthScale,
          width: 1420 * widthScale,
          height: 810 * heightScale,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F111A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1F2233), width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 16,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              children: [
                // Inner Editor Window Header
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF151825),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _buildEditorTab("semantic_layout.html", true),
                          const SizedBox(width: 8),
                          _buildEditorTab("structural_layout.css", false),
                          const SizedBox(width: 8),
                          _buildEditorTab("flutter_widget.dart", false),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.copy_rounded, size: 16, color: Colors.grey),
                            onPressed: () {},
                            tooltip: "Copy Code",
                          ),
                          IconButton(
                            icon: const Icon(Icons.fullscreen_rounded, size: 18, color: Colors.grey),
                            onPressed: () {},
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                // Code Workspace Body
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF05060A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "// Generated Code will render here visually & structurally",
                                    style: TextStyle(color: Colors.grey, fontFamily: 'monospace', fontSize: 13),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    "<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>Layout Screen Preview</title>\n  <link rel=\"stylesheet\" href=\"styles.css\">\n</head>\n<body>\n  <div class=\"ui-container\">\n    <!-- Dynamic UI nodes generated via Gemini LLM Studio -->\n    <div class=\"header\">Navbar Elements Render Here</div>\n    <div class=\"sidebar\">Control System Details</div>\n    <div class=\"main-canvas\">Canvas Layout Renderer Output</div>\n  </div>\n</body>\n</html>",
                                    style: TextStyle(color: Color(0xFFB5E8B0), fontFamily: 'monospace', fontSize: 13, height: 1.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text(
                              "Compiler Preview Output Console",
                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, py: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text("Success - Compiled perfectly", style: TextStyle(color: Colors.greenAccent, fontSize: 11)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Simplified layout for narrow/mobile screens
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Unified Code Generation Studio",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF14151C),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2C2E3E), width: 2),
              ),
              child: const Center(
                child: Text("Click to Upload UI Screenshot", style: TextStyle(color: Colors.white70)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF7521),
                padding: const EdgeInsets.all(16),
              ),
              child: const Text("Run Code Engine Pipeline"),
            ),
            const SizedBox(height: 16),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFF0F111A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text("Code Editor View (Switch to Desktop for best experience)", style: TextStyle(color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTab(String title, bool active, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFEF7521) : color,
        borderRadius: BorderRadius.circular(6),
        border: active ? null : Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: active ? Colors.white : Colors.white70,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildEditorTab(String title, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF0F111A) : Colors.transparent,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: active ? Colors.white : Colors.grey,
          fontSize: 12,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildConfigItem(String label, String value, bool isSuccess) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF242228), fontSize: 13, fontWeight: FontWeight.w500)),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isSuccess ? Colors.green : Colors.amber,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(value, style: const TextStyle(color: Color(0xFF242228), fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _LogLine extends StatelessWidget {
  final String step;
  final String desc;
  final String duration;

  const _LogLine({
    required this.step,
    required this.desc,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "$step - $desc",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: Color(0xFF8BB5CC)),
            ),
          ),
          Text(
            duration,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: Colors.greenAccent),
          ),
        ],
      ),
    );
  }
}