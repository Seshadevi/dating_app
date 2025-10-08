import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/settings/dark_mode_provider.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/star_sign_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewToAreaScreen extends ConsumerStatefulWidget {
  const NewToAreaScreen({super.key});

  @override
  ConsumerState<NewToAreaScreen> createState() => _NewToAreaScreenState();
}

class _NewToAreaScreenState extends ConsumerState<NewToAreaScreen> {
  String? selectedOption;
  bool isLoading = false;

  final List<String> options = [
    'New To Town',
    "I'm a Local",
  ];

  Future<void> selectOption(String option) async {
    // Update UI immediately for better UX
    setState(() {
      selectedOption = option;
      isLoading = true;
    });

    print('Selected option: $option');

    try {
      await ref.read(loginProvider.notifier).updateProfile(
            image: null,
            modeid: null,
            bio: null,
            modename: null,
            prompt: null,
            qualityId: null,
            jobId: null,
            newarea: option,
          );

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New area status updated successfully!'),
          backgroundColor: DatingColors.everqpidColor,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Auto-navigate after successful update
      await Future.delayed(const Duration(milliseconds: 500));
      // if (mounted) {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => const StarSignScreen()),
      //   );
      // }
      Navigator.pop(context);
    } catch (e) {
      print('Error updating new area: $e');

      // Reset selection on error
      setState(() {
        selectedOption = null;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider);

    return Scaffold(
      backgroundColor: isDarkMode? DatingColors.black : DatingColors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode? DatingColors.black : DatingColors.white,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.close, color: isDarkMode? DatingColors.white : DatingColors.black, size: 24),
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
                    color: DatingColors.everqpidColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:  Icon(
                    Icons.location_on_outlined,
                    color: isDarkMode? DatingColors.white : DatingColors.brown,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                 Flexible(
                  child: Text(
                    'Are you new to the area?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode? DatingColors.white : DatingColors.brown,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),

            // Options list
            ...options.map((option) {
              final isSelected = selectedOption == option;
              final isFirstOption = option == 'New To Town';

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: GestureDetector(
                  onTap: isLoading ? null : () => selectOption(option),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
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
                      color: isSelected ? null : DatingColors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: isSelected
                            ? DatingColors.lightgrey
                            : DatingColors.everqpidColor.withOpacity(0.5),
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color:
                                    DatingColors.everqpidColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: isLoading && isSelected
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  DatingColors.brown,
                                ),
                              ),
                            )
                          : Text(
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

            const Spacer(),

            // Skip button
            // Center(
            //   child: TextButton(
            //     onPressed: isLoading ? null : () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => const StarSignScreen(),
            //         ),
            //       );
            //     },
            //     child: Text(
            //       'Skip',
            //       style: TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.w500,
            //         color: isLoading
            //             ? DatingColors.lightgrey.withOpacity(0.5)
            //             : DatingColors.lightgrey,
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
