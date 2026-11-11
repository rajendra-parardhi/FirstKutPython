import 'package:flutter/material.dart';

void main() {
  runApp(const GoogleAIStudioApp());
}

class GoogleAIStudioApp extends StatelessWidget {
  const GoogleAIStudioApp({Key
? key}) : super(key:Key? key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google AI Studio - Agent Preview',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF242121),
        cardColor: const Color(0xFF272727),
        dividerColor: const Color(0xFF383838),
      ),
      home: const MainStudioScreen(),
    );
  }
}

class MainStudioScreen extends StatefulWidget {
  const MainStudioScreen({Key? key}) : super(key: key);

  @override
  State<MainStudioScreen> createState() => _MainStudioScreenState();
}

class _MainStudioScreenState extends State<MainStudioScreen> {
  bool filesystemToolsEnabled = true;
  bool googleSearchEnabled = true;
  bool codeExecutionEnabled = true;
  final TextEditingController _promptController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // Left Sidebar
            _buildLeftSidebar(context),
            const VerticalDivider(width: 1, thickness: 1),
            // Center Main Editor & Agent Workspace
            Expanded(
              child: _buildMainWorkspace(context),
            ),
            const VerticalDivider(width: 1, thickness: 1),
            // Right Configuration Panel
            _buildRightPanel(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftSidebar(BuildContext context) {
    return Container(
      width: 250,
      color: const Color(0xFF272120),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header / Logo
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.blueAccent, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Google AI Studio',
                style: TextStyle(
                  color: Color(0xFFE3E3E3),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                width: 11,
                height: 11,
                decoration: const BoxDecoration(
                  color: Color(0xFF2F3030),
                  shape: BoxShape.circle,
                ),
              )
            ],
          ),
          const SizedBox(height: 24),

          // Build Section
          const Text(
            'BUILD',
            style: TextStyle(
              color: Color(0xFF8E8E8E),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          _buildNavItem(Icons.add_rounded, 'New app', isActive: true),
          _buildNavItem(Icons.play_arrow_outlined, 'Playground'),
          _buildNavItem(Icons.history_rounded, 'History'),
          _buildNavItem(Icons.chat_bubble_outline_rounded, 'Temporary chat'),

          const SizedBox(height: 20),
          const Text(
            'EXPLORE',
            style: TextStyle(
              color: Color(0xFF8E8E8E),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          _buildNavItem(Icons.apps_rounded, 'My apps'),
          _buildNavItem(Icons.grid_view_rounded, 'Gallery'),
          _buildNavItem(Icons.description_outlined, 'Documentation'),

          const Spacer(),

          // Upgrade Card Component (id: 3)
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: const Color(0xFF292929),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF3D3D3D)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.workspace_premium, color: Colors.amber, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Upgrade to unlock',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Access higher limits, Pro models, and code execution environments.',
                  style: TextStyle(
                    color: Color(0xFFA0A0A0),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4C4C4C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text(
                      'Upgrade Plan',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF383332) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        horizontalTitleGap: 8.0,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        leading: Icon(icon, size: 18, color: isActive ? Colors.white : const Color(0xFFB0B0B0)),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFFC0C0C0),
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildMainWorkspace(BuildContext context) {
    return Column(
      children: [
        // Top Info / Status Banner (id: 0 text area)
        Container(
          color: const Color(0xFF272120),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: 16, color: Colors.amberAccent),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Temporary chat — Your conversation won\'t be saved automatically. Files uploaded will persist in Google Drive.',
                  style: TextStyle(color: Color(0xFFCCCCCC), fontSize: 12),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('See data policy', style: TextStyle(color: Colors.lightBlueAccent, fontSize: 12)),
              ),
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFF4E4E50),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('G', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Middle Workspace Panel / Prompt Area
        Expanded(
          child: Container(
            color: const Color(0xFF242121),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Agent Title Banner
                Row(
                  children: [
                    const Text(
                      'Antigravity Agent Preview',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: const Text(
                        'API Available',
                        style: TextStyle(color: Colors.blueAccent, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'This autonomous agent can execute code, take real actions, and utilize context with Google Search grounding.',
                  style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 13),
                ),

                const SizedBox(height: 24),

                // Environment Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1C1C),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF333333)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.terminal_rounded, color: Colors.greenAccent),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Isolated Linux Environment',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            Text(
                              'Each execution spins up an isolated sandbox to run code and manage files securely.',
                              style: TextStyle(color: Color(0xFF888888), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF4C4C4C)),
                        ),
                        child: const Text('Set token cap', style: TextStyle(color: Colors.white, fontSize: 12)),
                      )
                    ],
                  ),
                ),

                const Spacer(),

                // Input Area
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2D2D),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF444444)),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      TextField(
                        controller: _promptController,
                        maxLines: 4,
                        minLines: 2,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Start typing a prompt to see what our agents can do...',
                          hintStyle: TextStyle(color: Color(0xFF888888)),
                          border: InputBorder.none,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.attach_file, color: Color(0xFFA0A0A0), size: 20),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.code_rounded, color: Color(0xFFA0A0A0), size: 20),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.language_rounded, color: Color(0xFFA0A0A0), size: 20),
                            onPressed: () {},
                          ),
                          const Spacer(),
                          // Container Action Button (id: 12)
                          Container(
                            height: 41,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4C4C4C),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(8),
                              child: const Row(
                                children: [
                                  Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                                  SizedBox(width: 6),
                                  Text(
                                    'Run',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Ctrl ↵',
                                    style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 11),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRightPanel(BuildContext context) {
    return Container(
      width: 315,
      color: const Color(0xFF272727),
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          // Model Info Card (id: 4)
          const Text(
            'Model Configuration',
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF202020),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF383838)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected model',
                  style: TextStyle(color: Color(0xFF888888), fontSize: 11),
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Text(
                      'Gemini 1.5 Flash',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_down, color: Colors.white54),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Antigravity Agent Preview — General-purpose autonomous agent running in a remote Google-hosted Linux environment.',
                  style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 12, height: 1.3),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // System Instructions Card (id: 2)
          const Text(
            'System Instructions',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF202020),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF383838)),
            ),
            child: const TextField(
              maxLines: 3,
              style: TextStyle(color: Colors.white, fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Optional tone and style instructions for the model...',
                hintStyle: TextStyle(color: Color(0xFF666666), fontSize: 12),
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Tools Section (id: 9, 7)
          const Text(
            'Tools & Capabilities',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          // Filesystem tools
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filesystem tools',
                style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 13),
              ),
              Switch(
                value: filesystemToolsEnabled,
                activeColor: Colors.blueAccent,
                onChanged: (val) {
                  setState(() {
                    filesystemToolsEnabled = val;
                  });
                },
              )
            ],
          ),

          // Code execution
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Code execution',
                style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 13),
              ),
              Switch(
                value: codeExecutionEnabled,
                activeColor: Colors.blueAccent,
                onChanged: (val) {
                  setState(() {
                    codeExecutionEnabled = val;
                  });
                },
              )
            ],
          ),

          // Grounding search
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Grounding with Google Search',
                style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 13),
              ),
              Switch(
                value: googleSearchEnabled,
                activeColor: Colors.blueAccent,
                onChanged: (val) {
                  setState(() {
                    googleSearchEnabled = val;
                  });
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}