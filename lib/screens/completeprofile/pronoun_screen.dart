import 'package:dating/screens/completeprofile/gender_pronun_screen.dart';
import 'package:flutter/material.dart';

class GenderPronounsScreen extends StatefulWidget {
  const GenderPronounsScreen({super.key});

  @override
  State<GenderPronounsScreen> createState() => _GenderPronounsScreenState();
}

class _GenderPronounsScreenState extends State<GenderPronounsScreen> {
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

  List<String> selectedPronouns = [];

  void togglePronoun(String pronoun) {
    setState(() {
      if (selectedPronouns.contains(pronoun)) {
        selectedPronouns.remove(pronoun);
      } else {
        if (selectedPronouns.length < 3) {
          selectedPronouns.add(pronoun);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Icon(Icons.close, color: Colors.black),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "What Are Your Pronouns?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "Be you on Bumble. Pick your pronouns and we'll add these to your profile right next to your name.",
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
              "Pick Up To 3 Pronouns",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "You can come back and change or remove these at any time. We got you.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allPronouns.map((pronoun) {
                final isSelected = selectedPronouns.contains(pronoun);
                final isDisabled = selectedPronouns.length >= 3 && !isSelected;
                return ChoiceChip(
                  label: Text(pronoun),
                  selected: isSelected,
                  onSelected: isDisabled
                      ? null
                      : (_) {
                          togglePronoun(pronoun);
                        },
                  selectedColor: Colors.black,
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
                  const Text("Show On Your Profile As :",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(
                    selectedPronouns.isEmpty
                        ? "Pick Your Pronouns To Preview"
                        : selectedPronouns.join(", "),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () {
                  // handle contact support
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GenderPronounsFeedbackScreen(),
                    ),
                  );

                },
                child: const Text(
                  "Pronouns Not Listed? Contact Support",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: selectedPronouns.isEmpty
              ? null
              : () {
                  // handle save
                  print("Selected Pronouns: $selectedPronouns");
                },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.black,
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
