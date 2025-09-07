import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:dating/screens/About_section/learn_more_screen.dart';
// import 'package:dating/providers/login_provider.dart';

class UpdateGenderScreen extends ConsumerStatefulWidget {
  const UpdateGenderScreen({super.key});

  @override
  ConsumerState<UpdateGenderScreen> createState() => _UpdateGenderScreenState();
}

class _UpdateGenderScreenState extends ConsumerState<UpdateGenderScreen> {
  String selectedGender = '';
  bool showOnProfile = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserGender();
  }

  Future<void> _loadUserGender() async {
    final user = ref.read(loginProvider); // Assuming this has user data
    if (user != null) {
      setState(() {
        selectedGender = user.data![0].user!.gender ?? 'Woman';
        showOnProfile = user.data!.first.user!.showOnProfile ?? false;
      });
    }
  }

  Future<void> _updateGender() async {
    if (selectedGender.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a gender')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await ref.read(loginProvider.notifier).updateProfile(
            gender: selectedGender,
            showOnProfile: showOnProfile,
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gender updated successfully')),
      );

      Navigator.pop(context); // Go back after save
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update gender: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget genderOption(String gender) {
    final isSelected = selectedGender == gender;

    return GestureDetector(
      onTap: () => setState(() => selectedGender = gender),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ?  DatingColors.everqpidColor : DatingColors.white,
          gradient: isSelected
              ? const LinearGradient(
                  colors: [DatingColors.lightpinks, DatingColors.everqpidColor],
                )
              : null,
          border: Border.all(color: DatingColors.everqpidColor),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              gender,
              style: TextStyle(
                color: isSelected ? DatingColors.brown : DatingColors.black,
                fontSize: 16,
              ),
            ),
            // Icon(
            //   isSelected ? Icons.toggle_on : Icons.toggle_off_outlined,
            //   color: isSelected ? Colors.white : const Color(0xFF89A000),
            //   size: 32,
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Your Gender', style: TextStyle(color: DatingColors.black)),
        backgroundColor: DatingColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: DatingColors.black),
          onPressed: () => Navigator.pop(context),
          // onPressed: () => Navigator.pushNamed(context, '/completeprofile'),
        ),
      ),
      backgroundColor: DatingColors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pick Which Best Describes You',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  // const Text('Then add more about your gender if you like',
                  //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  // TextButton(
                  //   onPressed: () => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (_) => const LearnMoreScreen()),
                  //   ),
                  //   child: const Text(
                  //     'Learn What This Means',
                  //     style: TextStyle(decoration: TextDecoration.underline),
                  //   ),
                  // ),
                  const SizedBox(height: 40),
                  genderOption("He/Him"),
                  genderOption("She/Her"),
                  // genderOption("Nonbinary"),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: DatingColors.everqpidColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Show On Your Profile'),
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: DatingColors.lightpinks,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Show As: $selectedGender',
                                  style: const TextStyle(color: DatingColors.brown),
                                ),
                              ),
                            ]),
                        Switch(
                          value: showOnProfile,
                          onChanged: (value) => setState(() => showOnProfile = value),
                          activeColor: DatingColors.everqpidColor,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 180),
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [DatingColors.everqpidColor, DatingColors.everqpidColor]),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextButton(
                        onPressed: _updateGender,
                        child: const Text('Save',
                            style: TextStyle(color: DatingColors.brown, fontSize: 16)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
