import 'package:flutter/material.dart';
import '../screens/datecategory.dart'; // Make sure this exists

class IntroMail extends StatefulWidget {
  const IntroMail({super.key});

  @override
  State<IntroMail> createState() => _IntroMailState();
}

class _IntroMailState extends State<IntroMail> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // For validation

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'poppins',
                        fontSize: 16.0,
                        letterSpacing: 1.28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                                    email: emailController.text, onSelectionComplete: (String selectedGender, String email) {  },
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
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/mail_frame.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
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
            } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                .hasMatch(value)) {
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
