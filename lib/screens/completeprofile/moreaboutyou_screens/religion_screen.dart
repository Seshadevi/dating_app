import 'package:dating/screens/completeprofile/complete_profile.dart';
import 'package:flutter/material.dart';

class ReligionScreen extends StatefulWidget {
  const ReligionScreen({super.key});

  @override
  State<ReligionScreen> createState() => _ReligionScreenState();
}

class _ReligionScreenState extends State<ReligionScreen> {
  List<String> selectedOptions = [];
  
  final List<String> options = [
    'Agnostic',
    'Atheist',
    'Buddhist',
    'Christian',
    'Hindu',
    'Jain',
    'Jewish',
    'Mormon',
    'Latter-Day Saint',
    'Muslim',
    'Zoroastrain',
    'Sikh',
    'Spiritual',
    'Other',
  ];

  void toggleOption(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Header with icon and title
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8BC34A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.star_border,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Do you identify with a religion',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Options list
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = selectedOptions.contains(option);
                  final isFirstOption = index == 0;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GestureDetector(
                      onTap: () => toggleOption(option),
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? (isFirstOption 
                                  ? const LinearGradient(
                                      colors: [Color(0xffB2D12E), Color(0xFF2B2B2B)],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    )
                                  : const LinearGradient(
                                      colors: [Color(0xffB2D12E), Color(0xFF2B2B2B)],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ))
                              : null,
                          color: isSelected ? null : Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: isSelected 
                                ? Colors.transparent 
                                : const Color(0xffB2D12E),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Skip button
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BumbleDateProfileScreen(),));
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}