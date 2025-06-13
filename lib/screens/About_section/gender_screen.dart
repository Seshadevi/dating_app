import 'package:dating/screens/About_section/about_mengender.dart';
import 'package:dating/screens/About_section/about_nonbinary.dart';
import 'package:dating/screens/About_section/about_womengender.dart';
import 'package:dating/screens/About_section/learn_more_screen.dart';
import 'package:flutter/material.dart';

class UpdateGenderScreen extends StatefulWidget {
  const UpdateGenderScreen({super.key});

  @override
  State<UpdateGenderScreen> createState() => _UpdateGenderScreenState();
}

class _UpdateGenderScreenState extends State<UpdateGenderScreen> {
  String selectedGender = 'Woman';
  bool showOnProfile = true;

  void navigateToPronounsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PronounsScreen()),
    );
  }

  void navigateToLearnMore() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LearnMoreScreen()),
    );
  }

  Widget genderOption(BuildContext context, String gender) {
  final isSelected = selectedGender == gender;

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    margin: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: isSelected ? const Color(0xFF89A000) : Colors.transparent,
      gradient: isSelected
          ? const LinearGradient(
              colors: [Color(0xFF89A000), Colors.black],
            )
          : null,
      border: Border.all(color: const Color(0xFF89A000)),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => selectedGender = gender),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                gender,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
              Icon(
                isSelected ? Icons.toggle_on : Icons.toggle_off_outlined,
                color: isSelected ? Colors.white : const Color(0xFF89A000),
                size: 32,
              ),
            ],
          ),
        ),
        if (isSelected)
          GestureDetector(
            onTap: () {
              if (gender == 'Woman') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AboutMengender(genderOptions: ["Intersex Man",
                        "Trans Man",
                        "Transmasculine",
                        "Man And Nonbinary",
                        "Cis Man",],
                     
                    ),
                  ),
                );
              } else if (gender == 'Man') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddGenderDetailsScreen(
                      // genderOptions: [
                      //   "Intersex Man",
                      //   "Trans Man",
                      //   "Transmasculine",
                      //   "Man And Nonbinary",
                      //   "Cis Man",
                      // ],
                    ),
                  ),
                );
              } else if (gender == 'Nonbinary') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AboutNonbinary(
                      genderOptions:[
                        "Agender",
                        "Bigender",
                        "Genderfluid",
                        "Genderqueer",
                        "Gender Nonconforming",
                        "Gender Questioning",
                        "Gender Variant",
                        "Intersex",
                        "Neutrois",
                        "Nonbinary Man",
                        "Nonbinary Woman",
                        "Pangender",
                        "Polygender",
                        "Transgender",
                        "Two Spirit",
                      ],
                    ),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: const [
                  Text(
                    'Add More About Your Gender',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.white70),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Your Gender', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pick Which Best Describe You', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
            // Row(
            //   children: [
                const Text('Then add more about your gender if you like',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
                // SizedBox(height: 5,),
                TextButton(
                  onPressed: navigateToLearnMore,
                  child: const Text('Learn What This Means',style: TextStyle(decoration:TextDecoration.underline),),
                ),
              // ],
            // ),
            genderOption(context, "Woman"),
            genderOption(context, "Man"),
            genderOption(context, "Nonbinary"),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF89A000)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Show On Your Profile'),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF89A000),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Show As: $selectedGender', style: const TextStyle(color: Colors.white)),
                    ),
                  ]),
                  Switch(
                    value: showOnProfile,
                    onChanged: (value) => setState(() => showOnProfile = value),
                    activeColor: const Color(0xFF89A000),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),
            GestureDetector(
              onTap: navigateToPronounsScreen,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF89A000)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Add Your Pronouns', style: TextStyle(color: Colors.grey)),
                    Icon(Icons.edit, color: Colors.black)
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
            Center(
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF89A000), Colors.black]),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Save and close', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PronounsScreen extends StatelessWidget {
  const PronounsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Your Pronouns')),
      body: const Center(child: Text('Pronouns Screen')),
    );
  }
}


