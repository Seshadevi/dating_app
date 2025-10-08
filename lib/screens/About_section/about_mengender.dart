import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/settings/dark_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AboutMengender extends ConsumerStatefulWidget {
  final List<String> genderOptions;

  const AboutMengender({
    super.key,
    required this.genderOptions,
  });

  @override
  ConsumerState<AboutMengender> createState() => _AboutMengenderState();
}

class _AboutMengenderState extends ConsumerState<AboutMengender> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor ,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: DatingColors.black),
          onPressed: () => Navigator.pop(context),
        ),
       backgroundColor: Theme.of(context).scaffoldBackgroundColor ,
        elevation: 0,
        centerTitle: true,
        title:  Text(
          'Add More About Your Gender',
          style: TextStyle(
            color: isDarkMode ? DatingColors.white : DatingColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.genderOptions.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final gender = widget.genderOptions[index];
                final isSelected = selectedGender == gender;

                return InkWell(
                  onTap: () => setState(() => selectedGender = gender),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? DatingColors.darkGreen : DatingColors.black,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          gender,
                          style:  TextStyle(fontSize: 16, color: isDarkMode ? DatingColors.white : DatingColors.black),
                        ),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: DatingColors.darkGreen,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: DatingColors.darkGreen,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title:  Text(
              "Tell Us If We're Missing Something",
              style: TextStyle(fontSize: 16, color: isDarkMode ? DatingColors.white : DatingColors.lightgrey ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Handle navigation to feedback form
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: GestureDetector(
              onTap: () {
                // Save selectedGender
              },
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: const LinearGradient(
                    colors: [DatingColors.darkGreen, DatingColors.black],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: const Text(
                  'Save and close',
                  style: TextStyle(color: DatingColors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
