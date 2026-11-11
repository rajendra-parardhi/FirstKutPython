import 'flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capturing Moments',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F7FA),
        fontFamily: 'Roboto',
      ),
      home: const LandingScreen(),
    );
  }
}

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  static const Color colorPrimaryText = Color(0xFF2C233A);
  static const Color colorHeaderBg = Color(0xFF5D5871);
  static const Color colorFooterBg = Color(0xFF68637A);
  static const Color colorAccentPurple = Color(0xFF6C54AB);
  static const Color colorSubtext = Color(0xFF53478E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Bar
            _buildHeader(context),
            
            // Main Body Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: _buildHeroText()),
                            const SizedBox(width: 40),
                            Expanded(child: _buildActionCard(context)),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildHeroText(),
                            const SizedBox(height: 36),
                            _buildActionCard(context),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),

            // Bottom Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: colorHeaderBg,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      child: Row(
        mainAxisAlignment: Mainbetween,
        children: [
          // Left Branding Section
          Row(
            children: [
              const Text(
                'AMU',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: () {},
                child: const Text(
                  'Back to website',
                  style: TextStyle(
                    color: Color(0xFFD1CBDC),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          // Right Header Actions
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorAccentPurple,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Create an account',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: Color(0xFFC4BECE), fontSize: 10),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Capturing Moments',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: colorPrimaryText,
            height: 1.2,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Creating Memories',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: colorSubtext,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1DEEA)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(44, 35, 58, 0.05),
            blurRadius: 16,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: colorAccentPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Create account',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(child: Divider(color: Color(0xFFE1DEEA))),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'or',
                  style: TextStyle(color: Color(0xFF8C859D), fontSize: 12),
                ),
              ),
              Expanded(child: Divider(color: Color(0xFFE1DEEA))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2EFF8),
                    foregroundColor: colorPrimaryText,
                    side: const BorderSide(color: Color(0xFFDCD7EA)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text('Google', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2EFF8),
                    foregroundColor: colorPrimaryText,
                    side: const BorderSide(color: Color(0xFFDCD7EA)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text('Apple', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: colorFooterBg,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: const Text(
        '© AMU Application. All rights reserved.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFFE1DEEA),
          fontSize: 12,
        ),
      ),
    );
  }
}