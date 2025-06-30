import 'package:dating/screens/About_section/city_screen.dart';
import 'package:dating/screens/About_section/education_screen.dart';
import 'package:dating/screens/About_section/gender_screen.dart';
import 'package:dating/screens/About_section/hometown_screen.dart';
import 'package:dating/screens/About_section/occupation_screen.dart';
import 'package:dating/screens/completeprofile/id_verification_screen.dart';
import 'package:dating/screens/completeprofile/intrest_screen.dart';
import 'package:dating/screens/completeprofile/lifeBadgesScreen.dart';
import 'package:dating/screens/completeprofile/profile_strength_detailScreen.dart';
import 'package:dating/screens/completeprofile/prompt_selection_screen.dart';
import 'package:dating/screens/completeprofile/pronoun_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BumbleDateProfileScreen extends StatefulWidget {
  const BumbleDateProfileScreen({super.key});

  @override
  _BumbleDateProfileScreenState createState() =>
      _BumbleDateProfileScreenState();
}

class _BumbleDateProfileScreenState extends State<BumbleDateProfileScreen> {
  List<File?> selectedImages = List.filled(6, null);
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _bioController = TextEditingController();
  String selectedGender = 'Man';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Bumble Date',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Strength Section
            _buildProfileStrengthSection(),
            SizedBox(height: 24),

            // Photos and Videos Section
            _buildPhotosVideosSection(),
            SizedBox(height: 24),

            // Get Verified Section
            _buildGetVerifiedSection(),
            SizedBox(height: 24),

            // My Life Section
            _buildMyLifeSection(context),
            SizedBox(height: 24),

            // Interests Section
            _buildInterestsSection(),
            SizedBox(height: 24),

            // Prompts Section
            _buildPromptsSection(context),
            SizedBox(height: 24),

            // Bio Section
            _buildBioSection(),
            SizedBox(height: 24),

            // About You Section
            _buildAboutYouSection(),
            SizedBox(height: 24),

            // More About You Section
            _buildMoreAboutYouSection(),
            SizedBox(height: 24),

            // Pronouns Section
            _buildPronounsSection(),
            SizedBox(height: 24),

            // Languages Section
            _buildLanguagesSection(),
            SizedBox(height: 24),

