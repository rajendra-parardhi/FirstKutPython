import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key:Key? key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google AI Studio - Antigravity Agent',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF181818),
        cardColor: const Color(0xFF242121),
        dividerColor: const Color(0xFF333333),
      ),
      home: const AIStudioDashboard(),
    );
  }
}

class AIStudioDashboard extends StatefulWidget {
  const AIStudioDashboard({Key? key}) : super(key: key);

  @override
  State<AIStudioDashboard> createState() => _AIStudioDashboardState();
}

class _AIStudioDashboardState extends State<AIStudioDashboard> {
  bool codeExecution = true;
  bool googleSearch = true;
  bool urlContext = false;
  bool filesystemTools = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: Column(
        children: [
          // Top Navigation Bar
          _buildTopNavBar(),
          const Divider(height: 1, thickness: 1, color: Color(0xFF2D2D2D)),
          // Main Body Layout
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left Sidebar
                _buildLeftSidebar(),
                const VerticalDivider(width: 1, thickness: 1, color: Color(0xFF2D2D2D)),
                // Central Canvas / Workspace
                Expanded(
                  child: _buildCenterWorkspace(),
                ),
                const VerticalDivider(width: 1, thickness: 1, color: Color(0xFF2D2D2D)),
                // Right Inspector / Settings Panel
                _buildRightPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNavBar() {
    return Container(
      height: 56,
      color: const Color(0xFF242121),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.menu, color: Colors.white70),
          const SizedBox(width: 12),
          Text(
            'Google AI Studio',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF2F3030),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                Icon(Icons.lock_clock, size: 14, color: Colors.amber),
                SizedBox(width: 6),
                Text(
                  'Temporary chat',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.code, size: 16, color: Colors.white70),
            label: const Text('Get code', style: TextStyle(color: Colors.white70)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF4C4C4C)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.play_arrow, size: 16, color: Colors.white),
            label: const Text('Run', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A73E8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF4E4E50),
            child: const Text('G', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftSidebar() {
    return Container(
      width: 240,
      color: const Color(0xFF211E1E),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('New app', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2F2F2F),
              minimumSize: const Size(double.infinity, 42),
              alignment: Alignment.centerLeft,
            ),
          ),
          const SizedBox(height: 16),
          _sidebarSectionHeader('BUILD'),
          _sidebarItem(Icons.chat_bubble_outline, 'Agents in AI Studio', selected: true),
          _sidebarItem(Icons.tune, 'Playground'),
          _sidebarItem(Icons.history, 'History'),
          const SizedBox(height: 16),
          _sidebarSectionHeader('EXPLORE'),
          _sidebarItem(Icons.apps, 'My apps'),
          _sidebarItem(Icons.grid_view, 'Gallery'),
          _sidebarItem(Icons.dashboard, 'Dashboard'),
          _sidebarItem(Icons.build_outlined, 'Tools'),
          const Spacer(),
          // Upgrade Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF292929),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF333333)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(Icons.stars, color: Colors.amber, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Upgrade to unlock more',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  'Access higher limits, Pro models, code execution and more.',
                  style: TextStyle(fontSize: 11, color: Colors.white60, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        title,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white38, letterSpacing: 1),
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String label, {bool selected = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF2D2D2D) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        leading: Icon(icon, size: 18, color: selected ? Colors.blueAccent : Colors.white70),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: selected ? Colors.white : Colors.white70,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildCenterWorkspace() {
    return Column(
      children: [
        // Top Banner Notice
        Container(
          padding: const EdgeInsets.all(14),
          color: const Color(0xFF272120),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.lightBlueAccent, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Antigravity Agent Preview is available via an API. Link an API key to get URL context started. '
                  'This agent can execute code, take real actions and use large numbers of tokens.',
                  style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12, height: 1.3),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blueAccent),
                ),
                child: const Text('Link an API', style: TextStyle(color: Colors.blueAccent, fontSize: 12)),
              ),
            ],
          ),
        ),
        // Central Interaction Area
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Environment Initialized',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white70),
                ),
                const SizedBox(height: 6),
                Text(
                  'Each execution spins up an isolated Linux environment where your agent can run code and manage files.',
                  style: TextStyle(fontSize: 12, color: Colors.white38),
                ),
                const SizedBox(height: 24),
                // Input Prompt Area
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF242121),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF333333)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines: null,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'Start typing a prompt to see what our agents can do...',
                              hintStyle: TextStyle(color: Colors.white30),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        // Toolbar inside Prompt Box
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilterChip(
                              label: const Text('Tools: Code execution'),
                              selected: codeExecution,
                              onSelected: (val) => setState(() => codeExecution = val),
                              selectedColor: const Color(0xFF1E3A5F),
                              checkmarkColor: Colors.blueAccent,
                              labelStyle: const TextStyle(fontSize: 12, color: Colors.white),
                              backgroundColor: const Color(0xFF2A2A2A),
                            ),
                            FilterChip(
                              label: const Text('Grounding with Google Search'),
                              selected: googleSearch,
                              onSelected: (val) => setState(() => googleSearch = val),
                              selectedColor: const Color(0xFF1E3A5F),
                              checkmarkColor: Colors.blueAccent,
                              labelStyle: const TextStyle(fontSize: 12, color: Colors.white),
                              backgroundColor: const Color(0xFF2A2A2A),
                            ),
                            FilterChip(
                              label: const Text('URL context'),
                              selected: urlContext,
                              onSelected: (val) => setState(() => urlContext = val),
                              selectedColor: const Color(0xFF1E3A5F),
                              checkmarkColor: Colors.blueAccent,
                              labelStyle: const TextStyle(fontSize: 12, color: Colors.white),
                              backgroundColor: const Color(0xFF2A2A2A),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Press Ctrl + Enter to Run', style: TextStyle(fontSize: 11, color: Colors.white38)),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.send, size: 14),
                      label: const Text('Run'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A73E8),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRightPanel() {
    return Container(
      width: 320,
      color: const Color(0xFF242121),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Model Info Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF272727),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF383838)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.auto_awesome, color: Colors.blueAccent, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Antigravity Agent Preview',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'A general-purpose autonomous agent running in a remote Google-hosted Linux environment.',
                  style: TextStyle(fontSize: 11, color: Colors.white60, height: 1.3),
                ),
                const Divider(height: 16, color: Color(0xFF383838)),
                const Text('Selected model', style: TextStyle(fontSize: 10, color: Colors.white38)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Gemini 3.8 Flash', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                      Icon(Icons.arrow_drop_down, color: Colors.white54),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // System Instructions Panel
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF272727),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF383838)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'System instructions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  'Optional tone and style instructions for the model',
                  style: TextStyle(fontSize: 11, color: Colors.white54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Tools & Config Toggles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filesystem tools', style: TextStyle(fontSize: 12, color: Color(0xFF888889))),
              Switch(
                value: filesystemTools,
                onChanged: (val) => setState(() => filesystemTools = val),
                activeColor: Colors.blueAccent,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Set up token cap', style: TextStyle(fontSize: 12, color: Colors.white70)),
              TextButton(
                onPressed: () {},
                child: const Text('Configure', style: TextStyle(fontSize: 12, color: Colors.blueAccent)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}