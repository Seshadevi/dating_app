import 'package:dating/constants/dating_app_user.dart';
import 'package:flutter/material.dart';
import 'mode_screen.dart';

class IntroMail extends StatefulWidget {

  const IntroMail({super.key,});

  @override
  State<IntroMail> createState() => _IntroMailState();
}

class _IntroMailState extends State<IntroMail> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
   
   String? mobile;
   double? latitude;
   double? longitude;
   String? dateofbirth;
   String? userName;
   String? selectedgender;
   bool? showonprofile;
   bool _isInitialized = false;

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  
  if (!_isInitialized) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args.containsKey('email') && args['email'] != null && args['email'].toString().isNotEmpty) {
        emailController.text = args['email'];
      }
      mobile = args['mobile'] ?? '';
      latitude = args['latitude'] ?? 0.0 ;
      longitude = args['longitude'] ?? 0.0 ;
      dateofbirth = args['dateofbirth'] ?? '';
      userName = args['userName'] ?? '';
      selectedgender = args['selectgender'] ?? '';
      showonprofile = args['showonprofile'] ?? true;
    }
    _isInitialized = true; // Mark as initialized
  }
}


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: DatingColors.white,
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
                    value: 5 / 18,
                    backgroundColor: DatingColors.lightgrey,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      DatingColors.primaryGreen,
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
                        onPressed: () {
                            Navigator.pushNamed(
                                    context,
                                    '/profileshowscreen',
                                    arguments: {
                                      'latitude': latitude,
                                      'longitude': longitude,
                                      'dateofbirth':dateofbirth,
                                      'userName':userName,
                                      'selectgender':selectedgender,
                                      "showonprofile":showonprofile,
                                      'email':emailController.text,
                                      'mobile':mobile
                                    },
                                );
                        },
                      ),
                      const SizedBox(width: 12),
                      // const Text(
                      //   "Email address",
                      //   style: TextStyle(
                      //     fontSize: 24,
                      //     fontWeight: FontWeight.bold,
                      //     fontFamily: 'Poppins',
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Used to recover your account",
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
                      color: DatingColors.black,
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
                              colors: [DatingColors.primaryGreen, DatingColors.black],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            color: DatingColors.white,
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                 print("latitiude:$latitude");
                                 print("longitude:$longitude");
                                 print("dateofbirth:$dateofbirth");
                                 print("userName:$userName");
                                 print("selectedgender:$selectedgender");
                                 print("showonprofile:$showonprofile");
                                 print("email:$emailController");
                                 print("mobile:$mobile");
                                 Navigator.pushNamed(
                                    context,
                                    '/modescreen',
                                    arguments: {
                                      'latitude': latitude,
                                      'longitude': longitude,
                                      'dateofbirth':dateofbirth,
                                      'userName':userName,
                                      'selectgender':selectedgender,
                                      "showonprofile":showonprofile,
                                      'email':emailController.text,
                                      'mobile':mobile
                                    },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 210),
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
          color: DatingColors.lightyellow,
          borderRadius: BorderRadius.circular(18.0),
          border: Border.all(color: DatingColors.primaryGreen, width: 1.0),
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
            color: DatingColors.black,
            fontFamily: 'Inter',
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}
