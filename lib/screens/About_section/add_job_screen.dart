import 'package:flutter/material.dart';

class AddJobScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController companyController = TextEditingController();

  AddJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Add Job',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
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
                labelText: 'company',
                border: InputBorder.none,
              ),
            ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
