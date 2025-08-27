import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeightScreen extends ConsumerStatefulWidget {
  const HeightScreen({super.key});

  @override
  ConsumerState<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends ConsumerState<HeightScreen> {
  int? selectedHeight;

  // Static list of heights (you can adjust range as needed)
  final List<int> heightOptions = List.generate(40, (i) => 150 + i); // 150–189 cm

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      // Preselect from user profile if available
      final user = ref.read(loginProvider).data?.first.user;

      if (user != null && user.height != null) {
        selectedHeight = user.height;
      }

      setState(() {});
    });
  }

  void selectHeight(int height) {
    setState(() {
      selectedHeight = height;
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
          icon: const Icon(Icons.close, color: DatingColors.black),
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
                    color: DatingColors.darkGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.height, color: DatingColors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Select Your Height',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            Expanded(
              child: ListView.builder(
                itemCount: heightOptions.length,
                itemBuilder: (context, index) {
                  final option = heightOptions[index];
                  final isSelected = selectedHeight == option;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GestureDetector(
                      onTap: () async {
                        selectHeight(option);

                        // Update profile with selected height (int)
                        await ref.read(loginProvider.notifier).updateProfile(
                              interestId: null,
                              image: null,
                              modeid: null,
                              bio: null,
                              modename: null,
                              prompt: null,
                              qualityId: null,
                              causeId: null,
                              kidsId: null,
                              height: option, // pass int height
                            );

                        Navigator.pop(context, option); // Return selected height
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? const LinearGradient(
                                  colors: [
                                    DatingColors.primaryGreen,
                                    DatingColors.black,
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
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
                            "$option cm",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? DatingColors.white
                                  : DatingColors.black,
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
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
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
