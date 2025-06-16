import 'package:dating/screens/gender_display_screen.dart';
import 'package:flutter/material.dart';

class GenderSelectionScreen extends StatefulWidget {
   final double latitude;
  final double longitude;
   final String userName;
  
   final String dateOfBirth;
  const GenderSelectionScreen({super.key, required this.latitude, required this.longitude, required this.userName, required this.dateOfBirth});

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  String selectedGender = '';
  

  Widget _radioOption(String label) {
    return RadioListTile<String>(
      title: Text(label),
      value: label,
      groupValue: selectedGender,
      activeColor: Colors.black,
      onChanged: (value) {
        setState(() => selectedGender = value!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // 🔵 Progress Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: LinearProgressIndicator(
                      value: 2 / 16,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 147, 179, 3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 🔙 Back button and title
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

                  const SizedBox(height: 10),

                  const Text(
                    "Pick The Gender That Best Describes You.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  // 🧑 Gender options
                  _radioOption("Woman"),
                  _radioOption("Man"),
                  _radioOption("Nonbinary"),

                  const SizedBox(height: 10),

                  // ℹ️ Info block
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.grey.shade500,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                            children: [
                              const TextSpan(text: "You Can Always Update This Later. "),
                              TextSpan(
                                text: "A Note About Gender On HeartSync.",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(), // Push everything up
                ],
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
                        if (selectedGender.isNotEmpty) {
                          // Navigate to next screen
                          
                          Navigator.push(context, MaterialPageRoute(builder: (_) => GenderDisplayScreen(
                             latitude:widget.latitude,
                              longitude: widget.longitude,
                              userName:widget. userName,
                              dateOfBirth: widget.dateOfBirth,
                              selectedGender: selectedGender,
                          )));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please select a gender")),
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
      ),
    );
  }
}
