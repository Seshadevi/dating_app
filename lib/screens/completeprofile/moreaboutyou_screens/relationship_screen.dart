import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/kids_screen.dart';
import 'package:flutter/material.dart';

class RelationshipScreen extends StatefulWidget {
  const RelationshipScreen({super.key});

  @override
  State<RelationshipScreen> createState() => _RelationshipScreenState();
}

class _RelationshipScreenState extends State<RelationshipScreen> {
  List<String> selectedOptions = [];
  
  final List<String> options = [
    'Single',
    'In a Relationship',
    'Engaged',
    'Married',
    'Its Complicated',
    'Dicorced',
    'Widowed',
    
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Header with icon and title
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: DatingColors.darkGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: DatingColors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'What Is Your Relationship Status',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: DatingColors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Options list
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = selectedOptions.contains(option);
                  final isFirstOption = index == 0;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GestureDetector(
                      onTap: () => toggleOption(option),
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? (isFirstOption 
                                  ? const LinearGradient(
                                      colors: [DatingColors.darkGreen, DatingColors.black],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    )
                                  : const LinearGradient(
                                      colors: [DatingColors.primaryGreen, DatingColors.black],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ))
                              : null,
                          color: isSelected ? null : DatingColors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: isSelected 
                                ? DatingColors.black
                                : DatingColors.darkGreen,
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
                },
              ),
            ),
            // Skip button
            Center(
              child: TextButton(
                onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => HaveKidsScreen(),));
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}