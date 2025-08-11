import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/signupprocessProviders/drinkingProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrinkingScreen extends ConsumerStatefulWidget {
  const DrinkingScreen({super.key});

  @override
  ConsumerState<DrinkingScreen> createState() => _DrinkingScreenState();
}

class _DrinkingScreenState extends ConsumerState<DrinkingScreen> {
  List<String> selectedOptions = [];
  List<int> selectedDrinkIds = [];

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      // Load available drink options
      await ref.read(drinkingProvider.notifier).getdrinking();

      // Get logged in user data
      final user = ref.read(loginProvider).data?.first.user;

      if (user != null && user.drinking != null && user.drinking!.isNotEmpty) {
        // Extract preferences for preselection
        selectedOptions = user.drinking!
            .map((drink) => drink.preference ?? '')
            .where((pref) => pref.isNotEmpty)
            .toList();

        // Extract IDs for updating later
        selectedDrinkIds = user.drinking!
            .map((drink) => drink.id)
            .whereType<int>()
            .toList();
      }

      setState(() {});
    });
  }

  Future<void> _updateDrinkingSelection(int? optionId, String option) async {
    setState(() {
      // Single choice, replace with new
      selectedOptions = [option];
      selectedDrinkIds = optionId != null ? [optionId] : [];
    });

    // Send update to API
    await ref.read(loginProvider.notifier).updateProfile(
      interestId: null,
      image: null,
      modeid: null,
      bio: null,
      modename: null,
      prompt: null,
      qualityId: null,
      causeId: null,
      drinkingId: selectedDrinkIds.isNotEmpty ? selectedDrinkIds : null,
    );

    // Close and return selected options
    Navigator.pop(context, selectedOptions);
  }

  @override
  Widget build(BuildContext context) {
    final drinkingState = ref.watch(drinkingProvider);
    final options = drinkingState.data ?? [];

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
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB2D12E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.local_drink, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Do You Drink',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Loading state
            if (drinkingState.data == null)
              const Center(child: CircularProgressIndicator())

            // No options
            else if (options.isEmpty)
              const Center(child: Text("No options available"))

            // List of options
            else
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index].preference ?? '';
                    final isSelected = selectedOptions.contains(option);
                    final optionId = options[index].id;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: GestureDetector(
                        onTap: () => _updateDrinkingSelection(optionId, option),
                        child: Container(
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
                  },
                ),
              ),

            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
