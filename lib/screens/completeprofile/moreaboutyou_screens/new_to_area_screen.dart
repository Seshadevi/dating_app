import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/star_sign_screen.dart';
import 'package:flutter/material.dart';

class NewToAreaScreen extends StatefulWidget {
  const NewToAreaScreen({super.key});

  @override
  State<NewToAreaScreen> createState() => _NewToAreaScreenState();
}

class _NewToAreaScreenState extends State<NewToAreaScreen> {
  List<String> selectedOptions = [];
  
  final List<String> options = [
    'New To Town',
    'Im a Local',
  ];

  void toggleOption(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DatingColors.white,
      appBar: AppBar(
        backgroundColor: DatingColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: DatingColors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 150),
            // Header with icon and title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: DatingColors.darkGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.location_on_outlined,
                    color: DatingColors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Are you new to the area',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: DatingColors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            // Options list
            ...options.map((option) {
              final isSelected = selectedOptions.contains(option);
              final isFirstOption = option == 'New To Town';
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: GestureDetector(
                  onTap: () => toggleOption(option),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? (isFirstOption 
                              ? const LinearGradient(
                                  colors: [DatingColors.primaryGreen, DatingColors.black],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                              : const LinearGradient(
                                  colors: [DatingColors.primaryGreen,DatingColors.black],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ))
                          : null,
                      color: isSelected ? null : DatingColors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: isSelected 
                            ? DatingColors.black 
                            : DatingColors.primaryGreen,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? DatingColors.white : DatingColors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
            const Spacer(),
            // Skip button
            Center(
              child: TextButton(
                onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => StarSignScreen(),));
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: DatingColors.lightgrey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}