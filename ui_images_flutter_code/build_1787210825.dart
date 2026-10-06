import 'package:flutter/material.dart';

void main() {
  runApp(const NexoRydApp());
}

class NexoRydApp extends StatelessWidget {
  const NexoRydApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NexoRyd',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        primaryColor: const Color(0xFFE5EBF5),
        scaffoldBackgroundColor: const Color(0xFFE5EBF5),
      ),
      home: const ProfileSetupScreen(),
    );
  }
}

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  String selectedGender = 'Male';
  final TextEditingController _nameController =
      TextEditingController(text: 'Rajendra Prasad');
  final TextEditingController _emailController =
      TextEditingController(text: 'rajendra@gmail.com');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Status / Header bar area
                Row(
                  justifyAxisAlignment: mapToRowAlignment(MainAxisAlignment.spaceBetween),
                  children: [
                    const Text(
                      '9:41',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.signal_cellular_alt, size: 16, color: Colors.black87),
                        SizedBox(width: 4),
                        Icon(Icons.wifi, size: 16, color: Colors.black87),
                        SizedBox(width: 4),
                        Icon(Icons.battery_full, size: 16, color: Colors.black87),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 32),

                // Welcome Header
                const Text(
                  'Welcome to NexoRyd',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Let's set up your profile",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 36),

                // Full Name Input
                const Text(
                  'Full Name',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: InputBorder.none,
                      hintText: 'Enter your full name',
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Email Input
                const Text(
                  'Email Address',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: InputBorder.none,
                      hintText: 'Enter your email address',
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Gender Selection Label
                const Text(
                  'Gender',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),

                // Gender Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: _buildGenderButton('Male', const Color(0xFFE4EDFB)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGenderButton('Female', const Color(0xFFF9F9FA)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGenderButton('Others', const Color(0xFFF9F9FA)),
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Action details
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Setting up profile for ${_nameController.text}...'),
                          backgroundColor: const Color(0xFF1E293B),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Terms of Service Footer
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Terms of Service & Privacy Policy',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),

                // Bottom Indicator pill mimic
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCFDBEF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderButton(String gender, Color unselectedColor) {
    final bool isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E293B) : unselectedColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E293B) : Colors.transparent,
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          gender,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1E293B),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // Visual features mapper
  MainAxisAlignment mapToRowAlignment(MainAxisAlignment defaultAlignment) {
    return defaultAlignment;
  }
}