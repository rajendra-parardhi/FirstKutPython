import 'package:flutter/material.dart';

void main() {
  runApp(const ParserDiagramApp());
}

class ParserDiagramApp extends StatelessWidget {
  const ParserDiagramApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parser Classification Diagram',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Roboto',
      ),
      home: const Scaffold(
        backgroundColor: Color(0xFFAD8D8C),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: ParserHierarchyView(),
            ),
          ),
        ),
      ),
    );
  }
}

class ParserHierarchyView extends StatelessWidget {
  const ParserHierarchyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 900),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: const Color(0xFFAD8D8C),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Root Level: Parser
          const NodeCard(
            label: "Parser",
            backgroundColor: Color(0xFFEC514A),
            fontSize: 20,
            isBold: true,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          ),
          const VerticalConnector(height: 24),

          // Main Category Branching Line
          const TreeBranchConnector(),

          // Level 1: Topdown / Bottomup Parsers
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Topdown Branch
              Expanded(
                child: Column(
                  children: [
                    const NodeCard(
                      label: "Topdown Parser",
                      backgroundColor: Color(0xFFA98F8E),
                      textColor: Colors.white,
                      fontSize: 16,
                      isBold: true,
                    ),
                    const VerticalConnector(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Expanded(
                          child: NodeCard(
                            label: "Recursive descent parser",
                            backgroundColor: Color(0xFFED5952),
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: NodeCard(
                            label: "LL1",
                            backgroundColor: Color(0xFFEF514B),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              // Bottomup Branch
              Expanded(
                child: Column(
                  children: [
                    const NodeCard(
                      label: "Bottomup Parser",
                      backgroundColor: Color(0xFFEF534C),
                      textColor: Colors.white,
                      fontSize: 16,
                      isBold: true,
                    ),
                    const VerticalConnector(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const NodeCard(
                                label: "LR parser",
                                backgroundColor: Color(0xFFED534D),
                                fontSize: 13,
                              ),
                              const VerticalConnector(height: 12),
                              // LR Parser Sub-types Container
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: const Color(0xFFD6B6A6),
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  children: const [
                                    Text(
                                      "LR(0)  •  SLR(1)",
                                      style: TextStyle(
                                        color: Color(0xFFAD8D8C),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "LALR(1)  •  CLR(1)",
                                      style: TextStyle(
                                        color: Color(0xFFAD8D8C),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: NodeCard(
                            label: "Operator precedence parser",
                            backgroundColor: Color(0xFFEB5A52),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NodeCard extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final bool isBold;
  final EdgeInsets padding;

  const NodeCard({
    Key? key,
    required this.label,
    required this.backgroundColor,
    this.textColor = Colors.white,
    this.fontSize = 14,
    this.isBold = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }
}

class VerticalConnector extends StatelessWidget {
  final double height;
  const VerticalConnector({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: height,
      color: Colors.white.withOpacity(0.8),
    );
  }
}

class TreeBranchConnector extends StatelessWidget {
  const TreeBranchConnector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: double.infinity,
      child: CustomPaint(
        painter: _BranchPainter(),
      ),
    );
  }
}

class _BranchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.25, size.height);
    path.lineTo(size.width * 0.25, 0);
    path.lineTo(size.width * 0.75, 0);
    path.lineTo(size.width * 0.75, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}