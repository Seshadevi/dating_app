import 'package:dating/provider/loginProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteCauseScreen extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> selectedCauses;

  const FavoriteCauseScreen({
    Key? key,
    required this.selectedCauses,
  }) : super(key: key);

  @override
  ConsumerState<FavoriteCauseScreen> createState() => _FavoriteCauseScreenState();
}

class _FavoriteCauseScreenState extends ConsumerState<FavoriteCauseScreen> {
  List<Map<String, dynamic>> visibleCauses = [];

  @override
  void initState() {
    super.initState();

    // Deduplicate by ID
    final Map<int, Map<String, dynamic>> causeMap = {};
    for (var item in widget.selectedCauses) {
      if (item['id'] != null) {
        causeMap[item['id']] = item;
      }
    }
    visibleCauses = causeMap.values.toList();

    print("✅ Visible causes: $visibleCauses");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Cause'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Your selected causes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'These causes will be sent to your profile.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              itemCount: visibleCauses.length,
              itemBuilder: (context, index) {
                final cause = visibleCauses[index];
                final String emoji = cause['emoji'] ?? '🌟';
                final String name = cause['causesAndCommunities'] ?? '';

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF869E23),
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
              onPressed: _saveAllCauses,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF869E23),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Save All'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAllCauses() async {
    print('🔘 Save button clicked — sending all causes');

    if (visibleCauses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No causes to save.")),
      );
      return;
    }

    final List<int> causeIds = visibleCauses
        .where((q) => q['id'] != null)
        .map((q) => q['id'] as int)
        .toList();

    print("🎯 Sending Cause IDs: $causeIds");

    try {
      await ref.read(loginProvider.notifier).updateProfile(
        causeId: causeIds,
        image: null,
        modeid: null,
        bio: null,
        modename: null,
        prompt: null,
        qualityId: null,
      );

      print('✅ updateProfile completed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Causes updated successfully!')),
      );

      Navigator.pop(context, visibleCauses);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload causes: $e')),
      );
    }
  }
}
