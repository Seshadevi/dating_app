import 'package:dating/provider/loginProvider.dart';
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

  @override
  void initState() {
    super.initState();
    titleController.addListener(_checkInput);
    companyController.addListener(_checkInput);
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

  @override
  void dispose() {
    titleController.dispose();
    companyController.dispose();
    super.dispose();
  }

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
                  onPressed: isButtonEnabled
                      ? () {
                          
                          print('Job Added: ${titleController.text}, ${companyController.text}');
                            try {
                            final userId = ref.read(loginProvider).data![0].user?.id ?? '';
                            // final success = await addJob(
                            //   userId: userId,
                            //   title: titleController.text.trim(),
                            //   company: companyController.text.trim(),
                            // );

                            // if (success) {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(content: Text('Job added successfully!')),
                            //   );
                            //   Navigator.pop(context); // Go back after success
                            // }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                          }


                        }
                      : null, // Disable button if fields empty
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isButtonEnabled ? const Color.fromARGB(255, 21, 127, 4) : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'ADD',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
