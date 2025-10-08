import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/settings/dark_mode_provider.dart';
import 'package:dating/provider/signupprocessProviders/drinkingProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Add loading state provider
final drinkingScreenLoadingProvider = StateProvider<bool>((ref) => true);

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
      // Set loading to true initially
      ref.read(drinkingScreenLoadingProvider.notifier).state = true;
      
      // Add a small delay to show the loader (optional)
      await Future.delayed(const Duration(milliseconds: 300));
      
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

      // Set loading to false after data is processed
      ref.read(drinkingScreenLoadingProvider.notifier).state = false;
      
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _updateDrinkingSelection(int? optionId, String option) async {
    setState(() {
      // Single choice, replace with new
      selectedOptions = [option];
      selectedDrinkIds = optionId != null ? [optionId] : [];
    });

    try {
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Drinking preference updated successfully!')),
        );
        await Future.delayed(const Duration(milliseconds: 300));
        // Close and return selected options
        Navigator.pop(context, selectedOptions);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update drinking preference: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider);

    final drinkingState = ref.watch(drinkingProvider);
    final isInitialLoading = ref.watch(drinkingScreenLoadingProvider);
    final options = drinkingState.data ?? [];

    return Scaffold(
      backgroundColor: isDarkMode ? DatingColors.black : DatingColors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? DatingColors.black : DatingColors.white,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.close, color: isDarkMode ? DatingColors.lightpinks : DatingColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isInitialLoading 
        ? _buildLoadingState()
        : _buildMainContent(options,isDarkMode),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: DatingColors.everqpidColor,
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Loading drinking preferences...',
            style: TextStyle(
              fontSize: 16,
              color:  DatingColors.lightgrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(List<dynamic> options, bool isDarkMode) {
    return Padding(
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
                child:  Icon(Icons.local_drink, color: isDarkMode ? DatingColors.white : DatingColors.brown),
              ),
              const SizedBox(width: 12),
               Text(
                'Do You Drink',
                style: TextStyle(
                  fontSize: 20,  
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? DatingColors.white : DatingColors.brown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // No options
          if (options.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  "No options available",
                  style: TextStyle(
                    fontSize: 16,
                    color: DatingColors.lightgrey,
                  ),
                ),
              ),
            )

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
                            option,
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

          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text(
              'Skip',
              style: TextStyle(
                color: DatingColors.lightgrey, 
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}