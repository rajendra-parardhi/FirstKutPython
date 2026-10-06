import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DesignIR Workspace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF222425),
      ),
      home: const WorkspacePage(),
    );
  }
}

class WorkspacePage extends StatelessWidget {
  const WorkspacePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Screen dimensions wrapper mimicking [1920, 1080] proportions
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Action Sidebar (representing IDs 5, 6, 7, 8, 9)
            Container(
              width: 70,
              color: const Color(0xFF1F2122),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ID 9 - Sidebar Top Icon
                  _buildSidebarIcon(const Color(0xFF373839), Icons.folder_outlined),
                  const SizedBox(height: 30),
                  // ID 6 - Sidebar Search Icon
                  _buildSidebarIcon(const Color(0xFF323233), Icons.search),
                  const SizedBox(height: 30),
                  // ID 5 - Sidebar Source Control Icon
                  _buildSidebarIcon(const Color(0xFF565657), Icons.difference_outlined),
                  const SizedBox(height: 30),
                  // ID 7 - Sidebar Debug Icon
                  _buildSidebarIcon(const Color(0xFF3b3c3d), Icons.bug_report_outlined),
                  const Spacer(),
                  // ID 8 - Sidebar Settings/Profile Icon
                  _buildSidebarIcon(const Color(0xFF34464F), Icons.settings_outlined),
                ],
              ),
            ),
            
            // Main workspace content split into Top bar, Center Editor, and Bottom pane
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ID 1: Top bar / Menu / Explorer UI Info
                  Container(
                    height: 200,
                    color: const Color(0xFF1F2122),
                    padding: const EdgeInsets.all(12.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text("File  Edit  Selection  View  Go  Run  Terminal  Help",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white70)),
                              Spacer(),
                              Text("UIFigmaCodeStudio - Update", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          const Divider(color: Colors.white10),
                          const Text(
                            "EXPLORER  |  app.py 9M  |  build1787210825.html  |  env  |  App.jsx M  |  .gitignore",
                            style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.blueGrey),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Reconstruction Metrics:\n"
                            "• clipSimilarity: 36deg (1.334 / 1.55)\n"
                            "• background: conic-gradient(from 10b981 to 0deg)\n"
                            "• position: relative | width: 120px | height: 120px | borderRadius: 50%",
                            style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: Colors.greenAccent),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Middle Panel: Row containing Main Editor Workspace and Right Action Bar
                  Expanded(
                    flex: 3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ID 4: Main Console Logs & Input Window
                        Expanded(
                          child: Container(
                            color: const Color(0xFF222425),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "TERMINAL / OUTPUT / CONSOLE",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E1E1E),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    padding: const EdgeInsets.all(12.0),
                                    child: SingleChildScrollView(
                                      child: const Text(
                                        "PS C:\\Users\\RAJ KUMAR\\Desktop\\UIFigmaCodeStudio\\backend> python app.py\n"
                                        "ERROR: uilglldirectcompositionsupport.cc(254) GetGpuDriverOverlayInfo Failed to retrieve video device\n"
                                        "7253 bytes written to file C:\\Users\\RAJ KUMAR\\Desktop\\UIFigmaCodeStudio\\backend\\temp_render.png\n"
                                        "INFO: 127.0.0.1:63134 - \"POST /api/process_ui HTTP/1.1\" 200 OK\n"
                                        "INFO: Shutting down...\n"
                                        "INFO: Waiting for application shutdown.\n"
                                        "INFO: Application shutdown complete.\n"
                                        "INFO: Finished server process 10772\n"
                                        "PS C:\\Users\\RAJ KUMAR\\Desktop\\UIFigmaCodeStudio\\backend> _",
                                        style: TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 12,
                                          height: 1.4,
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // ID 2: Right Selection Panel (Terminal shell profiles)
                        Container(
                          width: 150,
                          color: const Color(0xFF1E1E1E),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "SHELLS",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white54),
                              ),
                              const Divider(color: Colors.white10),
                              _buildShellTab("1: python", true),
                              _buildShellTab("2: pwsh", false),
                              _buildShellTab("3: bash", false),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ID 0: White Secondary Bottom Split Panel
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.only(top: 8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "UI Visualizer Live Output Frame",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.black12),
                          const Expanded(
                            child: Center(
                              child: Text(
                                "Live rendering container connected on port 3000.",
                                style: TextStyle(color: Colors.black54, fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarIcon(Color color, IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: Colors.white70,
        size: 20,
      ),
    );
  }

  Widget _buildShellTab(String label, bool isActive) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive ? Colors.white10 : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.blueAccent : Colors.white70,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}