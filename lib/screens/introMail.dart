import 'package:flutter/material.dart';
import 'mode_screen.dart';

class IntroMail extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String userName;
  final String dateOfBirth;
  final String selectedGender;
  final bool showGenderOnProfile;

  const IntroMail({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.userName,
    required this.dateOfBirth,
    required this.selectedGender,
    required this.showGenderOnProfile,
  });

  @override
  State<IntroMail> createState() => _IntroMailState();
}

class _IntroMailState extends State<IntroMail> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 const SizedBox(height: 35),
                // 🔵 Progress Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LinearProgressIndicator(
                    value: 3 / 16,
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

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "We'll Use This To Recover Your \nAccount ASAP If You Can't Log In.",
                    style: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 15.0,
                      letterSpacing: 1.08,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Your Email',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'poppins',
                      fontSize: 20.0,
                      letterSpacing: 1.28,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildTextField(width: double.infinity),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Material(
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
                            color: Colors.white,
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => IntroDatecategory(
                                      email: emailController.text,
                                      latitude: widget.latitude,
                                      longitude: widget.longitude,
                                      userName: widget.userName,
                                      dateOfBirth: widget.dateOfBirth,
                                      selectedGender: widget.selectedGender,
                                      showGenderOnProfile: widget.showGenderOnProfile,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 160),
                SizedBox(
                  height: 150, // or any height you need
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: Image.asset(
                          'assets/mail_frame.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required double width}) {
    return Material(
      elevation: 10.0,
      borderRadius: BorderRadius.circular(18.0),
      child: Container(
        width: width,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xffE9F1C4),
          borderRadius: BorderRadius.circular(18.0),
          border: Border.all(color: const Color(0xff92AB26), width: 1.0),
        ),
        child: TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an email';
            } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Enter a valid email';
            }
            return null;
          },
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: InputBorder.none,
          ),
          style: const TextStyle(
            color: Color(0xff92AB26),
            fontFamily: 'Inter',
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}
