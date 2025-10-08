import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/settings/dark_mode_provider.dart';
import 'package:dating/provider/signupprocessProviders/kidsProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HaveKidsScreen extends ConsumerStatefulWidget {
  const HaveKidsScreen({super.key});

  @override
  ConsumerState<HaveKidsScreen> createState() => _HaveKidsScreenState();
}

class _HaveKidsScreenState extends ConsumerState<HaveKidsScreen> {
  List<String> selectedOptions = [];

   @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      // Load available drink options
      await ref.read(kidsProvider.notifier).getKids();

      // Get logged in user data
      final user = ref.read(loginProvider).data?.first.user;

      if (user != null && user.drinking != null && user.drinking!.isNotEmpty) {
        // Extract preferences for preselection
        selectedOptions = user.kids!
            .map((drink) => drink.kids ?? '')
            .where((pref) => pref.isNotEmpty)
            .toList();

        // Extract IDs for updating later
        // selectedOptions = user.kids!
        //     .map((drink) => drink.id)
        //     .whereType<int>()
        //     .toList();
      }

      setState(() {});
    });
  }


  void toggleOption(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.clear();
        selectedOptions.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider);
    final kidsState = ref.watch(kidsProvider);

    return Scaffold(
      backgroundColor: isDarkMode ? DatingColors.black : DatingColors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? DatingColors.black : DatingColors.white,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.close, color: isDarkMode ? DatingColors.white : DatingColors.everqpidColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: DatingColors.everqpidColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.child_friendly, color: DatingColors.brown),
                ),
                const SizedBox(width: 12),
                Text(
                  'Do You Have Kids?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? DatingColors.white : Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            kidsState.data == null || kidsState.data!.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: kidsState.data!.length,
                      itemBuilder: (context, index) {
                        final option = kidsState.data![index].kids?? '';
                        final isSelected = selectedOptions.contains(option);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: GestureDetector(
                            
                             onTap: () async {
                                final optionId = kidsState.data![index].id; // Assuming API needs ID, not text

                                toggleOption(option);

                                // Call API to update
                                await ref.read(loginProvider.notifier).updateProfile(
                                  
                                  interestId: null,
                                  image: null,
                                  modeid: null,
                                  bio: null,
                                  modename: null,
                                  prompt: null,
                                  qualityId: null,
                                  causeId: null,
                                  kidsId: optionId != null ? [optionId] : null, // wrap int? in a list
                                );

                                Navigator.pop(context, option); // Go back with selected value

                              // Go back with selected value
                            },
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? const LinearGradient(
                                        colors: [
                                          DatingColors.lightpinks,
                                          DatingColors.everqpidColor,
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
                                    color: isSelected ? DatingColors.brown : DatingColors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

            const SizedBox(height: 16),

            // Skip Button
            // Center(
            //   child: TextButton(
            //     onPressed: () => Navigator.pop(context, null),
            //     child: const Text(
            //       'Skip',
            //       style: TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.w500,
            //         color: Colors.grey,
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
