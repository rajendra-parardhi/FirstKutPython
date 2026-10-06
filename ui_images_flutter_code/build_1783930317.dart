import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI Components',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat', // A modern sans-serif font
      ),
      home: const ComponentsGridScreen(),
    );
  }
}

class ComponentsGridScreen extends StatelessWidget {
  const ComponentsGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EFFE), // Light purple/grey background
      appBar: AppBar(
        toolbarHeight: 0, // Hide app bar to match screenshot
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.85, // Adjust as needed to fit content
            ),
            itemCount: 15, // 5 rows * 3 columns
            itemBuilder: (context, index) {
              switch (index) {
                case 0: return _buildComponentCard('Container', _buildContainerContent());
                case 1: return _buildComponentCard('Row & Column', _buildRowColumnContent());
                case 2: return _buildComponentCard('Stack', _buildStackContent());
                case 3: return _buildComponentCard('Expanded & Flexible', _buildExpandedFlexibleContent());
                case 4: return _buildComponentCard('Image.asset', _buildImageAssetContent());
                case 5: return _buildComponentCard('ListView', _buildListViewContent());
                case 6: return _buildComponentCard('GridView', _buildGridViewContent());
                case 7: return _buildComponentCard('Card', _buildUserProfileCardContent());
                case 8: return _buildComponentCard('Scrollable Column', _buildScrollableColumn1Content());
                case 9: return _buildComponentCard('Card', _buildPlaceholderCardContent());
                case 10: return _buildComponentCard('Divider & Spacer', _buildDividerSpacerContent());
                case 11: return _buildComponentCard('Scrollable Column', _buildScrollableColumn2Content());
                default: return Container(); // Empty for remaining cells if any
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildComponentCard(String title, Widget content) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Expanded(child: Center(child: content)),
          ],
        ),
      ),
    );
  }

  Widget _buildContainerContent() {
    return Container(
      width: 80,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFAEDCDC), // JSON color
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildRowColumnContent() {
    return Column(
      mainAxisSize: MainMinSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 25, height: 25, decoration: const BoxDecoration(color: Color(0xFFF48B96), shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Container(width: 25, height: 25, decoration: BoxDecoration(color: const Color(0xFF9478F1), borderRadius: BorderRadius.circular(4))),
            const SizedBox(width: 8),
            Container(width: 25, height: 25, decoration: BoxDecoration(color: const Color(0xFFF9B76A), borderRadius: BorderRadius.circular(4))),
          ],
        ),
        const SizedBox(height: 8),
        const Icon(Icons.star, color: Color(0xFFFCD035), size: 30),
      ],
    );
  }

  Widget _buildStackContent() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFE1E8EF), // JSON color
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.photo_camera_rounded, color: Colors.white, size: 40),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF9B76A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Badge',
              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedFlexibleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 50,
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFEF5350), // Red
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(child: Text('1x', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            height: 50,
            margin: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF66BB6A), // Green
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(child: Text('2x', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ),
        ),
      ],
    );
  }

  Widget _buildImageAssetContent() {
    return Container(
      width: 100,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F6FF), // Light blue sky
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                color: Color(0xFFFCD035), // Sun yellow
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _MountainClipper(),
              child: Container(
                height: 50,
                color: const Color(0xFF66BB6A), // Green mountains
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListViewContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
        (i) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Container(
            width: 80,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridViewContent() {
    const List<Color> gridColors = [
      Color(0xFFEF5350), Color(0xFF66BB6A), Color(0xFFFFA726),
      Color(0xFF42A5F5), Color(0xFF9478F1), Color(0xFF8D6E63),
      Color(0xFFAB47BC), Color(0xFF78909C), Color(0xFFF48B96),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Disable scrolling for this internal grid
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: 9,
      itemBuilder: (context, i) => Container(
        decoration: BoxDecoration(
          color: gridColors[i],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildUserProfileCardContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.person_outline, size: 40, color: Color(0xFF757575)),
        SizedBox(height: 8),
        Text(
          'John Doe',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        SizedBox(height: 4),
        Text(
          'john-doe@eamik.com',
          style: TextStyle(
            fontSize: 10,
            color: Color(0xFF757575),
          ),
        ),
      ],
    );
  }

  Widget _buildScrollableColumn1Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Heading',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Left', style: TextStyle(fontSize: 12, color: Color(0xFF555555))),
            Text('Right', style: TextStyle(fontSize: 12, color: Color(0xFF555555))),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaceholderCardContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Container(
            width: index == 0 ? 60 : (index == 1 ? 90 : 70), // Varying line lengths
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDividerSpacerContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Column(
          children: [
            Container(
              height: 1,
              width: 80,
              color: const Color(0xFFE0E0E0),
            ),
            if (index < 2) const SizedBox(height: 10), // Spacing between dividers
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableColumn2Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Heading',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
        ),
        SizedBox(height: 8),
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', // Longer text to imply scrollability
          style: TextStyle(fontSize: 12, color: Color(0xFF555555)),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// Custom Clipper for mountains in Image.asset example
class _MountainClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.lineTo(size.width * 0.3, size.height * 0.3);
    path.lineTo(size.width * 0.6, size.height * 0.8);
    path.lineTo(size.width, size.height * 0.4);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}