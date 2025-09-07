import 'dart:ui';

import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/moreabout/workprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddJobScreen extends ConsumerStatefulWidget {
  const AddJobScreen({super.key});

  @override
  ConsumerState<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends ConsumerState<AddJobScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController companyController = TextEditingController();

  bool isButtonEnabled = false;
  int? _editingId; // null = adding mode, not null = editing mode

  @override
  void initState() {
    super.initState();
    titleController.addListener(_checkInput);
    companyController.addListener(_checkInput);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get arguments only once when the route is first built
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && _editingId == null) { // Only set if not already set
      _editingId = args['id'] as int?;
      titleController.text = args['title'] ?? '';
      companyController.text = args['company'] ?? '';
      
      // Check input after setting initial values
      _checkInput();
    }
  }

  void _checkInput() {
    final isFilled = titleController.text.trim().isNotEmpty &&
        companyController.text.trim().isNotEmpty;
    if (isButtonEnabled != isFilled) {
      setState(() {
        isButtonEnabled = isFilled;
      });
    }
  }

  Future<void> _handleSubmit() async {
    final title = titleController.text.trim();
    final company = companyController.text.trim();

    if (title.isEmpty || company.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    try {
      if (_editingId == null) {
        // ADD MODE
        final userId = ref.read(loginProvider).data![0].user?.id ?? '';
        final success = await ref.read(workProvider.notifier).addwork(
          title: title,
          company: company,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Job added successfully!')),
          );
          Navigator.pop(context);
        }
      } else {
        // EDIT MODE - Replace with your actual update method
        await ref.read(workProvider.notifier).updateSelectedwork(
          _editingId!,
          title,
          company,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    companyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editingId != null;

    return Scaffold(
      backgroundColor: DatingColors.white,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Job' : 'Add Job',
          style: const TextStyle(color: Colors.black),
        ),
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
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                  child: TextField(
                    controller: companyController,
                    decoration: const InputDecoration(
                      labelText: 'Company',
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
                  onPressed: isButtonEnabled ? _handleSubmit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isButtonEnabled ? DatingColors.everqpidColor : DatingColors.lightgrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    isEditing ? 'UPDATE' : 'ADD',
                    style: const TextStyle(fontSize: 16, color: DatingColors.brown),
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