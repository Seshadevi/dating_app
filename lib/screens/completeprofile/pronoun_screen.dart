import 'package:dating/provider/loginProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GenderPronounsScreen extends ConsumerStatefulWidget {
  const GenderPronounsScreen({super.key});

  @override
  ConsumerState<GenderPronounsScreen> createState() => _GenderPronounsScreenState();
}

class _GenderPronounsScreenState extends ConsumerState<GenderPronounsScreen> {
  final List<String> allPronouns = [
    'She/Her',
    'He/Him',
    'They/Them',
    'Ze/Zir',
    'Xe/Xim',
    'Co/Co',
    'Ey/Em',
    'Ve/Ver',
    'Per/Per',
  ];

  String? selectedPronoun; // Only one pronoun now

  void selectPronoun(String pronoun) {
    setState(() {
      selectedPronoun = pronoun;
    });
  }

  Future<void> updatePronounToApi() async {
    if (selectedPronoun == null) return;

    // Example API call (replace with your own)
    try {
      await ref.read(loginProvider.notifier).updateProfile(
            pronoun: selectedPronoun,
            
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('pronoun updated successfully')),
      );

      Navigator.pop(context,selectedPronoun); // Go back after save
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update pronoun: $e')),
      );
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Gender On Bumble",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What Are Your Pronouns?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "Pick pronoun and we'll add it to your profile.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () {},
                child: const Text("Why Pronouns Matter"),
              ),
              const Divider(thickness: 1),
              const SizedBox(height: 8),
              const Text(
                "Pick  Pronoun",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: allPronouns.map((pronoun) {
                  final isSelected = selectedPronoun == pronoun;
                  return ChoiceChip(
                    label: Text(pronoun),
                    selected: isSelected,
                    onSelected: (_) {
                      selectPronoun(pronoun);
                    },
                    selectedColor: const Color.fromARGB(255, 15, 104, 5),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    backgroundColor: Colors.grey[200],
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Show On Your Profile As:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(
                      selectedPronoun ?? "Pick Your Pronoun To Preview",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: selectedPronoun == null ? null : updatePronounToApi,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color.fromARGB(255, 15, 104, 5),
            disabledBackgroundColor: Colors.grey,
          ),
          child: const Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
