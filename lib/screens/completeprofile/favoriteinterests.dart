import 'package:flutter/material.dart';

class FavoriteInterests extends StatefulWidget {
  final List<Map<String, dynamic>> userInteres;     // Previously selected
  final List<Map<String, dynamic>> selectedInteres; // Just selected now

  const FavoriteInterests({
    Key? key,
    required this.userInteres,
    required this.selectedInteres,
  }) : super(key: key);

  @override
  State<FavoriteInterests> createState() => _FavoriteInterestsState();
}

class _FavoriteInterestsState extends State<FavoriteInterests> {
  int? selectedCauseId;
  List<Map<String, dynamic>> visibleInterests = [];

  @override
  void initState() {
    super.initState();

    // ✅ Only show selectedInteres in UI
    final Map<int, Map<String, dynamic>> interestMap = {};
    for (var interest in widget.selectedInteres) {
      if (interest['id'] != null) {
        interestMap[interest['id']] = interest;
      }
    }

    visibleInterests = interestMap.values.toList();

    // ✅ Pre-select favorite from userInteres if it exists in selectedInteres
    if (widget.userInteres.isNotEmpty) {
      final previousFavoriteId = widget.userInteres.first['id'];
      if (interestMap.containsKey(previousFavoriteId)) {
        selectedCauseId = previousFavoriteId;
      }
    }

    print("✅ Visible Interests: $visibleInterests");
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

          // ✅ List of new (visible) interests only
          Expanded(
            child: ListView.builder(
              itemCount: visibleInterests.length,
              itemBuilder: (context, index) {
                final item = visibleInterests[index];
                final int? id = item['id'];
                final String emoji = item['emoji'] ?? '🌟';
                final String name = item['interests'] ?? '';
                final bool isSelected = selectedCauseId == id;

                return GestureDetector(
                  onTap: () {
                    if (id != null) {
                      setState(() {
                        selectedCauseId = id;
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

          // ✅ Remove Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton(
              onPressed: () {
                setState(() => selectedCauseId = null);
                Navigator.pop(context, null); // Send null on removal
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

  void _saveFavorite() {
    final selected = visibleInterests.firstWhere(
      (item) => item['id'] == selectedCauseId,
      orElse: () => {},
    );

    if (selected.isEmpty || selected['id'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No valid interest selected.")),
      );
      return;
    }

    final id = selected['id'];
    final name = selected['interests'] ?? '';

    print("🎯 Saving Favorite Interest: ID = $id, Name = $name");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Favorite interest '$name' saved!")),
    );

    Navigator.pop(context, selected); // Send selected interest back
  }
}
