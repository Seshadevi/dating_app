import 'package:dating/constants/dating_app_user.dart';
import 'package:flutter/material.dart';
class AboutNonbinary extends StatefulWidget {
  final List<String> genderOptions;

  const AboutNonbinary({
    super.key,
    required this.genderOptions,
  });

  @override
  State<AboutNonbinary> createState() => _AboutNonbinaryState();
}

class _AboutNonbinaryState extends State<AboutNonbinary> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DatingColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: DatingColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: DatingColors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Add More About Your Gender',
          style: TextStyle(
            color: DatingColors.black,
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
                          color: isSelected ? DatingColors.darkGreen: DatingColors.black,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            gender,
                            style: const TextStyle(fontSize: 16, color: DatingColors.black),
                          ),
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
            title: const Text(
              "Tell Us If We're Missing Something",
              style: TextStyle(fontSize: 16),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Handle feedback action
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: GestureDetector(
              onTap: () {
                // Handle save
              },
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: const LinearGradient(
                    colors: [DatingColors.primaryGreen, DatingColors.black],
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
