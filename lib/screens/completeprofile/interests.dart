import 'package:dating/provider/signupprocessProviders/choosr_foodies_provider.dart';
import 'package:dating/screens/completeprofile/favoriteinterests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating/provider/signupprocessProviders/qualities.dart';

class InterestsScreen extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> usersInterets;

  const InterestsScreen({Key? key, required this.usersInterets}) : super(key: key);

  @override
  ConsumerState<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends ConsumerState<InterestsScreen> {
  final Set<int> selectedIds = {};
  final int maxSelection = 4;
  bool preSelectionDone = false;

  @override
  void initState() {
    super.initState();
    // Load interests from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(interestsProvider.notifier).getInterests();
       final userIds = widget.usersInterets.map((e) => e['id']).whereType<int>();
      setState(() {
        selectedIds.addAll(userIds);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final interestState = ref.watch(interestsProvider);
    final interests = interestState.data ?? [];

    // Preselect user interests only once
    if (!preSelectionDone && interests.isNotEmpty) {
      final userInterestIds = widget.usersInterets.map((e) => e['id']).toSet();
      for (var interest in interests) {
        if (userInterestIds.contains(interest.id)) {
          selectedIds.add(interest.id!);
        }
      }
      preSelectionDone = true;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Interests'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "You can choose ${maxSelection - selectedIds.length} more interests",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            const Text("Self-care", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Expanded(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: interests.map((interest) {
                  final isSelected = selectedIds.contains(interest.id);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedIds.remove(interest.id);
                        } else if (selectedIds.length < maxSelection) {
                          selectedIds.add(interest.id!);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color.fromARGB(255, 218, 217, 215)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            interest.interests ?? '',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            isSelected ? Icons.close : Icons.add,
                            size: 18,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedIds.isNotEmpty
                  ? () {
                      final selectedInteres = interests
                          .where((c) => selectedIds.contains(c.id))
                          .map((c) => {
                                'id': c.id,
                                'interests': c.interests ?? '',
                              })
                          .toList();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FavoriteInterests(
                            // userInteres: widget.usersInterets,
                            selectedInteres: selectedInteres,
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF869E23),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Continue", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
