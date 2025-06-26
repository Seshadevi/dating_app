import 'package:dating/screens/introMail.dart';
import 'package:flutter/material.dart';

class GenderDisplayScreen extends StatefulWidget {
 
 const GenderDisplayScreen({
    super.key,
    });

  @override
  State<GenderDisplayScreen> createState() => _GenderDisplayScreenState();
}

class _GenderDisplayScreenState extends State<GenderDisplayScreen> {
   String? entryemail;
   String? mobile;
   double? latitude;
   double? longitude;
   String? dateofbirth;
   String? userName;
   String selectedgender='';
   bool showGenderOnProfile = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null ) { // Prevent overwriting selected products
      setState(() {
         entryemail = args['email'] ?? '';
         mobile= args['mobile'] ?? '';
         latitude=args['latitude'] ?? 0.0 ;
         longitude=args['longitude']?? 0.0 ;
         dateofbirth=args['dateofbirth'] ?? '';
         userName=args['userName'] ?? '';
         selectedgender=args['selectgender'] ?? '';
         showGenderOnProfile =args['showonprofile'] ?? true ;
      });
    }
  }
  

  void nextPage() {
    // Implement your navigation logic
    print("Next Page Triggered");
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Decorative Image
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset(
              'assets/mail_frame.png',
              fit: BoxFit.contain,
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Spacer(flex: 2),
                const SizedBox(height: 10),

                  // 🔵 Progress Bar
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16),
                  //   child: 
                    LinearProgressIndicator(
                      value: 4/ 18,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 147, 179, 3),
                      ),
                    ),
                  // ),
                  const SizedBox(height: 15),

                  // 🔙 Back button and title
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16),
                  //   child:
                     Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          iconSize: 30,
                          onPressed: () {
                               Navigator.pushNamed(
                                context,
                                '/genderstaticselection',
                                arguments: {
                                  'latitude': latitude,
                                  'longitude': longitude,
                                  'dateofbirth':dateofbirth,
                                  'userName':userName,
                                  'selectgender':selectedgender,
                                  'email':entryemail,
                                  'mobile':mobile
                             },);
                          },
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Oh Hey! Let's Start\nWith An Intro",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  // ),
                const SizedBox(height: 10),
                const Text(
                  "It’s Totally Up To You Whether\nYou Feel Comfortable Sharing\nThis.",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),

                const Text(
                  "Shown As:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),

                Chip(
                  label: Text(selectedgender!.isEmpty
                      ? "Man"
                      : selectedgender),
                  backgroundColor: const Color(0xffB2D12E),
                ),

                const SizedBox(height: 24),
                Row(
                  children: [
                    const Text(
                      "Show On Profile",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const Spacer(),
                    Switch(
                      value: showGenderOnProfile,
                      onChanged: (val) => setState(() {
                        showGenderOnProfile = val;
                      }),
                      activeColor: const Color(0xffB2D12E),
                    ),
                  ],
                ),
                const Spacer(flex: 4),
              ],
            ),
          ),

          // Bottom right forward button
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
                        // if (selectedGender.isNotEmpty) {
                        //   // Navigate to next screen
                        //   // Example:
                          Navigator.pushNamed(
                            context,
                            '/emailscreen',
                            arguments: {
                              'latitude': latitude,
                              'longitude': longitude,
                              'dateofbirth':dateofbirth,
                              'userName':userName,
                              'selectgender':selectedgender,
                              "showonprofile":showGenderOnProfile,
                              'email':entryemail,
                              'mobile':mobile
                            },);
                        // } else {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(content: Text("Please select a gender")),
                        //   );
                        // }
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
