import 'package:flutter/material.dart';

class DesignIRWorkspace extends StatelessWidget {
  const DesignIRWorkspace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1.0,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Container(
              width: 1916,
              height: 1916,
              decoration: BoxDecoration(
                color: const Color(0xFF918E8F),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 10,
                  )
                ],
              ),
              child: Stack(
                children: [
                  // ID 0: White bottom canvas area
                  Positioned(
                    left: 0,
                    top: 1083,
                    width: 1916,
                    height: 412,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        border: Border(
                          top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                        ),
                      ),
                    ),
                  ),

                  // ID 1: Top header / inbox background zone
                  Positioned(
                    left: 0,
                    top: 0,
                    width: 1916,
                    height: 416,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Color(0xFF837979),
                      ),
                      alignment: Alignment.bottomLeft,
                      child: const Text(
                        "Gmail insent X Upgrade F7of 130 Inbox",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),

                  // ID 3: Global Navigation / Chrome Bar
                  Positioned(
                    left: 0,
                    top: 0,
                    width: 1916,
                    height: 176,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF492E2B),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Google AI Studio  •  no subject - presingirajakumar@gmail.com  •  Unified Code Generation Studio",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Ask Gemini  |  mail.google.com/mail/u/0/#sent/KtbxLvhZgmsHKRrZGbrHlcVNjxVsqZcbkl",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Continue where you left off. Chrome can restore your tabs next time you restart.",
                            style: TextStyle(
                              color: Colors.yellow[200],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ID 7: Small top-aligned visual container accent
                  Positioned(
                    left: 536,
                    top: 131,
                    width: 26,
                    height: 22,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF96807C),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),

                  // ID 12: Accent Pill right side top bar
                  Positioned(
                    left: 1278,
                    top: 138,
                    width: 101,
                    height: 11,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF7A5450),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),

                  // ID 6: Left Sidebar Container (Mail / Meet)
                  Positioned(
                    left: 0,
                    top: 183,
                    width: 82,
                    height: 828,
                    child: Container(
                      color: const Color(0xFFE6EAF2),
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        children: [
                          _buildSidebarIconButton(Icons.mail, "Mail", true),
                          const SizedBox(height: 32),
                          _buildSidebarIconButton(Icons.video_call, "Meet", false),
                        ],
                      ),
                    ),
                  ),

                  // ID 4: Compose Button
                  Positioned(
                    left: 101,
                    top: 270,
                    width: 168,
                    height: 63,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFB9DDF4),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {},
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.edit, color: Color(0xFF001D35)),
                                SizedBox(width: 12),
                                Text(
                                  "Compose",
                                  style: TextStyle(
                                    color: Color(0xFF001D35),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ID 10: Accent container under workspace
                  Positioned(
                    left: 551,
                    top: 281,
                    width: 18,
                    height: 15,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFCCCDCD),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // ID 2: Main Code Editor Panel
                  Positioned(
                    left: 495,
                    top: 318,
                    width: 1361,
                    height: 405,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF161819),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: const SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(radius: 6, backgroundColor: Colors.red),
                                SizedBox(width: 8),
                                CircleAvatar(radius: 6, backgroundColor: Colors.yellow),
                                SizedBox(width: 8),
                                CircleAvatar(radius: 6, backgroundColor: Colors.green),
                                SizedBox(width: 16),
                                Text(
                                  "inference_engine.py",
                                  style: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'monospace'),
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              "with torch.no_grad():\n"
                              "    f1 = clip_model.encode_text(t1)\n"
                              "    f2 = clip_model.encode_image(t2)\n"
                              "    f1 = f1 / f1.norm(dim=-1, keepdim=True)\n"
                              "    f2 = f2 / f2.norm(dim=-1, keepdim=True)\n"
                              "    cosine_similarity = (f1 @ f2.T).item()\n"
                              "    percentage_similarity = round(cosine_similarity * 100.0, 2)\n"
                              "    return max(0.0, min(100.0, percentage_similarity))\n"
                              "except Exception as clip_err:\n"
                              "    print(f\"CLIP calculation engine exception: {str(clip_err)}\")\n"
                              "    return 0.0\n\n"
                              "# FASTAPI SERVER DEFINITIONS\n"
                              "app = FastAPI(title=\"FirstKutAI Integrated Synthesis Engine\")",
                              style: TextStyle(
                                color: Color(0xFF8FE3B4),
                                fontFamily: 'monospace',
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ID 9: Purchases sidebar item background
                  Positioned(
                    left: 161,
                    top: 772,
                    width: 82,
                    height: 11,
                    child: Container(
                      color: const Color(0xFFC6C8CB),
                    ),
                  ),

                  // ID 11: Purchases Accent line
                  Positioned(
                    left: 165,
                    top: 772,
                    width: 78,
                    height: 7,
                    child: Container(
                      color: const Color(0xFFC9CBCE),
                    ),
                  ),

                  // Sidebar label placeholders mimicking the design coordinates
                  Positioned(
                    left: 161,
                    top: 790,
                    child: const Text(
                      "Purchases",
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),

                  // ID 8: Promotions Accent
                  Positioned(
                    left: 161,
                    top: 930,
                    width: 97,
                    height: 15,
                    child: Container(
                      color: const Color(0xFFB6B8BB),
                      child: const Center(
                        child: Text(
                          "Promotions",
                          style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarIconButton(IconData icon, String label, bool isActive) {
    return Column(
      children: [
        Icon(
          icon,
          size: 28,
          color: isActive ? const Color(0xFF001D35) : Colors.grey[700],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? const Color(0xFF001D35) : Colors.grey[700],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}