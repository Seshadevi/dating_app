// import 'package:dating/constants/dating_app_user.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class IntroPageScreen extends StatefulWidget {
//   const IntroPageScreen({super.key});

//   @override
//   State<IntroPageScreen> createState() => _IntroPageScreenState();
// }

// class _IntroPageScreenState extends State<IntroPageScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _monthController = TextEditingController();
//   final TextEditingController _dayController = TextEditingController();
//   final TextEditingController _yearController = TextEditingController();

//   String? entryemail;
//   String? mobile;
//   double? latitude;
//   double? longitude;
//   String _month = '';
//   String _day = '';
//   String _year = '';
//   String dateOfBirth = '';

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

//     if (args != null) {
//       setState(() {
//         entryemail = args['email'] ?? '';
//         mobile = args['mobile'] ?? '';
//         latitude = args['latitude'] ?? 0.0;
//         longitude = args['longitude'] ?? 0.0;

//         if (_nameController.text.isEmpty && args['userName'] != null && args['userName'].toString().isNotEmpty) {
//           _nameController.text = args['userName'];
//         }

//         final dobArg = args['dateofbirth'];
//         if (dobArg != null && dobArg is String && dobArg.trim().isNotEmpty && dobArg.contains('/')) {
//           dateOfBirth = dobArg;
//           final parts = dobArg.split('/');
//           if (parts.length == 3) {
//             _month = parts[0];
//             _day = parts[1];
//             _year = parts[2];

//             _monthController.text = _month;
//             _dayController.text = _day;
//             _yearController.text = _year;
//           }
//         }
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _monthController.dispose();
//     _dayController.dispose();
//     _yearController.dispose();
//     super.dispose();
//   }

//   Widget _styledInput({
//     required String label,
//     required String hint,
//     required TextEditingController controller,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 10),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             hintText: hint,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _birthdayInput({
//     required String hint,
//     required int maxLength,
//     required Function(String) onChanged,
//     required TextEditingController controller,
//   }) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: hint,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//       ),
//       keyboardType: TextInputType.number,
//       inputFormatters: [
//         LengthLimitingTextInputFormatter(maxLength),
//         FilteringTextInputFormatter.digitsOnly,
//       ],
//       onChanged: onChanged,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: DatingColors.white,
//       body: Stack(
//         children: [
//           // Background Decorations
//           // Positioned(
//           //   left: -50,
//           //   top: 400,
//           //   child: Image.asset(
//           //     'assets/CornerEllipse.png',
//           //     width: screenWidth * 0.4,
//           //   ),
//           // ),
//           // Positioned(
//           //   left: screenWidth * 0.075,
//           //   top: screenWidth * 1.3,
//           //   child: Image.asset(
//           //     'assets/Ellipse_439.png',
//           //     width: screenWidth * 0.25,
//           //   ),
//           // ),
//           // Positioned(
//           //   top: screenWidth * 1.35,
//           //   right: screenWidth * 0.05,
//           //   child: Image.asset(
//           //     'assets/balloons.png',
//           //     width: screenWidth * 0.4,
//           //   ),
//           // ),

//           // Foreground Content
//           Positioned.fill(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 20),
//                   LinearProgressIndicator(
//                     value: 1 / 16,
//                     backgroundColor: DatingColors.lightgrey,
//                     valueColor: const AlwaysStoppedAnimation<Color>(
//                       DatingColors.primaryGreen,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.arrow_back_ios),
//                         iconSize: 30,
//                         onPressed: () {
//                           Navigator.pushNamed(
//                             context,
//                             '/allownotification',
//                             arguments: {
//                               'latitude': latitude,
//                               'longitude': longitude,
//                               'email': entryemail,
//                               'mobile': mobile,
//                             },
//                           );
//                         },
//                       ),
//                       const Text(
//                         "Qpid Unveiling",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: 'Poppins',
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 30),

//                   _styledInput(
//                     label: "Your First Name",
//                     hint: "Enter your name",
//                     controller: _nameController,
//                   ),

//                   const SizedBox(height: 40),

