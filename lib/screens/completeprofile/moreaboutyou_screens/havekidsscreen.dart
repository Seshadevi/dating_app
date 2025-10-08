import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/settings/dark_mode_provider.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/new_to_area_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Havekidsscreen extends ConsumerStatefulWidget {
  const Havekidsscreen({super.key});

  @override
  ConsumerState<Havekidsscreen> createState() => _HavekidsscreenState();
}

class _HavekidsscreenState extends ConsumerState<Havekidsscreen> {
  String? selectedOption;
  bool isLoading = true; // Loading state for initial data fetch
  bool isUpdating = false; // Loading state for updating selection

  final List<String> options = [
    'Have kids',
    "Don't have kids",
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  // Separate method for loading initial data
  Future<void> _loadInitialData() async {
    try {
      // Add artificial delay to show loading (remove in production if not needed)
      await Future.delayed(const Duration(milliseconds: 500));
      
      final userState = ref.read(loginProvider);
      final user = userState.data != null && userState.data!.isNotEmpty
          ? userState.data![0].user
          : null;

      if (mounted) {
        setState(() {
          if (user != null && 
              user.haveKids != null && 
              user.haveKids!.isNotEmpty) {
            selectedOption = user.haveKids; // Match exact string
          }
          isLoading = false; // Stop loading
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data: $e')),
        );
      }
    }
  }

  Future<void> selectOption(String option) async {
    setState(() {
      isUpdating = true; // Show updating state
      selectedOption = option; // Update UI immediately for better UX
    });

    try {
      await ref.read(loginProvider.notifier).updateProfile(
            image: null,
            modeid: null,
            bio: null,
            modename: null,
            prompt: null,
            qualityId: null,
            jobId: null,
            haveKids: option,
          );

      if (!mounted) return;
      
      setState(() {
        isUpdating = false; // Stop updating state
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kids preference updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, selectedOption);
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        isUpdating = false; // Stop updating state
        // Revert selection if update failed
        selectedOption = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update kids preference: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider);

    return Scaffold(
      backgroundColor: isDarkMode? DatingColors.black : DatingColors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode? DatingColors.black : DatingColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: DatingColors.everqpidColor, size: 24),
          onPressed: isUpdating ? null : () => Navigator.pop(context), // Disable when updating
        ),
      ),
      body: Stack(
        children: [
          Padding(
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
                        Icons.child_care, // Changed to kids-related icon
                        color: DatingColors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                     Text(
                      'Do You Have Kids?', // Fixed title to match purpose
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode? DatingColors.white : DatingColors.brown,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                // Show loading or options
                if (isLoading)
                  _buildLoadingSkeleton()
                else
                  _buildOptionsList(),
                
                const Spacer(),
              ],
            ),
          ),

          // Overlay loading indicator when updating
          if (isUpdating)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Updating...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Loading skeleton for initial load
  Widget _buildLoadingSkeleton() {
    return Column(
      children: List.generate(2, (index) { // Only 2 options for kids
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Center(
              child: Container(
                width: index == 0 ? 100 : 130, // Different widths for "Have kids" vs "Don't have kids"
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // Options list when data is loaded
  Widget _buildOptionsList() {
    return Column(
      children: options.map((option) {
        final isSelected = selectedOption == option;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: GestureDetector(
            onTap: isUpdating ? null : () => selectOption(option), // Disable when updating
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
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
                color: isSelected ? DatingColors.white : DatingColors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: isSelected
                      ? DatingColors.lightgrey
                      : DatingColors.everqpidColor,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: DatingColors.everqpidColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      option,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isSelected 
                            ? DatingColors.brown 
                            : DatingColors.everqpidColor,
                      ),
                    ),
                    if (isSelected && isUpdating)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              DatingColors.brown,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}