import 'package:dating/provider/loginProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteQualities extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>>
      userQualities; // Previously selected qualities
  final List<Map<String, dynamic>> selectedQualities; // Just selected qualities

  const FavoriteQualities({
    Key? key,
    required this.userQualities,
    required this.selectedQualities,
  }) : super(key: key);

  @override
  ConsumerState<FavoriteQualities> createState() => _FavoriteQualitiesState();
}

class _FavoriteQualitiesState extends ConsumerState<FavoriteQualities> {
  int? selectedQualityId;
  List<Map<String, dynamic>> mergedQualities = [];

  @override
  void initState() {
    super.initState();

    // ✅ Merge unique qualities by ID
    final Map<int, Map<String, dynamic>> uniqueMap = {};
    for (var item in [...widget.selectedQualities, ...widget.userQualities]) {
      if (item['id'] != null) {
        uniqueMap[item['id']] = item;
      }
    }
    mergedQualities = uniqueMap.values.toList();

    // ✅ Optional: Pre-select previously selected favorite
    if (widget.userQualities.isNotEmpty) {
      final previousId = widget.userQualities.first['id'];
      if (uniqueMap.containsKey(previousId)) {
        selectedQualityId = previousId;
      }
    }

    print("✅ Merged qualities: $mergedQualities");
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
              'Which one of your qualities is your favorite?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'It’ll stand out on your profile, and you can change it any time.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),

          // ✅ List of qualities
          Expanded(
            child: ListView.builder(
              itemCount: mergedQualities.length,
              itemBuilder: (context, index) {
                final quality = mergedQualities[index];
                final int? qualityId = quality['id'];
                final String emoji = quality['emoji'] ?? '🌟';
                final String name = quality['name'] ?? '';
                final bool isSelected = selectedQualityId == qualityId;

                return GestureDetector(
                  onTap: () {
                    if (qualityId != null) {
                      setState(() {
                        selectedQualityId = qualityId;
                      });
                    }
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 2,
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
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: isSelected ? Colors.black : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ✅ Save Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: () => _saveFavoriteQuality(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Save'),
            ),
          ),

          // ✅ Remove Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  selectedQualityId = null;
                });
                Navigator.pop(context, null);
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Remove'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveFavoriteQuality() async {
    print('saved button clicked');
    final selected = mergedQualities.firstWhere(
      (q) => q['id'] == selectedQualityId,
      orElse: () => {},
    );
    print('selected.....$mergedQualities');

    // if (selectedQualityId!= null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("No valid quality selected.")),
    //   );
    //   return;
    // }

    final int id = selected['id'];
    final String name = selected['name'] ?? '';

    print("🎯 Selected Quality -> ID: $id, Name: $name");
    // Extract only the IDs
  final List<int> qualityIds = mergedQualities.map((q) => q['id'] as int).toList();
  print('🎯 Sending IDs only: $qualityIds');

    try {
      print('try exicutes....');
      await 
      
      ref.read(loginProvider.notifier).updateProfile(
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

      Navigator.pop(context, selected);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload qualities: $e')),
      );
    }
  }
}
