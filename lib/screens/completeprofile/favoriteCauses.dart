import 'package:flutter/material.dart';

class FavoriteCauseScreen extends StatefulWidget {
  final List<Map<String, dynamic>> userCauses;     // Previously selected causes
  final List<Map<String, dynamic>> selectedCauses; // Just selected causes

  const FavoriteCauseScreen({
    Key? key,
    required this.userCauses,
    required this.selectedCauses,
  }) : super(key: key);

  @override
  State<FavoriteCauseScreen> createState() => _FavoriteCauseScreenState();
}

class _FavoriteCauseScreenState extends State<FavoriteCauseScreen> {
  int? selectedCauseId;
  List<Map<String, dynamic>> mergedCauses = [];

  @override
  void initState() {
    super.initState();

    // ✅ Merge unique causes by ID
    final Map<int, Map<String, dynamic>> mergedMap = {};
    for (var cause in [...widget.selectedCauses, ...widget.userCauses]) {
      if (cause['id'] != null) {
        mergedMap[cause['id']] = cause;
      }
    }

    mergedCauses = mergedMap.values.toList();

    // ✅ Preselect user's previously selected favorite
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

          // ✅ List of causes
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

          // ✅ Save Button
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed:
                   () {

                   //API-------------------------------------------------
                  },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Save'),
            ),
          ),

          // ✅ Remove Button (Closes screen and clears favorite)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  selectedCauseId = null;
                });

                // Return null or {} to indicate "removed"
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

  void _saveFavoriteCause() {
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

    final int id = selected['id'];
    final String name = selected['causesAndCommunities'] ?? '';

    // 🚀 TODO: Send this to your backend/API if needed
    print("🎯 Selected Cause -> ID: $id, Name: $name");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Favorite cause '$name' saved!")),
    );

    // ✅ Return selected cause to previous screen
    Navigator.pop(context, selected);
  }
}
