import 'package:dating/provider/loginProvider.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/drinking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedOptionProvider = StateProvider<String?>((ref) => null);

class SmokingScreen extends ConsumerStatefulWidget {
  const SmokingScreen({super.key});

  @override
  ConsumerState<SmokingScreen> createState() => _SmokingScreenState();
}

class _SmokingScreenState extends ConsumerState<SmokingScreen> {
  final List<String> options = [
    'I Smoke Sometimes',
    'No I don\'t Smoke',
    'Yes, I Smoke',
    'I\'m Trying To Quit',
  ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final user = ref.read(loginProvider).data?.first.user;

      if (user != null && user.smoking != null) {
        String? preselected;

        // Case 1: smoking stored as Map with a name field
        if (user.smoking is Map && (user.smoking as Map).containsKey('name')) {
          preselected = user.smoking?.toString();
        }
        // Case 2: smoking is already a String
        else if (user.smoking is String) {
          preselected = user.smoking;
        }

        if (preselected != null &&
            preselected.isNotEmpty &&
            options.contains(preselected)) {
          ref.read(selectedOptionProvider.notifier).state = preselected;
        }
      }
    });
  }

  Future<void> toggleOption(String option) async {
    final loginNotifier = ref.read(loginProvider.notifier);

    try {
      // Select only one option at a time
      ref.read(selectedOptionProvider.notifier).state = option;

      // Update API
      await loginNotifier.updateProfile(
        causeId: null,
        image: null,
        modeid: null,
        bio: null,
        modename: null,
        prompt: null,
        qualityId: null,
        smoking: option,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Smoking status updated successfully!')),
        );
        await Future.delayed(const Duration(milliseconds: 300));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update smoking status: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedOption = ref.watch(selectedOptionProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 24),
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
                    color: const Color(0xFFB2D12E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.smoke_free_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Do You Smoke',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
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
                  onTap: () => toggleOption(option),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [Color(0xFFB2D12E), Color(0xFF2B2B2B)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : null,
                      color: isSelected ? null : Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : const Color(0xFFB2D12E),
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
            }).toList(),
            const Spacer(),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DrinkingScreen(),
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
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
