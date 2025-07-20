import 'package:dating/provider/loginProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteCauseScreen extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> userCauses;
  final List<Map<String, dynamic>> selectedCauses;

  const FavoriteCauseScreen({
    Key? key,
    required this.userCauses,
    required this.selectedCauses,
  }) : super(key: key);

  @override
  ConsumerState<FavoriteCauseScreen> createState() => _FavoriteCauseScreenState();
}

class _FavoriteCauseScreenState extends ConsumerState<FavoriteCauseScreen> {
  int? selectedCauseId;
  List<Map<String, dynamic>> mergedCauses = [];

  @override
  void initState() {
    super.initState();

    // Merge user + selected causes by ID (remove duplicates)
    final Map<int, Map<String, dynamic>> mergedMap = {};
    for (var cause in [...widget.selectedCauses, ...widget.userCauses]) {
      if (cause['id'] != null) {
        mergedMap[cause['id']] = cause;
      }
    }

    mergedCauses = mergedMap.values.toList();

    // Pre-select previously chosen cause
    if (widget.userCauses.isNotEmpty) {
      selectedCauseId = widget.userCauses.first['id'];
    }

    print("✅ Merged Causes: $mergedCauses");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite interest'),
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
              'Which one of your interests is your favorite?',
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

          Expanded(
            child: ListView.builder(
              itemCount: mergedCauses.length,
              itemBuilder: (context, index) {
                final cause = mergedCauses[index];
                final int? causeId = cause['id'];
                final String emoji = cause['emoji'] ?? '🌟';
                final String name = cause['causesAndCommunities'] ?? '';
                final bool isSelected = selectedCauseId == causeId;

                return GestureDetector(
                  onTap: () {
                    if (causeId != null) {
                      setState(() {
                        selectedCauseId = causeId;
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: () async {
                final List<int> causesIds = mergedCauses .map((q) => q['id'] as int).toList();
                        print('🎯 Sending IDs only: $causesIds ');
                try {
                  await ref.read(loginProvider.notifier).updateProfile(causeId: causesIds,
                                                                                  image: null, 
                                                                                  modeid: null,
                                                                                  bio: null, 
                                                                                  modename:null, 
                                                                                  prompt:null,
                                                                                  qualityId: null);
                  print('Cause updated');

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cause updated successfully!')),
                  );

                  // Return updated cause
                  _returnSelectedCause();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to upload cause: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Save'),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  selectedCauseId = null;
                });

                Navigator.pop(context, null); // Remove selection
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

  void _returnSelectedCause() {
    final selected = mergedCauses.firstWhere(
      (c) => c['id'] == selectedCauseId,
      orElse: () => {},
    );

    if (selected.isEmpty || selected['id'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No valid cause selected.")),
      );
      return;
    }

    Navigator.pop(context, selected); // Pass data back
  }
}
