import 'package:flutter/material.dart';

void main() {
  runApp(const SlotBookingApp());
}

class SlotBookingApp extends StatelessWidget {
  const SlotBookingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Slot Booking',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFE65C55),
        scaffoldBackgroundColor: const Color(0xFF211B22),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFE65C55),
        ),
      ),
      home: const SlotBookingScreen(),
    );
  }
}

class SlotBookingScreen extends StatefulWidget {
  const SlotBookingScreen({Key? key}) : super(key: key);

  @override
  State<SlotBookingScreen> createState() => _SlotBookingScreenState();
}

class _SlotBookingScreenState extends State<SlotBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form Field Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  
  String? _selectedLocation;
  String? _selectedSlot;

  final List<String> _locations = ['New York', 'London', 'Tokyo', 'Paris'];
  final List<String> _slots = ['09:00 AM - 10:00 AM', '12:30 PM - 01:30 PM', '03:00 PM - 04:00 PM'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 600;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24.0 : size.width * 0.15,
              vertical: 40.0,
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 580),
              decoration: BoxDecoration(
                color: const Color(0xFF211B23),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Slot Booking",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, py: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE65C55).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "12:30 PM",
                            style: TextStyle(
                              color: Color(0xFFE65C55),
                              fontWeight: FontWeight.w640,
                              fontSize: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Name Input
                    _buildLabel("Full Name"),
                    _buildTextField(
                      controller: _nameController,
                      hintText: "Enter your name",
                      fillColor: const Color(0xFF292B34),
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 20),

                    // Email Input
                    _buildLabel("Email Address"),
                    _buildTextField(
                      controller: _emailController,
                      hintText: "Enter email address",
                      fillColor: const Color(0xFF292B35),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // Phone Input
                    _buildLabel("Mobile Number"),
                    _buildTextField(
                      controller: _phoneController,
                      hintText: "Enter your number",
                      fillColor: const Color(0xFF272830),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),

                    // Location Dropdown
                    _buildLabel("Location"),
                    _buildDropdown(
                      hintText: "Select location",
                      value: _selectedLocation,
                      items: _locations,
                      fillColor: const Color(0xFF23232A),
                      onChanged: (val) => setState(() => _selectedLocation = val),
                    ),
                    const SizedBox(height: 20),

                    // Slot Dropdown
                    _buildLabel("Slot"),
                    _buildDropdown(
                      hintText: "Select slot",
                      value: _selectedSlot,
                      items: _slots,
                      fillColor: const Color(0xFF222229),
                      onChanged: (val) => setState(() => _selectedSlot = val),
                      iconColor: const Color(0xFF56575C),
                    ),
                    const SizedBox(height: 20),

                    // Message Text Field
                    _buildLabel("Message"),
                    _buildTextField(
                      controller: _messageController,
                      hintText: "Write a message...",
                      fillColor: const Color(0xFF221C23),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 36),

                    // Send Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE65C55),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Booking details submitted successfully!'),
                                backgroundColor: Color(0xFFE65C55),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Send",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
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
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white.withOpacity(0.7),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required Color fillColor,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE65C55), width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown({
    required String hintText,
    required String? value,
    required List<String> items,
    required Color fillColor,
    required ValueChanged<String?> onChanged,
    Color? iconColor,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(
        hintText,
        style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
      ),
      dropdownColor: fillColor,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: iconColor ?? Colors.white.withOpacity(0.6),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE65C55), width: 1.5),
        ),
      ),
      items: items.map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select an option' : null,
    );
  }
}