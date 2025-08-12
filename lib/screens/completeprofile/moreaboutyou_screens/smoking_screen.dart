import 'package:dating/provider/loginProvider.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/drinking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateProvider to hold single selected option
final selectedOptionProvider = StateProvider<String?>((ref) => null);

class SmokingScreen extends ConsumerWidget {
  SmokingScreen({super.key});

  final List<String> options = [
    'I Smoke Sometimes',
    'No Idont Smoke',
    'Yes, I Smoke',
    'Im Trying To Quit',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOption = ref.watch(selectedOptionProvider);
    final loginNotifier = ref.read(loginProvider.notifier);

    Future<void> toggleOption(String option) async {
      try {
        // If already selected, deselect; else select the new option
        ref.read(selectedOptionProvider.notifier).update((state) =>
            state == option
                ? null
                : option);

        // Debug print
        print('About to update profile with: $option');

        await loginNotifier.updateProfile(
          causeId: null,
          image: null,
          modeid: null,
          bio: null,
          modename: null,
          prompt: null,
          qualityId: null,
          smoking: option, // sending single string now
        );

        print('Smoking updated successfully');

       if (context.mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Smoking status updated successfully!')),
  );
  await Future.delayed(const Duration(milliseconds: 300)); // give snackbar time to show
  Navigator.pop(context);
}

      } catch (e) {
        print('Detailed error: $e');
        print('Error type: ${e.runtimeType}');

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload smoking status: $e')),
          );
        }
      }
    }

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
            // Header with icon and title
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
            // Options list
            ...options.map((option) {
              final isSelected = selectedOption == option;
              final isFirstOption = option == 'I Smoke Sometimes';

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: GestureDetector(
                  onTap: () => toggleOption(option),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? (isFirstOption
                              ? const LinearGradient(
                                  colors: [Color(0xFFB2D12E), Color(0xFF2B2B2B)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                              : const LinearGradient(
                                  colors: [Color(0xFFB2D12E), Color(0xFF2B2B2B)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ))
                          : null,
                      color: isSelected ? null : Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: isSelected ? Colors.transparent : const Color(0xFFB2D12E),
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
            // Skip button
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DrinkingScreen()),
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
