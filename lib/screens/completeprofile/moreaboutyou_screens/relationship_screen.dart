import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/moreabout/relationshipprovider.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/kids_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating/provider/loader.dart';
import 'package:dating/model/moreabout/realtionshipsmodel.dart';
// Import your relationship provider here
// import 'package:dating/provider/relationship_provider.dart';

class RelationshipScreen extends ConsumerStatefulWidget {
  const RelationshipScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RelationshipScreen> createState() => _RelationshipScreenState();
}

class _RelationshipScreenState extends ConsumerState<RelationshipScreen> {
  List<String> selectedOptions = [];
  List<Data> relationshipOptions = [];

  @override
  void initState() {
    super.initState();
    // Fetch relationship options when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(relationshipProvider.notifier).getRelationship();
    });
  }

  void toggleOption(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final relationshipState = ref.watch(relationshipProvider);
    final isLoading = ref.watch(loadingProvider);

    // Update local options when provider data changes
    if (relationshipState.data != null && relationshipState.data!.isNotEmpty) {
      relationshipOptions = relationshipState.data!;
    }

    return Scaffold(
      backgroundColor: DatingColors.white,
      appBar: AppBar(
        backgroundColor: DatingColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: DatingColors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Header with icon and title
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: DatingColors.darkGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: DatingColors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'What Is Your Relationship Status',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: DatingColors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            
            // Loading or Options list
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(DatingColors.darkGreen),
                      ),
                    )
                  : relationshipOptions.isEmpty
                      ? _buildEmptyState()
                      : _buildOptionsList(),
            ),
            
            // Skip button
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const HaveKidsScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: DatingColors.lightgrey,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Options Available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please try again later',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ref.read(relationshipProvider.notifier).getRelationship();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: DatingColors.darkGreen,
              foregroundColor: DatingColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsList() {
    return ListView.builder(
      itemCount: relationshipOptions.length,
      itemBuilder: (context, index) {
        final relationshipData = relationshipOptions[index];
        final option = relationshipData.relation ?? 'Unknown';
        final isSelected = selectedOptions.contains(option);
        final isFirstOption = index == 0;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: GestureDetector(
            onTap: () => toggleOption(option),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? (isFirstOption 
                        ? const LinearGradient(
                            colors: [DatingColors.darkGreen, DatingColors.black],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : const LinearGradient(
                            colors: [DatingColors.primaryGreen, DatingColors.black],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ))
                    : null,
                color: isSelected ? null : DatingColors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: isSelected 
                      ? DatingColors.black
                      : DatingColors.darkGreen,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? DatingColors.white : DatingColors.black,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}