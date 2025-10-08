import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/settings/dark_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GenderPronounsScreen extends ConsumerStatefulWidget {
  const GenderPronounsScreen({super.key});

  @override
  ConsumerState<GenderPronounsScreen> createState() =>
      _GenderPronounsScreenState();
}

class _GenderPronounsScreenState
    extends ConsumerState<GenderPronounsScreen> {
  final List<String> allPronouns = [
    'She/Her',
    'He/Him',
    'They/Them',
    // 'Ze/Zir',
    // 'Xe/Xim',
    // 'Co/Co',
    // 'Ey/Em',
    // 'Ve/Ver',
    // 'Per/Per',
  ];

  String? selectedPronoun;

  @override
  void initState() {
    super.initState();

    // Pre-select user's pronoun if available
    Future.microtask(() {
      final user = ref.read(loginProvider).data?.first.user;
      if (user?.pronouns != null && user!.pronouns!.isNotEmpty) {
        setState(() {
          selectedPronoun = user.pronouns;
        });
      }
    });
  }

  void selectPronoun(String pronoun) {
    setState(() {
      selectedPronoun = pronoun;
    });
  }

  Future<void> updatePronounToApi() async {
    if (selectedPronoun == null) return;

    try {
      await ref.read(loginProvider.notifier).updateProfile(
            pronoun: selectedPronoun,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pronoun updated successfully')),
      );

      Navigator.pop(context, selectedPronoun);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update pronoun: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider);

    return Scaffold(
      backgroundColor: isDarkMode? DatingColors.black : DatingColors.white,
      appBar: AppBar(
        
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios_new, color: isDarkMode? DatingColors.white : DatingColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Select Your Pronoun",
          style: TextStyle(color: DatingColors.everqpidColor),
        ),
        backgroundColor: isDarkMode? DatingColors.black : DatingColors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                "What Are Your Pronouns?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: isDarkMode? DatingColors.white : DatingColors.black),
              ),
              const SizedBox(height: 6),
             Text(
                "Pick a pronoun and we'll add it to your profile.",
                style: TextStyle(fontSize: 14,color: isDarkMode? DatingColors.white : DatingColors.black ),
              ),
              const SizedBox(height: 4),
              // TextButton(
              //   onPressed: () {},
              //   child: const Text("Why Pronouns Matter"),
              // ),
              const Divider(thickness: 1),
              const SizedBox(height: 8),
               Text(
                "Pick Pronoun",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color:  isDarkMode? DatingColors.white : DatingColors.black),
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
                    onSelected: (_) => selectPronoun(pronoun),
                    selectedColor: DatingColors.everqpidColor,
                    labelStyle: TextStyle(
                      color: isSelected ? DatingColors.brown : DatingColors.black,
                    ),
                    backgroundColor: DatingColors.surfaceGrey,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: DatingColors.everqpidColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Text("Show On Your Profile As:",
                        style: TextStyle(fontWeight: FontWeight.bold,color: isDarkMode? DatingColors.white : DatingColors.black)),
                    const SizedBox(height: 6),
                    Text(
                      selectedPronoun ?? "Pick Your Pronoun To Preview",
                      style: const TextStyle(fontSize: 14,color: DatingColors.everqpidColor),
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
            backgroundColor:DatingColors.everqpidColor,
            disabledBackgroundColor: DatingColors.lightgrey,
          ),
          child: const Text(
            "Save",
            style: TextStyle(color: DatingColors.white),
          ),
        ),
      ),
    );
  }
}
