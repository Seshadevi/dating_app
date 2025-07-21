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
  List<String> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(lookingProvider.notifier).getLookingFor());
  }

  void toggleOption(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.clear(); // Only one selected at a time
        selectedOptions.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lookingState = ref.watch(lookingProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
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
                    color: const Color(0xFF8BC34A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.search, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                const Text(
                  'What Are You Looking For',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Display list
            lookingState.data == null || lookingState.data!.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: lookingState.data!.length,
                      itemBuilder: (context, index) {
                        final option = lookingState.data![index].value ?? '';
                        final isSelected = selectedOptions.contains(option);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: GestureDetector(
                            onTap: () {
                              toggleOption(option);
                              Navigator.pop(context, option);
                            },
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xffB2D12E),
                                          Color(0xFF2B2B2B),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      )
                                    : null,
                                color: isSelected ? null : Colors.white,
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.transparent
                                      : const Color(0xffB2D12E),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected ? Colors.white : Colors.black,
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

            // Skip button
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RelationshipScreen(),
                    ),
                  );
                },
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
