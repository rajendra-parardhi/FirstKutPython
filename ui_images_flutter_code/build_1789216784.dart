import 'package:flutter/material.dart';

class DesignIRWorkspace extends StatelessWidget {
  const DesignIRWorkspace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Root Component 0: Header Area
              _buildHeader(),

              // Main Workspace Body
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Root Component 3: Reconstruction Metrics
                    _buildReconstructionMetrics(),
                    const SizedBox(height: 16),

                    // Grid / Rows for Main Content
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 900) {
                          // Desktop View: Row of (Logs + Status) and (Original Input + Output Render)
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
                                  children: [
                                    _buildSystemLogs(), // ID 11
                                    const SizedBox(height: 16),
                                    _buildWeatherStatus(), // ID 8
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 4,
                                child: _buildOriginalInputView(), // ID 7
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 4,
                                child: _buildHtmlOutputRender(), // ID 5
                              ),
                            ],
                          );
                        } else {
                          // Mobile/Tablet View: Stack vertically
                          return Column(
                            children: [
                              _buildSystemLogs(),
                              const SizedBox(height: 16),
                              _buildWeatherStatus(),
                              const SizedBox(height: 16),
                              _buildOriginalInputView(),
                              const SizedBox(height: 16),
                              _buildHtmlOutputRender(),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Root Component 1: White Footer Space
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // ID 0: Main Header Widget (contains nested elements 6, 9, 15, 12, 13, 14, 4)
  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF2D2429),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nested ID 6: Banner & Top Bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF482D2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Nested ID 9: Color Accent Badge
                Container(
                  width: 26,
                  height: 22,
                  decoration: BoxDecoration(
                    color: const Color(0xFF96807C),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Google AI Studio • Unified Code Generation Studio - Continue where you left off",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Nested ID 15: Settings Link
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "go to Settings",
                    style: TextStyle(
                      color: Color(0xFF7A5450),
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Main Workspace Title Panel Info
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Text(
              "UI Image Parser Workspace API • Figma Compiler & Output Engine",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                letterSpacing: 1.1,
              ),
            ),
          ),

          // Controls Row (ID 12, 13, 14, 4)
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // ID 12
              _buildControlBadge("SOURCE UI CONTROL PANEL", const Color(0xFF34384B)),
              // ID 13
              _buildControlBadge("SAM Segmentation", const Color(0xFF2F3345)),
              // ID 14
              _buildControlBadge("Colors", const Color(0xFF303547)),
              // ID 4
              _buildControlBadge("Similarity", const Color(0xFF1C171C), isAccent: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlBadge(String label, Color color, {bool isAccent = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        border: isAccent ? Border.all(color: Colors.white30, width: 1) : null,
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ID 3: Reconstruction Metrics Panel
  Widget _buildReconstructionMetrics() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF202D3E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "RECONSTRUCTION METRICS & CLIP SEMANTIC VERIFICATION",
            style: TextStyle(
              color: Colors.lightBlueAccent,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Evaluates structural similarities and color themes between original source inputs and compiled HTML outputs.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ID 11: System Logs (Contains Nested ID 10)
  Widget _buildSystemLogs() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF18263A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SYSTEM LOGS & PIPELINE TELEMETRY",
            style: TextStyle(
              color: Colors.amber,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Completed FirstKutAI Pipeline Integration\n\n"
            "STAGES:\n"
            "• Stage 1: Layout Segmentation (SAM) 470ms\n"
            "• Stage 2: Text Extraction (OCR) 213ms\n"
            "• Stage 3: Element Color Profiling 191ms\n"
            "• Stage 4: Intelligent Orchestration 254ms\n"
            "• Stage 5: Visual Alignment Check (CLIP) 038ms\n"
            "• Stage 6: Reconciliation Promotion UI\n\n"
            "TOTAL ENGINE RUNTIME: 1.13s",
            style: TextStyle(
              color: Colors.white60,
              fontFamily: 'monospace',
              fontSize: 11,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          // Nested ID 10: Synthesis Engine Details
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1C273F),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white10),
            ),
            child: const Text(
              "SYNTHESIS ENGINE PRO SELECTION REASON CONTEXT:\n"
              "High structural match 89.59%. Fast DOM refinement applied via Gemini workspace backend.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ID 8: Weather Status
  Widget _buildWeatherStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14151B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        "Status: Rain showers in area • 46°F\nActive compiler server node on localhost:8000",
        style: TextStyle(
          color: Colors.white38,
          fontSize: 11,
        ),
      ),
    );
  }

  // ID 7: Original Input View
  Widget _buildOriginalInputView() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F111A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ORIGINAL INPUT VIEW",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 180,
            color: Colors.black26,
            child: const Center(
              child: Text(
                "Source Layout OCR Representation Panel",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white30, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ID 5: HTML Output Render (Contains Nested ID 2)
  Widget _buildHtmlOutputRender() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF656D79),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "HTML OUTPUT RENDER",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          // Nested ID 2: HTML Synthesis Error Msg
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "HTML Synthesis Failed",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Similarity comparison suggested structural divergence. Running localized reconciliation routine.",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ID 1: Bottom Accent / Footer Container
  Widget _buildFooter() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(top: 24),
      color: Colors.white,
      child: const Center(
        child: Text(
          "Unified Pipeline Output System",
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}