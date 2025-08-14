import 'package:dating/model/moreabout/languagemodel.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/moreabout/languageprovider.dart';
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
    final languageState = ref.watch(languagesProvider);
    final List<Data> languages = languageState.data ?? [];

    // Initialize filtered list
    if (filteredLanguages.isEmpty && languages.isNotEmpty) {
      filteredLanguages = languages;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Select Languages",
          style: TextStyle(
            color: Color.fromARGB(255, 8, 162, 46),
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
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Select up to 5",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Search Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => _filterLanguages(languages, value),
                      decoration: InputDecoration(
                        hintText: "Search for a language",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade500,
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
                                color: Colors.grey,
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
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
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
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? const Color.fromARGB(255, 18, 183, 62)
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: isSelected
                                                  ? const Color.fromARGB(255, 13, 192, 25)
                                                  : Colors.grey.shade400,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: isSelected
                                              ? const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
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
                ? Colors.grey.shade300
                : const Color(0xFF118105),
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: Text(
            "Save (${selectedIds.length}/5)",
            style: TextStyle(
              color:
                  selectedIds.isEmpty ? Colors.grey.shade600 : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
