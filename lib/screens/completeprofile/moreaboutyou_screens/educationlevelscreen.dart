import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Educationlevelscreen extends ConsumerStatefulWidget {
  const Educationlevelscreen({super.key});

  @override
  ConsumerState<Educationlevelscreen> createState() =>
      _EducationlevelscreenState();
}

class _EducationlevelscreenState extends ConsumerState<Educationlevelscreen> {
  String? selectedOption; // Preselected from user profile

  final List<String> options = [
    'High school',
    'In college',
    'Undergraduate degree',
    'In grad school',
    'Graduate degree'
  ];

  @override
  void initState() {
    super.initState();

    // Load preselected data from loginProvider after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userState = ref.read(loginProvider);
      final user = userState.data != null && userState.data!.isNotEmpty
          ? userState.data![0].user
          : null;

      if (user != null &&
          user.educationLevel != null &&
          user.educationLevel!.isNotEmpty) {
        setState(() {
          selectedOption = user.educationLevel; // Match exact string
        });
      }
    });
  }

  Future<void> selectOption(String option) async {
    setState(() {
      selectedOption = option;
    });

    try {
      await ref.read(loginProvider.notifier).updateProfile(
            image: null,
            modeid: null,
            bio: null,
            modename: null,
            prompt: null,
            qualityId: null,
            jobId: null,
            educationLevel: option,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('educationLevel updated successfully!')),
      );

      Navigator.pop(context, selectedOption);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update educationLevel: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DatingColors.white,
      appBar: AppBar(
        backgroundColor: DatingColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: DatingColors.everqpidColor, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: DatingColors.everqpidColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.sports_gymnastics,
                    color: DatingColors.brown,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Do You Work Out',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: DatingColors.brown,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            ...options.map((option) {
              final isSelected = selectedOption == option;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: GestureDetector(
                  onTap: () => selectOption(option),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [
                                DatingColors.lightpinks,
                                DatingColors.everqpidColor
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : null,
                      color: isSelected ? DatingColors.white : DatingColors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: isSelected
                            ? DatingColors.lightgrey
                            : DatingColors.everqpidColor,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? DatingColors.brown
                              : DatingColors.everqpidColor,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
            // const Spacer(),
            // Center(
            //   child: TextButton(
            //     onPressed: () {
            //       // Navigator.push(
            //       //   context,
            //       //   MaterialPageRoute(
            //       //       builder: (context) => const NewToAreaScreen()),
            //       // );
            //       Navigator.pop(context);
            //     },
            //     child: const Text(
            //       'Skip',
            //       style: TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.w500,
            //         color: DatingColors.lightgrey,
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
