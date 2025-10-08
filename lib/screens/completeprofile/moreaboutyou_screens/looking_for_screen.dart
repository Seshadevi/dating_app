import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/settings/dark_mode_provider.dart';
import 'package:dating/provider/signupprocessProviders/lookingProvider.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/relationship_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LookingForScreen extends ConsumerStatefulWidget {
  const LookingForScreen({super.key});

  @override
  ConsumerState<LookingForScreen> createState() => _LookingForScreenState();
}

class _LookingForScreenState extends ConsumerState<LookingForScreen> {
  List<int> selectedOptionIds = []; // store selected option IDs

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(lookingProvider.notifier).getLookingForUser();

      final userState = ref.read(loginProvider);
      final user = userState.data != null && userState.data!.isNotEmpty
          ? userState.data![0].user
          : null;

      final lookingForList = user?.lookingFor;
      if (lookingForList != null && lookingForList.isNotEmpty) {
        selectedOptionIds = lookingForList
            .map((item) => item.id as int) // assuming id is int
            .toList();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider);

    final lookingState = ref.watch(lookingProvider);
    final options = lookingState.data ?? [];

    return Scaffold(
      backgroundColor: isDarkMode ? DatingColors.black : DatingColors.white,
      appBar: AppBar(
        backgroundColor:isDarkMode ? DatingColors.black : DatingColors.white,
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
                  child: const Icon(Icons.search, color: DatingColors.brown),
                ),
                const SizedBox(width: 12),
                 Expanded(
                  child: Text(
                    'What Are You Looking For',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? DatingColors.white : DatingColors.brown,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            /// Options List
            Expanded(
              child: lookingState.data == null
                  ? const Center(child: CircularProgressIndicator())
                  : options.isEmpty
                      ? Center(child: Text("No options available",style: TextStyle(color: isDarkMode ? DatingColors.white : DatingColors.brown),))
                      : ListView.builder(
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options[index];
                            final optionId = option.id as int;
                            final optionValue =
                                option.value?.toString().trim() ?? '';
                            final isSelected =
                                selectedOptionIds.contains(optionId);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedOptionIds.remove(optionId);
                                    } else {
                                      if (selectedOptionIds.length < 2) {
                                        selectedOptionIds.add(optionId);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'You can select up to 2 options only')),
                                        );
                                      }
                                    }
                                  });
                                },
                                child: Container(
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
                                    color: isSelected ? DatingColors.brown: DatingColors.white,
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
                                      optionValue,
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
                          },
                        ),
            ),

            /// Update Button (only when selection is not empty)
            if (selectedOptionIds.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DatingColors.everqpidColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async {
                    await ref.read(loginProvider.notifier).updateProfile(
                          lookingfor: selectedOptionIds,
                          interestId: null,
                          image: null,
                          modeid: null,
                          bio: null,
                          modename: null,
                          prompt: null,
                          qualityId: null,
                          causeId: null,
                        );

                    // if (context.mounted) {
                    //   ref.invalidate(loginProvider); // refresh profile data
                      Navigator.pop(context);
                    // }
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: DatingColors.brown,
                    ),
                  ),
                ),
              ),

            /// Skip Button
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RelationshipScreen()),
                  );
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: DatingColors.surfaceGrey,
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