            // Connected Accounts Section
            _buildConnectedAccountsSection(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStrengthSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Strength',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileStrengthDetailScreen(),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF869E23), Color(0xFF000000)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.all(2), // This simulates the border thickness
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 247, 245, 247),
                borderRadius: BorderRadius.circular(
                    14), // Slightly smaller for inner container
              ),
              child: Row(
                children: [
                  Text(
                    '20% Complete',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios,
                      color: Colors.grey[600], size: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotosVideosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photos And Videos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Choose A Few That Truly Represent You',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          childAspectRatio: 1,
          children: List.generate(6, (index) {
            return _buildPhotoSlot(index: index);
          }),
        ),
        SizedBox(height: 8),
        Text(
          'Drag And Release The Media In The Sequence',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoSlot({required int index}) {
    bool hasImage = selectedImages[index] != null;

    return GestureDetector(
      onTap: () => _showImageSourceDialog(index),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF869E23), Color(0xFF000000)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(2), // Thickness of gradient border
          child: Container(
            decoration: BoxDecoration(
              color: hasImage ? Colors.grey[200] : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: hasImage
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          selectedImages[index]!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.grey[400],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog(int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, index);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, index);
                },
              ),
              if (selectedImages[index] != null)
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title:
                      Text('Remove Photo', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      selectedImages[index] = null;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source, int index) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          selectedImages[index] = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Widget _buildGetVerifiedSection() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IdVerificationScreen(),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(Icons.verified_user_outlined,
                color: Colors.grey[600], size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Get Verified',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Not ID Verified',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMyLifeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Life',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Show How You Are In Life With Your Friends',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionButton(
          'Add Life Badges',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LifeBadgesScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInterestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interests',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Let People About The Things You Love',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 16),
        _buildSectionButton(
          'Add Interest Badges',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const IntrestScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPromptsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prompts',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'I like To Personality Stand Out From The Crowd',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PromptSelectionScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Add a prompt',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 16,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bio',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Write a few short words about you',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: _bioController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Write about you',
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionButton(String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutYouSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About You',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16),
        _buildProfileItem(Icons.work_outline, 'Work', 'Add', onTap: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => OccupationScreen()));
        }),
        _buildProfileItem(Icons.school_outlined, 'Education', 'Add', onTap: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => EducationScreen()));
        }),
        _buildProfileItem(Icons.person_outline, 'Gender', selectedGender,
            onTap: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => UpdateGenderScreen()));
        }),
        _buildProfileItem(Icons.location_on_outlined, 'Location', 'Add',
            onTap: () {
               Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => FindCityScreen()));
            }),
        _buildProfileItem(Icons.home_outlined, 'Hometown', 'Add', onTap: () {
           Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => HomeTownSelectionScreen()));
        }),
      ],
    );
  }

  Widget _buildMoreAboutYouSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'More About You',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Share More Details About Yourself Are Curious About',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 16),
        _buildProfileItem(Icons.search, 'Looking For', 'Add', onTap: () {}),
        _buildProfileItem(Icons.favorite_border, 'Relationship', 'Add',
            onTap: () {}),
        _buildProfileItem(Icons.child_care, 'Have A Kids', 'Add', onTap: () {}),
        _buildProfileItem(Icons.smoking_rooms_outlined, 'Smoking', 'Add',
            onTap: () {}),
        _buildProfileItem(Icons.local_drink_outlined, 'Drinking', 'Add',
            onTap: () {}),
        _buildProfileItem(Icons.fitness_center_outlined, 'Exercise', 'Add',
            onTap: () {}),
        _buildProfileItem(Icons.location_city_outlined, 'New To Area', 'Add',
            onTap: () {}),
        _buildProfileItem(Icons.star_border, 'Star Sign', 'Add', onTap: () {}),
        _buildProfileItem(Icons.place_outlined, 'Religion', 'Add',
            onTap: () {}),
      ],
    );
  }

  Widget _buildPronounsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pronouns',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Let People See Your Pronouns',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: GestureDetector(
            onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GenderPronounsScreen(), // your target screen
                  ),
                );
              },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Add Your Pronouns',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Languages',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Choose The Languages You Know',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Add Your Languages',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnectedAccountsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connected Accounts',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Show Off Your Favourite Music',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Connect My Spotify',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      color: Colors.grey[400], size: 16),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Show Your Recently Played Songs On Your Profile And Allow The Songs You Listen To Recommendation Conversation Starters Based On Shared Music Tastes',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              SizedBox(height: 16),
              // Music rating bubbles
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  return Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.music_note,
                      color: Colors.grey[400],
                      size: 24,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600], size: 24),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: value == 'Add' ? Colors.grey[500] : Colors.black,
                fontWeight:
                    value == 'Add' ? FontWeight.normal : FontWeight.w500,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  void _showGenderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Gender'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildGenderOption('Man'),
              _buildGenderOption('Woman'),
              _buildGenderOption('Non-binary'),
              _buildGenderOption('Other'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGenderOption(String gender) {
    return RadioListTile<String>(
      title: Text(gender),
      value: gender,
      groupValue: selectedGender,
      onChanged: (String? value) {
        setState(() {
          selectedGender = value!;
        });
        Navigator.pop(context);
      },
    );
  }
}

// Extension to add this screen to the original profile screen
extension BumbleDateProfileScreenExtension on _BumbleDateProfileScreenState {
  void navigateToProfileDetails() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ProfileDetailsScreen(),
    //   ),
    // );
  }
}

// Profile Strength Detail Screen

// ID Verification Screen
