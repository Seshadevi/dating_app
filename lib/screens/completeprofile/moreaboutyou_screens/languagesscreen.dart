import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/model/moreabout/languagemodel.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/moreabout/languageprovider.dart';
import 'package:dating/provider/settings/dark_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends ConsumerState<LanguageSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Data> filteredLanguages = [];
  List<int> selectedIds = [];

  @override
  void initState() {
    super.initState();

    // Fetch languages
    Future.microtask(() async {
      await ref.read(languagesProvider.notifier).getLanguage();

      // Pre-select user languages
      final user = ref.read(loginProvider).data?.first.user;
      final spokenLanguages = user?.spokenLanguages ?? [];
      setState(() {
        selectedIds = spokenLanguages.map((lang) => lang.id!).toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterLanguages(List<Data> languages, String query) {
    setState(() {
      if (query.isEmpty) {
        filteredLanguages = languages;
      } else {
        filteredLanguages = languages
            .where((lang) =>
                lang.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider);

    final languageState = ref.watch(languagesProvider);
    final List<Data> languages = languageState.data ?? [];

    // Initialize filtered list
    if (filteredLanguages.isEmpty && languages.isNotEmpty) {
      filteredLanguages = languages;
    }

    return Scaffold(
      backgroundColor: isDarkMode? DatingColors.black : DatingColors.white ,
      appBar: AppBar(
        backgroundColor: isDarkMode? DatingColors.black : DatingColors.white,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back, color: isDarkMode? DatingColors.white : DatingColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title:  Text(
          "Select Languages",
          style: TextStyle(
            color: isDarkMode? DatingColors.white : DatingColors.brown,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: languageState.isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "What languages do you know?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: DatingColors.everqpidColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Select up to 5",
                    style: TextStyle(
                      fontSize: 16,
                      color: DatingColors.lightgrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Search Field
                  Container(
                    decoration: BoxDecoration(
                      color: DatingColors.surfaceGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => _filterLanguages(languages, value),
                      decoration: InputDecoration(
                        hintText: "Search for a language",
                        hintStyle: TextStyle(
                          color: DatingColors.lightgrey,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: DatingColors.lightgrey,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Language List
                  Expanded(
                    child: filteredLanguages.isEmpty
                        ? const Center(
                            child: Text(
                              "No languages found",
                              style: TextStyle(
                                color: DatingColors.lightgrey,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredLanguages.length,
                            itemBuilder: (context, index) {
                              final lang = filteredLanguages[index];
                              final langId = lang.id;
                              if (langId == null) return const SizedBox.shrink();
                              final isSelected = selectedIds.contains(langId);

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedIds.remove(langId);
                                      } else {
                                        if (selectedIds.length < 5) {
                                          selectedIds.add(langId);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "You can select up to 5 languages only"),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 16),
                                    decoration: BoxDecoration(
                                      color: DatingColors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: DatingColors.everqpidColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            lang.name ?? '',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: DatingColors.brown,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? DatingColors.everqpidColor
                                                : DatingColors.backgroundWhite,
                                            border: Border.all(
                                              color: isSelected
                                                  ? DatingColors.lightgrey
                                                  : DatingColors.everqpidColor,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: isSelected
                                              ? const Icon(
                                                  Icons.check,
                                                  color: DatingColors.white,
                                                  size: 16,
                                                )
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: selectedIds.isEmpty
              ? null
              : () async {
                  try {
                    await ref.read(loginProvider.notifier).updateProfile(
                          causeId: null,
                          image: null,
                          modeid: null,
                          bio: null,
                          modename: null,
                          prompt: null,
                          qualityId: null,
                          languagesId: selectedIds,
                        );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Languages updated successfully!')),
                    );
                    Navigator.pop(context, selectedIds);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Failed to upload languages: $e')),
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedIds.isEmpty
                ? DatingColors.surfaceGrey
                : DatingColors.everqpidColor,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: Text(
            "Save (${selectedIds.length}/5)",
            style: TextStyle(
              color:
                  selectedIds.isEmpty ? DatingColors.brown : DatingColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
