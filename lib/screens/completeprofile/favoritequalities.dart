import 'package:dating/provider/loginProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteQualities extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> selectedQualities;

  const FavoriteQualities({
    Key? key,
    required this.selectedQualities,
  }) : super(key: key);

  @override
  ConsumerState<FavoriteQualities> createState() => _FavoriteQualitiesState();
}

class _FavoriteQualitiesState extends ConsumerState<FavoriteQualities> {
  List<Map<String, dynamic>> visibleQualities = [];

  @override
  void initState() {
    super.initState();

    // ✅ Deduplicate by ID
    final Map<int, Map<String, dynamic>> qualityMap = {};
    for (var quality in widget.selectedQualities) {
      if (quality['id'] != null) {
        qualityMap[quality['id']] = quality;
      }
    }
    visibleQualities = qualityMap.values.toList();

    print("✅ Visible Qualities (Selected Only): $visibleQualities");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Qualities'),
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
              'Your selected qualities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'These will be saved to your profile.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              itemCount: visibleQualities.length,
              itemBuilder: (context, index) {
                final item = visibleQualities[index];
                final String emoji = item['emoji'] ?? '🌟';
                final String name = item['name'] ?? '';

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
              onPressed: _saveAllQualities,
              style: ElevatedButton.styleFrom(
                backgroundColor:const Color(0xFF869E23),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Save All',style:TextStyle(color:Colors.white),),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAllQualities() async {
    print('🔘 Save button clicked — sending all qualities');

    if (visibleQualities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No qualities to save.")),
      );
      return;
    }

    final List<int> qualityIds = visibleQualities
        .where((q) => q['id'] != null)
        .map((q) => q['id'] as int)
        .toList();

    print("🎯 Sending Quality IDs: $qualityIds");

    try {
      await ref.read(loginProvider.notifier).updateProfile(
        qualityId: qualityIds,
        image: null,
        modeid: null,
        bio: null,
        modename: null,
        prompt: null,
      );

      print('✅ updateProfile completed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Qualities updated successfully!')),
      );

      Navigator.pop(context, visibleQualities);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload qualities: $e')),
      );
    }
  }
}
