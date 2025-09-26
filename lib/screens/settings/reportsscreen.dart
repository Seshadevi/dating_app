import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/settings/categoryprovider.dart';
import 'package:dating/provider/settings/reports.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating/model/settings/Categorymodel.dart';



class Reportsscreen extends ConsumerStatefulWidget {
  const Reportsscreen({super.key});

  @override
  ConsumerState<Reportsscreen> createState() => _ReportsscreenState();
}

class _ReportsscreenState extends ConsumerState<Reportsscreen> {
  final TextEditingController _descriptionController = TextEditingController();
  Data? selectedCategory;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch categories when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryprovider.notifier).getreport();
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (selectedCategory == null) {
      _showSnackBar('Please select a category');
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      _showSnackBar('Please enter a description');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final success = await ref.read(reportProvider.notifier).addReport(
        categoryId: selectedCategory?.id,
        description: _descriptionController.text.trim(),
      );

      if (success) {
        _showSnackBar('Report submitted successfully');
        Navigator.pop(context);
      } else {
        _showSnackBar('Failed to submit report. Please try again.');
      }
    } catch (e) {
      _showSnackBar('An error occurred. Please try again.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.contains('success') ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryprovider);
    final categories = categoryState.data ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Submit a Report',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              // Category Dropdown
              const Text(
                'Select Category',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: DatingColors.everqpidColor,
                    width: 1,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Data>(
                    value: selectedCategory,
                    hint: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Choose a category',
                        style: TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    isExpanded: true,
                    items: categories.map((Data category) {
                      return DropdownMenuItem<Data>(
                        value: category,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            category.category ?? 'Unknown Category',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (Data? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Description Input Container
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: DatingColors.everqpidColor,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: 'Describe your report in detail...',
                    hintStyle: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: DatingColors.brown,
                  ),
                ),
              ),
              
              // const SizedBox(height: 24),
              
              // // Add Screenshot Button (Optional)
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       'Add A Screenshot ( Optional )',
              //       style: TextStyle(
              //         color: Colors.black87,
              //         fontSize: 18,
              //         fontWeight: FontWeight.bold,
              //         decoration: TextDecoration.underline,
              //         decorationColor: const Color.fromARGB(255, 37, 30, 4)
              //       ),
              //     ),
              //   ],
              // ),
              
              const SizedBox(height: 130),
              
              // Submit Report Button
              Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DatingColors.everqpidColor,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(
                      color: Color.fromARGB(57, 24, 27, 1),
                      width: 2,
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : const Text(
                          'Submit Report',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
              
              // Cancel Button
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}