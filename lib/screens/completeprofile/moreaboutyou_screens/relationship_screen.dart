import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/moreabout/educationprovider.dart';
import 'package:dating/provider/moreabout/relationshipprovider.dart';
import 'package:dating/provider/moreabout/relationshipprovider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RelationshipScreen extends ConsumerStatefulWidget {
  const RelationshipScreen({super.key});

  @override
  ConsumerState<RelationshipScreen> createState() => _RelationshipScreenState();
}

class _RelationshipScreenState extends ConsumerState<RelationshipScreen> {
  int? selectedRelationshipId;
  String? selectedRelationshipName;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      // Fetch religion options
      await ref.read(relationshipProvider.notifier).getRelationship();

      // Get user saved data from loginProvider
      final userState = ref.read(loginProvider);
      final user = userState.data != null && userState.data!.isNotEmpty
          ? userState.data![0].user
          : null;

      final relationship = user?.relationships;

      // If user has at least one religion, preselect it
      if (relationship != null && relationship.isNotEmpty) {
        final first = relationship.first;
        if (first != null) {
          // Adjust based on your model type
          setState(() {
            selectedRelationshipId = first.id; // assuming `id` exists
            selectedRelationshipName = first.relation; // assuming `religion` string exists
          });
        }
      }
    });
  }

  Future<void> _updateExperince(int id, String name) async {
    setState(() {
      selectedRelationshipId = id;
      selectedRelationshipName = name;
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
            relationshipId: id,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name updated successfully!')),
        );
        Navigator.pop(context, selectedRelationshipName);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update relationship: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final relationshiptate = ref.watch(relationshipProvider);
    final options = relationshiptate.data ?? [];

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
                  child: const Icon(Icons.star_border, color: DatingColors.white),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Relationship',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: DatingColors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            /// Religion Options
            Expanded(
              child: relationshiptate.data == null
                  ? const Center(child: CircularProgressIndicator())
                  : options.isEmpty
                      ? const Center(child: Text("No relationship available"))
                      : ListView.builder(
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final relationshipItem = options[index];
                            final relationshipId = relationshipItem.id ?? -1;
                            final relationshipName = relationshipItem.relation ?? '';
                            final isSelected = selectedRelationshipId == relationshipId;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: GestureDetector(
                                onTap: () => _updateExperince(relationshipId, relationshipName),
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
                                      relationshipName,
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
                        ),
            ),

            /// Skip Button
            // Center(
            //   child: TextButton(
            //     onPressed: () => Navigator.pop(context, null),
            //     child: const Text(
            //       'Skip',
            //       style: TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.w500,
            //         color: DatingColors.lightgrey,
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
