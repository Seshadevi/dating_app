import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/new_to_area_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Havekidsscreen extends ConsumerStatefulWidget {
  const Havekidsscreen({super.key});

  @override
  ConsumerState<Havekidsscreen> createState() => _HavekidsscreenState();
}

class _HavekidsscreenState extends ConsumerState<Havekidsscreen> {
  String? selectedOption; // Preselected from user profile

  final List<String> options = [
    'Have kids',
    "Don't have kids",
    // '',
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

      if (user != null && user.haveKids != null && user.haveKids!.isNotEmpty) {
        setState(() {
          selectedOption = user.haveKids; // Match exact string
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
            haveKids: option,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('haveKids updated successfully!')),
      );

      Navigator.pop(context, selectedOption);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update haveKids: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DatingColors.white,
      appBar: AppBar(
        backgroundColor:DatingColors.white,
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
            const SizedBox(height: 150),
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
                    color: DatingColors.white,
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
                              colors: [DatingColors.lightpinks, DatingColors.everqpidColor],
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
                          color: isSelected ? DatingColors.brown : DatingColors.everqpidColor,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
            const Spacer(),
            // Center(
            //   child: TextButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const NewToAreaScreen()),
            //       );
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
