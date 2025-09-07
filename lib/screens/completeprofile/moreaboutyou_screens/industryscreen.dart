import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/moreabout/industryprovider.dart';
import 'package:dating/provider/signupprocessProviders/religionProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Industryscreen extends ConsumerStatefulWidget {
  const Industryscreen({super.key});

  @override
  ConsumerState<Industryscreen> createState() => _IndustryscreenState();
}

class _IndustryscreenState extends ConsumerState<Industryscreen> {
  int? selectedindustryId;
  String? selectedIndustryName;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      // Fetch religion options
      await ref.read(industryprovider.notifier).getIndustry();

      // Get user saved data from loginProvider
      final userState = ref.read(loginProvider);
      final user = userState.data != null && userState.data!.isNotEmpty
          ? userState.data![0].user
          : null;

      final industry = user?.industries;

      // If user has at least one religion, preselect it
      if (industry != null && industry.isNotEmpty) {
        final first = industry.first;
        if (first != null) {
          // Adjust based on your model type
          setState(() {
            selectedindustryId = first.id; // assuming `id` exists
            selectedIndustryName = first.industrie; // assuming `religion` string exists
          });
        }
      }
    });
  }

  Future<void> _updateReligion(int id, String name) async {
    setState(() {
      selectedindustryId = id;
      selectedIndustryName = name;
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
            industryId: id,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name updated successfully!')),
        );
        Navigator.pop(context, selectedIndustryName);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update industry: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final industrytate = ref.watch(industryprovider);
    final options = industrytate.data ?? [];

    return Scaffold(
      backgroundColor: DatingColors.white,
      appBar: AppBar(
        backgroundColor: DatingColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: DatingColors.everqpidColor),
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
                    'industry',
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
              child: industrytate.data == null
                  ? const Center(child: CircularProgressIndicator())
                  : options.isEmpty
                      ? const Center(child: Text("No industry available"))
                      : ListView.builder(
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final industryItem = options[index];
                            final industryId = industryItem.id ?? -1;
                            final industryName = industryItem.industry ?? '';
                            final isSelected = selectedindustryId == industryId;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: GestureDetector(
                                onTap: () => _updateReligion(industryId, industryName),
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
                                    color: isSelected ? DatingColors.everqpidColor: DatingColors.white,
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
                                      industryName,
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
