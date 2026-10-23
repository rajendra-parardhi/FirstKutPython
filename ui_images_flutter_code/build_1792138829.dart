import 'package:flutter/material.dart';

void main() {
  runApp(const ParserTaxonomyApp());
}

class ParserTaxonomyApp extends StatelessWidget {
  const ParserTaxonomyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parser Taxonomy Chart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F5F5),
        fontFamily: 'Roboto',
      ),
      home: const Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: ParserHierarchyWidget(),
            ),
          ),
        ),
      ),
    );
  }
}

class ParserHierarchyWidget extends StatelessWidget {
  const ParserHierarchyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 640),
      decoration: BoxDecoration(
        color: const Color(0xFFAD8D8C),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Root Node: Parser
          const NodeBadge(
            label: 'Parser',
            backgroundColor: Color(0xFFEC514A),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          ),
          const VerticalConnector(height: 20),
          
          // Horizontal Split Line
          const SplitLine(),
          const VerticalConnector(height: 16),

          // Main Categories: Topdown & Bottomup Parsers
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Topdown Branch
              Expanded(
                child: Column(
                  children: [
                    const NodeBadge(
                      label: 'Topdown Parser',
                      backgroundColor: Color(0xFFA98F8E),
                      textColor: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    const VerticalConnector(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Expanded(
                          child: NodeBadge(
                            label: 'Recursive descent parser',
                            backgroundColor: Color(0xFFED5952),
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: NodeBadge(
                            label: 'LL(1)',
                            backgroundColor: Color(0xFFEF514B),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Bottomup Branch
              Expanded(
                child: Column(
                  children: [
                    const NodeBadge(
                      label: 'Bottomup Parser',
                      backgroundColor: Color(0xFFEF534C),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    const VerticalConnector(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LR Parser Sub-branch
                        Expanded(
                          child: Column(
                            children: [
                              const NodeBadge(
                                label: 'LR parser',
                                backgroundColor: Color(0xFFED534D),
                                fontSize: 12,
                              ),
                              const VerticalConnector(height: 12),
                              // LR Sub-types Container
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFD6B6A6),
                                    width: 1.5,
                                  ),
                                ),
                                child: const Text(
                                  'LR(0)  SLR(1)\nLALR(1)  CLR(1)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFAD8D8C),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Operator Precedence Sub-branch
                        const Expanded(
                          child: NodeBadge(
                            label: 'Operator precedence parser',
                            backgroundColor: Color(0xFFEB5A52),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Footer Decorative Status Elements
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 45,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFFABACA3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 63,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFFBDB6BC),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 23,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6B6A6),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class NodeBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;

  const NodeBadge({
    Key? key,
    required this.label,
    required this.backgroundColor,
    this.textColor = Colors.white,
    this.fontSize = 12,
    this.fontWeight = FontWeight.normal,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
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
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}

class VerticalConnector extends StatelessWidget {
  final double height;
  const VerticalConnector({Key? key, this.height = 16}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: height,
      color: Colors.white70,
    );
  }
}

class SplitLine extends StatelessWidget {
  const SplitLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.7,
      child: Container(
        height: 2,
        color: Colors.white70,
      ),
    );
  }
}