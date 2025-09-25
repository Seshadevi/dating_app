import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/moreabout/educationprovider.dart';
import 'package:dating/provider/moreabout/experienceprovider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExperienceScreen extends ConsumerStatefulWidget {
  const ExperienceScreen({super.key});

  @override
  ConsumerState<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends ConsumerState<ExperienceScreen> {
  int? selectedExperienceId;
  String? selectedExpereinceName;
  bool isUpdating = false; // Loading state for updates
  bool hasInitialized = false; // Track if initial data load is complete

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      // Fetch experience options from API
      await ref.read(experienceProvider.notifier).getExperience();

      // Get user saved data from loginProvider
      final userState = ref.read(loginProvider);
      final user = userState.data != null && userState.data!.isNotEmpty
          ? userState.data![0].user
          : null;

      final experience = user?.experiences;

      // If user has at least one experience, preselect it
      if (experience != null && experience.isNotEmpty) {
        final first = experience.first;
        if (first != null) {
          if (mounted) {
            setState(() {
              selectedExperienceId = first.id;
              selectedExpereinceName = first.experience;
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load experience data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          hasInitialized = true;
        });
      }
    }
  }

  Future<void> _updateExperince(int id, String name) async {
    setState(() {
      isUpdating = true;
      selectedExperienceId = id; // Update UI immediately for better UX
      selectedExpereinceName = name;
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
            experienceId: id,
          );

      if (mounted) {
        setState(() {
          isUpdating = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$name updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, selectedExpereinceName);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isUpdating = false;
          // Revert selection if update failed
          selectedExperienceId = null;
          selectedExpereinceName = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update experience: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final experienceState = ref.watch(experienceProvider);
    final options = experienceState.data ?? [];
    
    // Check if we're still loading initial data
    final isLoadingInitial = !hasInitialized || experienceState.data == null;

    return Scaffold(
      backgroundColor: DatingColors.white,
      appBar: AppBar(
        backgroundColor: DatingColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: DatingColors.black),
          onPressed: isUpdating ? null : () => Navigator.pop(context), // Disable when updating
        ),
      ),
      body: Stack(
        children: [
          Padding(
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
                        'Do you identify with a experience',
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

                // Experience Options
                Expanded(
                  child: isLoadingInitial
                      ? _buildLoadingSkeleton()
                      : options.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.info_outline, 
                                       size: 48, 
                                       color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text(
                                    "No experiences available",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : _buildExperiencesList(options),
                ),
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

  // Loading skeleton for initial API data load
  Widget _buildLoadingSkeleton() {
    return ListView.builder(
      itemCount: 8, // Show 8 skeleton items
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Center(
              child: Container(
                width: 150 + (index % 3) * 30.0, // Varying widths for realism
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Experiences list when data is loaded
  Widget _buildExperiencesList(List options) {
    return ListView.builder(
      itemCount: options.length,
      itemBuilder: (context, index) {
        final experienceItem = options[index];
        final experienceId = experienceItem.id ?? -1;
        final experienceName = experienceItem.experience ?? '';
        final isSelected = selectedExperienceId == experienceId;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: GestureDetector(
            onTap: isUpdating ? null : () => _updateExperince(experienceId, experienceName),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
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
                    Flexible(
                      child: Text(
                        experienceName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isSelected 
                              ? DatingColors.brown 
                              : DatingColors.everqpidColor,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
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
      },
    );
  }
}