import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slot Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark, // Overall dark theme
        scaffoldBackgroundColor: const Color(0xFF211B22), // Main background color from JSON
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF211B22), // AppBar background matching scaffold
          elevation: 0,
          foregroundColor: Colors.white, // AppBar icons and text color
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600, // Matches visual weight of title
            fontFamily: 'Inter', // Custom font if desired, otherwise default sans-serif
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500), // For labels
          bodyMedium: TextStyle(color: Colors.white54, fontSize: 14), // For placeholder text
        ).apply(
          // Apply a general font family if needed, e.g., for Inter font
          // fontFamily: 'Inter',
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF292B34), // Input field background from JSON
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
            borderSide: BorderSide.none, // No visible border line
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.white54, width: 1), // Subtle focus border
          ),
          hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
          labelStyle: const TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEA5F57), // Send button color from JSON
            foregroundColor: Colors.white, // Send button text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), // Rounded corners
            ),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      home: const SlotBookingScreen(),
    );
  }
}

class SlotBookingScreen extends StatefulWidget {
  const SlotBookingScreen({super.key});

  @override
  State<SlotBookingScreen> createState() => _SlotBookingScreenState();
}

class _SlotBookingScreenState extends State<SlotBookingScreen> {
  String? _selectedLocation;
  String? _selectedSlot;

  // Example options for dropdown
  final List<String> _locations = ['New York', 'Los Angeles', 'Chicago', 'Houston'];
  final List<String> _slots = ['9:00 AM - 10:00 AM', '10:00 AM - 11:00 AM', '11:00 AM - 12:00 PM'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.pop(context); // Example back navigation
          },
        ),
        title: const Text('Slot Booking'),
        centerTitle: false, // Align title to the left
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Full Name', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    Text('Email', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter email address',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20.0),

                    Text('Mobile Number', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter your number', // Corrected from 'you number' based on common UI patterns
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20.0),

                    Text('Location', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 8.0),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        hintText: 'Select location',
                        // DropdownButtonFormField has a default suffix icon, matching the screenshot's chevron
                      ),
                      value: _selectedLocation,
                      items: _locations
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: Theme.of(context).textTheme.bodyMedium), // Using bodyMedium for item text
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedLocation = newValue;
                        });
                      },
                      dropdownColor: const Color(0xFF292B34), // Background for dropdown menu
                      iconEnabledColor: Colors.white54, // Dropdown arrow color
                      style: Theme.of(context).textTheme.bodyMedium, // Style for selected value display
                    ),
                    const SizedBox(height: 20.0),

                    Text('Slot', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 8.0),
                    GestureDetector(
                      onTap: () async {
                        // Simulate opening a time picker or slot selector
                        final String? pickedSlot = await showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: const Color(0xFF292B34),
                              title: const Text('Select a Slot', style: TextStyle(color: Colors.white)),
                              content: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: _slots.map((slot) => ListTile(
                                    title: Text(slot, style: const TextStyle(color: Colors.white70)),
                                    onTap: () {
                                      Navigator.of(context).pop(slot);
                                    },
                                  )).toList(),
                                ),
                              ),
                            );
                          },
                        );
                        if (pickedSlot != null && pickedSlot != _selectedSlot) {
                          setState(() {
                            _selectedSlot = pickedSlot;
                          });
                        }
                      },
                      child: AbsorbPointer( // Prevents text field from being directly editable
                        child: TextFormField(
                          readOnly: true, // Make it read-only
                          controller: TextEditingController(text: _selectedSlot ?? ''),
                          decoration: const InputDecoration(
                            hintText: 'Select slot',
                            suffixIcon: Icon(Icons.access_time, color: Colors.white54), // Clock icon
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    Text('Message', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Write a message',
                      ),
                      maxLines: 5, // Allow multiple lines for message
                      minLines: 3,
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
            // Send button fixed at the bottom
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity, // Make button full width
                child: ElevatedButton(
                  onPressed: () {
                    // Handle send button press logic
                    print('Send button pressed!');
                  },
                  child: const Text('Send'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}