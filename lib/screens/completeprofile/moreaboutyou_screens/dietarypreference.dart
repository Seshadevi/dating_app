import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/settings/dark_mode_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedOptionProvider = StateProvider<String?>((ref) => null);
final isLoadingProvider = StateProvider<bool>((ref) => true); // Add loading state

class Dietarypreference extends ConsumerStatefulWidget {
  const Dietarypreference({super.key});

  @override
  ConsumerState<Dietarypreference> createState() => _DietarypreferenceState();
}

class _DietarypreferenceState extends ConsumerState<Dietarypreference> {
  final List<String> options = [
     "Vegan",
     "Vegetarian",
     "Pescatarian",
     "Non-Vegan",
     "Other",
  ];

  @override
  void initState() {
    super.initState();

    // Initialize loading state
    Future.microtask(() async {
      // Set loading to true
      ref.read(isLoadingProvider.notifier).state = true;
      
      // Add a small delay to show the loader (optional)
      await Future.delayed(const Duration(milliseconds: 500));
      
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
      
      // Set loading to false after data is processed
      ref.read(isLoadingProvider.notifier).state = false;
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
        diet: option,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dietary preference updated successfully!')),
        );
        await Future.delayed(const Duration(milliseconds: 300));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update dietary preference: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider);

    final selectedOption = ref.watch(selectedOptionProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      backgroundColor: isDarkMode ? DatingColors.black : DatingColors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? DatingColors.black : DatingColors.white,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.close, color: isDarkMode ? DatingColors.white : DatingColors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading 
        ? _buildLoadingState()
        : _buildMainContent(selectedOption,isDarkMode),
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
            'Loading dietary preferences...',
            style: TextStyle(
              fontSize: 16,
              color: DatingColors.lightgrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(String? selectedOption,bool isDarkMode) {
    return Padding(
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
                  color: DatingColors.everqpidColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.restaurant_outlined,
                  color:  DatingColors.brown,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
               Text(
                'Dietary Preference',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode? DatingColors.white : DatingColors.brown,
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
          }).toList(),
        ],
      ),
    );
  }
}