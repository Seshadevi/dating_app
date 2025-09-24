import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/moreabout/workprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateWorkScreen extends ConsumerStatefulWidget {
  const UpdateWorkScreen({super.key});

  @override
  ConsumerState<UpdateWorkScreen> createState() => _UpdateWorkScreenState();
}

class _UpdateWorkScreenState extends ConsumerState<UpdateWorkScreen> {
  final TextEditingController workController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    workController.addListener(_checkInput);
  }

  void _checkInput() {
    final isFilled = workController.text.trim().isNotEmpty;
    if (isButtonEnabled != isFilled) {
      setState(() => isButtonEnabled = isFilled);
    }
  }

  Future<void> _handleUpdate() async {
    final workText = workController.text.trim();

    if (workText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your work")),
      );
      return;
    }

    try {
      // ✅ Call API with just the work text
      await ref.read(loginProvider.notifier).updateProfile(work:workText);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Work updated successfully!')),
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
    workController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DatingColors.white,
      appBar: AppBar(
        title: const Text('Update Work', style: TextStyle(color: Colors.black)),
        backgroundColor: DatingColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: DatingColors.black),
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
                    controller: workController,
                    decoration: const InputDecoration(
                      labelText: 'Work',
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
                  child: const Text(
                    'UPDATE',
                    style: TextStyle(fontSize: 16, color: DatingColors.brown),
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
