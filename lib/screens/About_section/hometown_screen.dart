import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/settings/dark_mode_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HometownScreen extends ConsumerStatefulWidget {
  const HometownScreen({super.key});

  @override
  ConsumerState<HometownScreen> createState() => _HometownScreenState();
}

class _HometownScreenState extends ConsumerState<HometownScreen> {
  final TextEditingController hometownController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    hometownController.addListener(_checkInput);
  }

  void _checkInput() {
    final isFilled = hometownController.text.trim().isNotEmpty;
    if (isButtonEnabled != isFilled) {
      setState(() => isButtonEnabled = isFilled);
    }
  }

  Future<void> _handleUpdate() async {
    final hometownText = hometownController.text.trim();

    if (hometownText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your hometown")),
      );
      return;
    }

    try {
      // ✅ Call API with just the work text
      await ref.read(loginProvider.notifier).updateProfile(homelocation:hometownText);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('hometown updated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    hometownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider);
    return Scaffold(
      
      backgroundColor: Theme.of(context).scaffoldBackgroundColor ,
      appBar: AppBar(
        title:  Text('Hometown', style: TextStyle(color: isDarkMode? DatingColors.white : Colors.black)),
        backgroundColor: isDarkMode? DatingColors.black : DatingColors.white,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios_new, color: isDarkMode? DatingColors.white : DatingColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                  child: TextField(
                    controller: hometownController,
                    decoration:  InputDecoration(
                      labelText: 'hometown',labelStyle: TextStyle(color: isDarkMode? DatingColors.white : DatingColors.black ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Divider(height: 1),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isButtonEnabled ? _handleUpdate : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isButtonEnabled
                        ? DatingColors.everqpidColor
                        : DatingColors.lightgrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'UPDATE',
                    style: TextStyle(fontSize: 16, color: isDarkMode? DatingColors.white :  DatingColors.brown),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
