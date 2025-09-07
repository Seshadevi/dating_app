import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/moreabout/educationprovider.dart';
import 'package:dating/provider/moreabout/experienceprovider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExperienceScreen extends ConsumerStatefulWidget {
  const ExperienceScreen({super.key});

  @override
  ConsumerState<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends ConsumerState<ExperienceScreen> {
  int? selectedExperienceId;
  String? selectedExpereinceName;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      // Fetch religion options
      await ref.read(experienceProvider.notifier).getExperience();

      // Get user saved data from loginProvider
      final userState = ref.read(loginProvider);
      final user = userState.data != null && userState.data!.isNotEmpty
          ? userState.data![0].user
          : null;

      final experience = user?.experiences;

      // If user has at least one religion, preselect it
      if (experience != null && experience.isNotEmpty) {
        final first = experience.first;
        if (first != null) {
          // Adjust based on your model type
          setState(() {
            selectedExperienceId = first.id; // assuming `id` exists
            selectedExpereinceName = first.experience; // assuming `religion` string exists
          });
        }
      }
    });
  }

  Future<void> _updateExperince(int id, String name) async {
    setState(() {
      selectedExperienceId = id;
      selectedExpereinceName = name;
    });

    try {
      await ref.read(loginProvider.notifier).updateProfile(
            causeId: null,
            image: null,
            modeid: null,
            bio: null,
            modename: null,
            prompt: null,
            qualityId: null,
            experienceId: id,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name updated successfully!')),
        );
        Navigator.pop(context, selectedExpereinceName);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update religion: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final experiencetate = ref.watch(experienceProvider);
    final options = experiencetate.data ?? [];

    return Scaffold(
      backgroundColor: DatingColors.white,
      appBar: AppBar(
        backgroundColor: DatingColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: DatingColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
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
                  child: const Icon(Icons.star_border, color: DatingColors.brown),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Do you identify with a expereince',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: DatingColors.brown,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            /// Religion Options
            Expanded(
              child: experiencetate.data == null
                  ? const Center(child: CircularProgressIndicator())
                  : options.isEmpty
                      ? const Center(child: Text("No experience available"))
                      : ListView.builder(
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final experienceItem = options[index];
                            final experienceId = experienceItem.id ?? -1;
                            final experienceName = experienceItem.experience ?? '';
                            final isSelected = selectedExperienceId == experienceId;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: GestureDetector(
                                onTap: () => _updateExperince(experienceId, experienceName),
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? const LinearGradient(
                                            colors: [DatingColors.lightpinks, DatingColors.everqpidColor],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          )
                                        : null,
                                    color: isSelected ? DatingColors.brown : DatingColors.white,
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
                                      experienceName,
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
                          },
                        ),
            ),

            /// Skip Button
            // Center(
            //   child: TextButton(
            //     onPressed: () => Navigator.pop(context, null),
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
            // const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
