import 'dart:io';
import 'package:dating/screens/openingMoveScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoUploadScreen extends StatefulWidget {

  final String email;
  final double latitude;
  final double longitude;
  final String userName;
  final String dateOfBirth;
  final String selectedGender;
  final bool showGenderOnProfile;
  final dynamic showMode;
  final List<String> selectedGenderIds;
  final List<int> selectionOptionIds;
  final dynamic selectedHeight;
  final List<int> selectedInterestIds;
  final List<int> selectedqualitiesIDs;
  final List<int> selectedhabbits;
  final List<int> selectedkids;
  final List<int> selectedreligions;
  final List<int> selectedcauses;
  final List<String> seletedprompts;

  const PhotoUploadScreen(
    {
    super.key,
    required this.email,
    required this.latitude,
    required this.longitude,
    required this.userName,
    required this.dateOfBirth,
    required this.selectedGender,
    required this.showGenderOnProfile,
    this.showMode,
    required this.selectedGenderIds,
    required this.selectionOptionIds,
    this.selectedHeight,
    required this.selectedInterestIds,
    required this.selectedqualitiesIDs,
    required this.selectedhabbits,
    required this.selectedkids,
    required this.selectedreligions,
    required this.selectedcauses,
    required this.seletedprompts, 
    // required List<String> gendermode
    });

  @override
  State<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  final List<File?> selectedImages = List.filled(6, null);

  Future<void> _pickImage(int index) async {
    final picker = ImagePicker();
    final XFile? pickedImage = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (context) => _buildPickerSheet(picker),
    );

    if (pickedImage != null) {
      setState(() {
        selectedImages[index] = File(pickedImage.path);
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
    int imageCount = selectedImages.where((img) => img != null).length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: 17 / 18,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 147, 179, 3)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context),
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
                      child: selectedImages[index] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                selectedImages[index]!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.add, size: 32),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              /// Changed section starts here
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Want To Make Sure You Really Shine?",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Center(
                child: TextButton(
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
              ),
              /// Changed section ends here

              const SizedBox(height: 14),
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
                                builder: (context) => OpeningMoveScreen(
                                                email: widget.email,
                                                latitude: widget.latitude,
                                                longitude: widget.longitude,
                                                userName: widget.userName,
                                                dateOfBirth: widget.dateOfBirth,
                                                selectedGender: widget.selectedGender,
                                                showGenderOnProfile: widget.showGenderOnProfile,
                                                showMode: widget.showMode,
                                                selectedGenderIds:widget.selectedGenderIds,
                                                selectionOptionIds:widget.selectionOptionIds,
                                                selectedHeight:widget.selectedHeight ,
                                                selectedInterestIds:widget.selectedInterestIds,
                                                selectedqualitiesIDs:widget.selectedqualitiesIDs,
                                                selectedhabbits: widget.selectedhabbits,
                                                selectedkids:widget.selectedkids,
                                                selectedreligions:widget.selectedreligions,
                                                selectedcauses:widget.selectedcauses,
                                                seletedprompts:widget.seletedprompts,
                                                choosedimages:selectedImages
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Please upload at least 4 photos."),
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
