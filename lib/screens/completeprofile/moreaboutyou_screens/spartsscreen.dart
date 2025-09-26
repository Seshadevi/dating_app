import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';

import 'package:dating/provider/moreabout/relationshipprovider.dart';
import 'package:dating/provider/moreabout/sportsprovider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SportsScreen extends ConsumerStatefulWidget {
  const SportsScreen({super.key});

  @override
  ConsumerState<SportsScreen> createState() => _SportsScreenState();
}

class _SportsScreenState extends ConsumerState<SportsScreen> {
  int? selectedSportsId;
  String? selectedSportsName;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      // Fetch religion options
      await ref.read(sportsprovider.notifier).getSports();

      // Get user saved data from loginProvider
      final userState = ref.read(loginProvider);
      final user = userState.data != null && userState.data!.isNotEmpty
          ? userState.data![0].user
          : null;

      final sports = user?.sports;

      // If user has at least one religion, preselect it
      if (sports != null && sports.isNotEmpty) {
        final first = sports.first;
        if (first != null) {
          // Adjust based on your model type
          setState(() {
            selectedSportsId = first.id; // assuming `id` exists
            selectedSportsName = first.title; // assuming `religion` string exists
          });
        }
      }
    });
  }

  Future<void> _updateExperince(int id, String name) async {
    setState(() {
      selectedSportsId = id;
      selectedSportsName = name;
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
            sportsId: id,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name updated successfully!')),
        );
        Navigator.pop(context, selectedSportsName);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update sports: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sportstate = ref.watch(sportsprovider);
    final options = sportstate.data ?? [];

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
                  child: const Icon(Icons.star_border, color: DatingColors.white),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Sports',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: DatingColors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            /// Religion Options
            Expanded(
              child: sportstate.data == null
                  ? const Center(child: CircularProgressIndicator())
                  : options.isEmpty
                      ? const Center(child: Text("No Sports available"))
                      : ListView.builder(
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final sportsItem = options[index];
                            final sportsId = sportsItem.id ?? -1;
                            final sportsName = sportsItem.sportsTitle ?? '';
                            final isSelected = selectedSportsId == sportsId;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: GestureDetector(
                                onTap: () => _updateExperince(sportsId, sportsName),
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
                                     sportsName,
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
