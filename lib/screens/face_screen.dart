import 'dart:io';
import 'package:dating/screens/openingMoveScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoUploadScreen extends StatefulWidget {
  const PhotoUploadScreen({super.key});

  @override
  State<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  final List<File?> _selectedImages = List.filled(6, null);

  Future<void> _pickImage(int index) async {
    final picker = ImagePicker();
    final XFile? pickedImage = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (context) => _buildPickerSheet(picker),
    );

    if (pickedImage != null) {
      setState(() {
        _selectedImages[index] = File(pickedImage.path);
      });
    }
  }

  Widget _buildPickerSheet(ImagePicker picker) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take Photo'),
            onTap: () async {
              final image = await picker.pickImage(source: ImageSource.camera);
              Navigator.pop(context, image);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Choose from Gallery'),
            onTap: () async {
              final image = await picker.pickImage(source: ImageSource.gallery);
              Navigator.pop(context, image);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    int imageCount = _selectedImages.where((img) => img != null).length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: 7 / 16,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 147, 179, 3)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context); // You can customize this
                    },
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      // Skip navigation
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "Time To Put A Face To The Name",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "You Do You! Add At Least 4 Photos, Whether It’s You With Your Pet, Eating Your Fave Food, Or In A Place You Love.",
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(6, (index) {
                  return GestureDetector(
                    onTap: () => _pickImage(index),
                    child: Container(
                      width: 90,
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.greenAccent,
                          width: 2,
                        ),
                      ),
                      child: _selectedImages[index] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _selectedImages[index]!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.add, size: 32),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt, color: Colors.green),
                  const SizedBox(width: 8),
                  const Text(
                    "Want To Make Sure You Really Shine?",
                    style: TextStyle(fontSize: 12),
                  ),
                  TextButton(
                    onPressed: () {
                      // Go to photo tips
                    },
                    child: const Text(
                      "Check Out Our Photo Tips",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$imageCount/4 Selected',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: screen.width * 0.125,
                      height: screen.width * 0.125,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xffB2D12E), Color(0xff000000)],
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios,
                            color: Colors.white),
                        onPressed: () {
                          if (imageCount >= 4) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OpeningMoveScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Please upload at least 4 photos."),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
