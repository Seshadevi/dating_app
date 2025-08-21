import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteInterests extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> selectedInteres;

  const FavoriteInterests({
    Key? key,
    required this.selectedInteres,
  }) : super(key: key);

  @override
  ConsumerState<FavoriteInterests> createState() => _FavoriteInterestsState();
}

class _FavoriteInterestsState extends ConsumerState<FavoriteInterests> {
  List<Map<String, dynamic>> visibleInterests = [];

  @override
  void initState() {
    super.initState();

    // ✅ Deduplicate by ID
    final Map<int, Map<String, dynamic>> interestMap = {};
    for (var interest in widget.selectedInteres) {
      if (interest['id'] != null) {
        interestMap[interest['id']] = interest;
      }
    }
    visibleInterests = interestMap.values.toList();

    print("✅ Visible Interests (Selected Only): $visibleInterests");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite interest'),
        backgroundColor:DatingColors.white,
        foregroundColor:DatingColors.black,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Your selected interests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'These will be saved to your profile.',
              style: TextStyle(fontSize: 14, color: DatingColors.lightgrey),
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              itemCount: visibleInterests.length,
              itemBuilder: (context, index) {
                final item = visibleInterests[index];
                final String emoji = item['emoji'] ?? '🌟';
                final String name = item['interests'] ?? '';

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: DatingColors.surfaceGrey,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: DatingColors.darkGreen,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: _saveAllInterests,
              style: ElevatedButton.styleFrom(
                backgroundColor:DatingColors.darkGreen,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Save All',style:TextStyle(color:DatingColors.white),),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAllInterests() async {
    print('🔘 Save button clicked — sending all interests');

    if (visibleInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No interests to save.")),
      );
      return;
    }

    final List<int> interestIds = visibleInterests
        .where((q) => q['id'] != null)
        .map((q) => q['id'] as int)
        .toList();

    print("🎯 Sending Interest IDs: $interestIds");

    try {
      await ref.read(loginProvider.notifier).updateProfile(
        interestId: interestIds,
        image: null,
        modeid: null,
        bio: null,
        modename: null,
        prompt: null,
        qualityId: null,
      );

      print('✅ updateProfile completed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Interests updated successfully!')),
      );

      Navigator.pop(context, visibleInterests);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload interests: $e')),
      );
    }
  }
}