//                   const Text("Your Birthday", style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _birthdayInput(
//                           hint: "Month",
//                           maxLength: 2,
//                           controller: _monthController,
//                           onChanged: (value) {
//                             setState(() {
//                               _month = value;
//                               dateOfBirth = '$_day/$_month/$_year';
//                             });
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: _birthdayInput(
//                           hint: "Day",
//                           maxLength: 2,
//                           controller: _dayController,
//                           onChanged: (value) {
//                             setState(() {
//                               _day = value;
//                               dateOfBirth = '$_day/$_month/$_year';
//                             });
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: _birthdayInput(
//                           hint: "Year",
//                           maxLength: 4,
//                           controller: _yearController,
//                           onChanged: (value) {
//                             setState(() {
//                               _year = value;
//                               dateOfBirth = '$_day/$_month/$_year';
//                             });
//                           },
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 20),
//                   const Text(
//                     "It’s Never Too Early To Count Down",
//                     style: TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                   const SizedBox(height: 120),
//                 ],
//               ),
//             ),
//           ),

//           // FAB Button
//           Align(
//             alignment: Alignment.bottomRight,
//             child: Padding(
//               padding: const EdgeInsets.only(right: 24, bottom: 24),
//               child: Material(
//                 elevation: 10,
//                 borderRadius: BorderRadius.circular(50),
//                 child: Container(
//                   width: screenWidth * 0.125,
//                   height: screenWidth * 0.125,
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [DatingColors.primaryGreen, DatingColors.black],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                   child: IconButton(
//                     icon: const Icon(Icons.arrow_forward_ios, color: DatingColors.lightGreen),
//                     onPressed: () {
//                       final name = _nameController.text.trim();
//                       print("username: $name, month: $_month, day: $_day, year: $_year");
//                       print("date of birth: $dateOfBirth");

//                       if (_month.isNotEmpty && _day.isNotEmpty && _year.isNotEmpty) {
//                         Navigator.pushNamed(
//                           context,
//                           '/genderstaticselection',
//                           arguments: {
//                             'latitude': latitude,
//                             'longitude': longitude,
//                             'dateofbirth': dateOfBirth,
//                             'userName': name,
//                             'email': entryemail,
//                             'mobile': mobile,
//                           },
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Please fill in all fields")),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:dating/constants/dating_app_user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for formatting date

class IntroPageScreen extends StatefulWidget {
  const IntroPageScreen({super.key});

  @override
  State<IntroPageScreen> createState() => _IntroPageScreenState();
}

class _IntroPageScreenState extends State<IntroPageScreen> {
  final TextEditingController _nameController = TextEditingController();

  String? entryemail;
  String? mobile;
  double? latitude;
  double? longitude;
  DateTime? selectedDate;
  String dateOfBirth = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      setState(() {
        entryemail = args['email'] ?? '';
        mobile = args['mobile'] ?? '';
        latitude = args['latitude'] ?? 0.0;
        longitude = args['longitude'] ?? 0.0;

        if (_nameController.text.isEmpty &&
            args['userName'] != null &&
            args['userName'].toString().isNotEmpty) {
          _nameController.text = args['userName'];
        }

        final dobArg = args['dateofbirth'];
        if (dobArg != null && dobArg is String && dobArg.trim().isNotEmpty) {
          try {
            selectedDate = DateFormat("dd/MM/yyyy").parse(dobArg);
            dateOfBirth = dobArg;
          } catch (_) {}
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Widget _styledInput({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
       TextField(
  controller: controller,
  decoration: InputDecoration(
    hintText: hint,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: DatingColors.lightpinks, // Border color when not focused
        width: 1.5,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: DatingColors.lightpinks, // Border color when focused
        width: 2,
      ),
    ),
  ),
),

      ],
    );
  }

  

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = selectedDate ?? DateTime(now.year - 18, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: DatingColors.everqpidColor, // Header and selected date
              onPrimary: Colors.white, // Text on primary color
              surface: Color(0xFFF8E8FF), // Light pink background
              onSurface: Colors.black87, // Text color
              secondary: DatingColors.lightpinks, // Secondary elements
            ),
            dialogBackgroundColor: const Color(0xFFF0E6FF), // Light purple background
            textTheme: const TextTheme(
              headlineSmall: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
              bodyLarge: TextStyle(color: Colors.black87),
              bodyMedium: TextStyle(color: Colors.black54),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFE4F0), // Light pink
                  Color(0xFFF0E6FF), // Light purple
                  Color(0xFFE8F4FD), // Light blue
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: DatingColors.everqpidColor.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: child!,
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateOfBirth = DateFormat("dd/MM/yyyy").format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: DatingColors.white,
      body: Stack(
        children: [
          // Background image covering entire screen
          // Positioned.fill(
          //   child: Image.asset(
          //     "assets/everqpidbg.png",
          //     fit: BoxFit.cover,
          //   ),
          // ),
          
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: 1 / 8,
                    backgroundColor: DatingColors.lightgrey,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      DatingColors.everqpidColor,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        iconSize: 30,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/allownotification',
                            arguments: {
                              'latitude': latitude,
                              'longitude': longitude,
                              'email': entryemail,
                              'mobile': mobile,
                            },
                          );
                        },
                      ),
                      const Text(
                        "Qpid Unveiling",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  _styledInput(
                    label: "Your Name",
                    hint: "Enter your name",
                    controller: _nameController,
                  ),

                  const SizedBox(height: 40),

                  const Text("Your Birthday", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () => _pickDate(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: DatingColors.primaryGreen),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        selectedDate != null
                            ? DateFormat("dd MMMM yyyy").format(selectedDate!)
                            : "Select birth date",
                        style: TextStyle(
                          fontSize: 16,
                          color: selectedDate != null ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "It's Never Too Early To Count Down",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          // FAB Button
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
                      colors: [DatingColors.primaryGreen, DatingColors.black],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: DatingColors.lightGreen),
                    onPressed: () {
                      final name = _nameController.text.trim();
                      print("username: $name, date of birth: $dateOfBirth");

                      if (selectedDate != null) {
                        Navigator.pushNamed(
                          context,
                          '/genderstaticselection',
                          arguments: {
                            'latitude': latitude,
                            'longitude': longitude,
                            'dateofbirth': dateOfBirth,
                            'userName': name,
                            'email': entryemail,
                            'mobile': mobile,
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please select your birthday")),
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