import 'package:dating/screens/genderselection_screen.dart';
import 'package:flutter/material.dart';

class IntroPageScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  const IntroPageScreen({super.key, required this.latitude, required this.longitude});

  @override
  State<IntroPageScreen> createState() => _IntroPageScreenState();
}

class _IntroPageScreenState extends State<IntroPageScreen> {
  String userName = '';
  String _month = '';
  String _day = '';
  String _year = '';
  String dateOfBirth = '';

  Widget _styledInput({
    required String label,
    required String hint,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _birthdayInput(String hint, Function(String) onChanged) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      ),
      keyboardType: TextInputType.number,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 🎨 Background Decorations
          Positioned(
            left: -50,
            top: 300,
            child: Image.asset(
              'assets/CornerEllipse.png',
              width: screenWidth * 0.4,
            ),
          ),
          Positioned(
            left: screenWidth * 0.075,
            top: screenWidth * 0.96,
            child: Image.asset(
              'assets/Ellipse_439.png',
              width: screenWidth * 0.25,
            ),
          ),
          Positioned(
            top: screenWidth * 1.05,
            right: screenWidth * 0.05,
            child: Image.asset(
              'assets/balloons.png',
              width: screenWidth * 0.4,
            ),
          ),

          // 🧾 Foreground Form Content
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // 🔵 Progress Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: LinearProgressIndicator(
                      value: 1 / 16,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 147, 179, 3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 🔙 Back Button + Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Oh Hey! Let's Start\nWith An Intro",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 👤 Name Input
                  _styledInput(
                    label: "Your First Name",
                    hint: "Enter your name",
                    onChanged: (value) {
                      setState(() => userName = value);
                    },
                  ),

                  const SizedBox(height: 40),

                  // 🎂 Birthday Inputs
                  const Text("Your Birthday", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _birthdayInput("Month", (value) {
                          setState(() {
                            _month = value;
                            dateOfBirth = '$_month/$_day/$_year';
                          });
                        }),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _birthdayInput("Day", (value) {
                          setState(() {
                            _day = value;
                            dateOfBirth = '$_month/$_day/$_year';
                          });
                        }),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _birthdayInput("Year", (value) {
                          setState(() {
                            _year = value;
                            dateOfBirth = '$_month/$_day/$_year';
                          });
                        }),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🕒 Info Text
                  const Text(
                    "It’s Never Too Early To Count Down",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),

                  const SizedBox(height: 120), // Space for FAB button
                ],
              ),
            ),
          ),

          // ✅ Next Button (FAB style)
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 24, bottom: 24),
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: screenWidth * 0.125,
                  height: screenWidth * 0.125,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xffB2D12E), Color(0xff000000)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onPressed: () {
                      if (userName.isNotEmpty &&
                          _month.isNotEmpty &&
                          _day.isNotEmpty &&
                          _year.isNotEmpty) {
                        // Example navigation
                        Navigator.push(context, MaterialPageRoute(builder: (_) => GenderSelectionScreen(
                          latitude:widget.latitude,
                         longitude: widget.longitude,
                         userName: userName,
                         dateOfBirth: dateOfBirth,
                        )));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please fill in all fields")),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
