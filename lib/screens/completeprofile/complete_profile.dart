import 'package:dating/model/loginmodel.dart';
import 'package:dating/model/signupprocessmodels/lookingModel.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/screens/About_section/city_screen.dart';
import 'package:dating/screens/About_section/education_screen.dart';
import 'package:dating/screens/About_section/gender_screen.dart';
import 'package:dating/screens/About_section/hometown_screen.dart';
import 'package:dating/screens/About_section/occupation_screen.dart';
import 'package:dating/screens/completeprofile/causeScreen.dart';
import 'package:dating/screens/completeprofile/id_verification_screen.dart';
import 'package:dating/screens/completeprofile/interests.dart';
import 'package:dating/screens/completeprofile/intrest_screen.dart';
import 'package:dating/screens/completeprofile/lifeBadgesScreen.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/drinking_screen.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/exercise_screen.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/have_kids_screen.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/languagesscreen.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/looking_for_screen.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/new_to_area_screen.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/relationship_screen.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/religion_screen.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/smoking_screen.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/star_sign_screen.dart';
import 'package:dating/screens/completeprofile/profile_strength_detailScreen.dart';
import 'package:dating/screens/completeprofile/prompt_selection_screen.dart';
import 'package:dating/screens/completeprofile/pronoun_screen.dart';
import 'package:dating/screens/completeprofile/qualities.dart';
// import 'package:dating/screens/profile_screens/languagesScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BumbleDateProfileScreen extends ConsumerStatefulWidget {
  const BumbleDateProfileScreen({super.key});

  @override
  _BumbleDateProfileScreenState createState() =>
      _BumbleDateProfileScreenState();
}

class _BumbleDateProfileScreenState
    extends ConsumerState<BumbleDateProfileScreen> {
  // List<ImageProvider?> selectedImages = List.filled(6, null);
  // List<File?> selectedImages = List.filled(6, null);
  List<dynamic> selectedImages =
      List.filled(6, null); // allows both File and NetworkImage
  bool isEditing = false;
  final TextEditingController _bioController = TextEditingController();
  bool isAddingPrompt = false;
  final TextEditingController _promptController = TextEditingController();
  List<Map<String, dynamic>> localPrompts = [];
  int? editingPromptIndex; // Track which prompt is being edited
  TextEditingController _editPromptController = TextEditingController();
  late File image;
  String? selectedLooking;
  String? selectedkid;
  String? selectedDrink;
  String? selectedReligion;
 String? userLooking;
 String? userkid;
 String? userDrink;
  String? userReligion;
  bool hasUserUpdatedDrink = false;

  final ImagePicker _picker = ImagePicker();
  // final TextEditingController _bioController = TextEditingController();
  String selectedGender = 'Man';
  @override
  void initState() {
    super.initState();
    _loadUserProfileImages();
    //  _bioController.text = serverHeadline ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userData = ref.read(loginProvider);
      final user =
          userData.data?.isNotEmpty == true ? userData.data![0].user : null;

      if (user != null) {
        setState(() {
        final lookingForList = user.lookingFor;

          if (lookingForList != null &&
              lookingForList.isNotEmpty &&
              lookingForList[0] is Map &&
              lookingForList[0].value != null) {
            userLooking = lookingForList[0].value.toString();
          }

        final userkidList = user.kids ;
         if (userkidList != null &&
              userkidList.isNotEmpty &&
             userkidList[0] is Map &&
              userkidList[0].kids != null) {
            userkid = userkidList[0].kids.toString();
          }

          final userDrinkList = user.drinking;
           if (userDrinkList != null &&
              userDrinkList.isNotEmpty &&
             userDrinkList[0] is Map &&
              userDrinkList[0].preference != null) {
            userDrink = userDrinkList[0].preference.toString();
          }
          final userReligionList = user.religions;
           if (userReligionList != null &&
              userReligionList.isNotEmpty &&
             userkidList![0] is Map &&
              userReligionList[0].religion != null) {
            userReligion =userReligionList[0].religion.toString();
          }

          // Add other fields if needed (smoking, starSign, etc.)
          print('lookingfor:::$userLooking');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(loginProvider);
    final user =
        userData.data?.isNotEmpty == true ? userData.data![0].user : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushNamed(context, '/custombottomnav'),
        ),
        title: Text(
          'everquid ${user?.mode ?? ''}',
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
            _buildQualitiesSection(context),
            SizedBox(height: 24),

            // Interests Section
            _buildInterestsSection(context),
            SizedBox(height: 24),
            // Interests Section
            _buildCausesSection(context),
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

  void _loadUserProfileImages() {
    final userData = ref.read(loginProvider);
    final user =
        userData.data?.isNotEmpty == true ? userData.data![0].user : null;

    if (user != null && user.profilePics != null) {
      final profilePics = user.profilePics!;
      for (int i = 0; i < profilePics.length && i < 6; i++) {
        final fullUrl = "http://97.74.93.26:6100${profilePics[i].url}";

        selectedImages[i] = NetworkImage(fullUrl);
      }
    }
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
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
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
    final image = selectedImages[index];

    return GestureDetector(
      onTap: () => _showImageSourceDialog(index),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF869E23), Color(0xFF000000)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(
              color: image != null ? Colors.grey[200] : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: image != null
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          image: image,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 20, 109, 23),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 10,
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
        final File imageFile = File(pickedFile.path);
        setState(() {
          selectedImages[index] = FileImage(imageFile);
        });
        print('images.......$imageFile');

        // ✅ After setting image, call API to update immediately
        _uploadProfileImage(imageFile, index);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _uploadProfileImage(File imageFile, int index) async {
    print('Uploading image at index $index: ${imageFile.path}');

    try {
      // if (pickedImage != null) {
      //   final File imageFile = File(pickedImage.path);
      //   final String key = 'photo1'; // Can also be 'profileImage', etc.

      await ref.read(loginProvider.notifier).updateProfile(
          image: imageFile,
          modeid: null,
          bio: null,
          modename: null,
          prompt: null,
          qualityId: null);

      print('Uploading image at index $index: ${imageFile.path}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
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

  Widget _buildQualitiesSection(BuildContext context) {
  final userData = ref.watch(loginProvider);
  final user =
      userData.data?.isNotEmpty == true ? userData.data![0].user : null;
  final List<Qualities> qualities = List<Qualities>.from(user?.qualities ?? []);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Qualities',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'Get specific about the things you love.',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      const SizedBox(height: 16),

      /// Entire content inside one Card-like container
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Favorite quality header
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LifeBadgesScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: const [
                    Icon(Icons.bookmark_border, size: 20, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      'Favorite quality',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),

            /// Selected qualities chips
            if (qualities.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: qualities.map<Widget>((quality) {
                    final name = qualities.first.name ?? '';
                    // final emoji = quality.emoji ?? '🌟';
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Text(emoji),
                          const SizedBox(width: 6),
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

            /// Add more qualities button
            GestureDetector(
              onTap: () {
                final selected = qualities
                    .map<Map<String, dynamic>>((q) => {
                          'id': q.id,
                          'name': q.name,
                        })
                    .toList();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QualitiesScreen(
                      usersQualities: selected,
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        'Add more qualities',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(Icons.add, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}


  Widget _buildInterestsSection(BuildContext context) {
    final userData = ref.watch(loginProvider);
    final user =
        userData.data?.isNotEmpty == true ? userData.data![0].user : null;
    final List<dynamic> interests = user?.interests ?? [];
    print('interests...........$interests');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Interests',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Get specific about the things you love',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),

        // ✅ Entire content inside one Card-like container
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Favorite quality header
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LifeBadgesScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      // border: Border(
                      //   bottom: BorderSide(color: Colors.grey.shade300),
                      // ),
                      ),
                  child: Row(
                    children: const [
                      Icon(Icons.bookmark_border,
                          size: 20, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        'Favorite Interests',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),

              // Selected qualities chips
              if (interests.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: interests.map<Widget>((interests) {
                      final name = interests['interests'] ?? '';
                      final emoji = interests['emoji'] ?? '🌟';
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(emoji),
                            const SizedBox(width: 6),
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

              // Add more qualities button
              GestureDetector(
                onTap: () {
                  List<Map<String, dynamic>> selected =
                      interests.map<Map<String, dynamic>>((interest) {
                    return {
                      'id': interest['id'],
                      'interests': interest['interests'],
                      'emoji': interest[
                          'emoji'], // ✅ Include emoji if you use it later
                    };
                  }).toList();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InterestsScreen(
                        usersInterets: selected,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Add more interests',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(Icons.add, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCausesSection(BuildContext context) {
  final userData = ref.watch(loginProvider);
  final user = userData.data?.isNotEmpty == true ? userData.data![0].user : null;
  final List<CausesAndCommunities> causes = user?.causesAndCommunities ?? [];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Causes',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'Get specific about the things you love.',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      const SizedBox(height: 16),

      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LifeBadgesScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: const [
                    Icon(Icons.bookmark_border, size: 20, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      'Favorite causes',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),

            // Selected causes chips
            if (causes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: causes.map<Widget>((cause) {
                    final name = cause.causesAndCommunities ?? '';
                    // final emoji = cause.emoji ?? '🌟';
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Text(emoji),
                          const SizedBox(width: 6),
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

            // Add more causes button
            GestureDetector(
              onTap: () {
                List<Map<String, dynamic>> selected = causes.map((cause) {
                  return {
                    'id': cause.id,
                    'causesAndCommunities': cause.causesAndCommunities,
                  };
                }).toList();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CausesScreen(usersCauses: selected),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        'Add more causes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(Icons.add, size: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}


  Widget _buildPromptsSection(BuildContext context) {
  final userData = ref.watch(loginProvider);
  final user = userData.data?.isNotEmpty == true ? userData.data![0].user : null;
  final List<Prompts> serverPrompts = user?.prompts ?? [];
  final List<dynamic> prompts = localPrompts.isNotEmpty ? localPrompts : serverPrompts;

  List<TextEditingController> _editPromptControllers =
      List.generate(3, (_) => TextEditingController());

  // Prepare prompt values for editing
  List<Map<String, String>> editablePrompts = List.generate(
    3,
    (i) => {
      "prompt": i < prompts.length
          ? (prompts[i] is Prompts ? prompts[i].prompt : prompts[i]['prompt'] ?? '')
          : '',
    },
  );

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Prompts',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      const SizedBox(height: 8),
      const Text(
        'Add personality to your profile with prompts.',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
      const SizedBox(height: 16),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (editingPromptIndex == null)
              ...prompts.asMap().entries.map((entry) {
                final int index = entry.key;
                final String promptText = entry.value is Prompts
                    ? entry.value.prompt
                    : entry.value['prompt'] ?? '';

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          promptText,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.black, size: 15),
                        onPressed: () {
                          setState(() {
                            editingPromptIndex = 0;
                            _editPromptControllers = List.generate(
                              3,
                              (i) => TextEditingController(
                                text: i < prompts.length
                                    ? (prompts[i] is Prompts
                                        ? prompts[i].prompt
                                        : prompts[i]['prompt'] ?? '')
                                    : '',
                              ),
                            );
                          });
                        },
                      )
                    ],
                  ),
                );
              }).toList()
            else
              Column(
                children: List.generate(3, (i) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: TextField(
                      controller: _editPromptControllers[i],
                      maxLines: 2,
                      style: const TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Prompt ${i + 1}',
                        border: InputBorder.none,
                      ),
                    ),
                  );
                }),
              ),
            if (editingPromptIndex != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          editingPromptIndex = null;
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        final updatedPrompts = _editPromptControllers
                            .map((c) => c.text.trim())
                            .where((text) => text.isNotEmpty)
                            .map((text) => {'prompt': text})
                            .toList();

                        setState(() {
                          localPrompts = updatedPrompts;
                          editingPromptIndex = null;
                        });

                        ref.read(loginProvider.notifier).updateProfile(
                              image: null,
                              modeid: null,
                              bio: null,
                              modename: null,
                              prompt: updatedPrompts,
                              qualityId: null,
                              languagesId: null,
                            );
                      },
                      child: const Text('Save All'),
                    ),
                  ],
                ),
              )
            else if (prompts.length < 3)
              GestureDetector(
                onTap: () {
                  setState(() {
                    isAddingPrompt = true;
                    _promptController.clear();
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Add Prompt',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Icon(Icons.add, size: 20),
                    ],
                  ),
                ),
              ),
            if (isAddingPrompt)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: TextField(
                  controller: _promptController,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Write your prompt...',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () {
                        final promptText = _promptController.text.trim();
                        if (promptText.isNotEmpty) {
                          setState(() {
                            localPrompts = [
                              ...prompts.map((p) => p is Prompts
                                  ? {"prompt": p.prompt}
                                  : {"prompt": p['prompt']}),
                              {"prompt": promptText},
                            ];
                            _promptController.clear();
                            isAddingPrompt = false;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ],
  );
}


  Widget _buildBioSection() {
  final userData = ref.watch(loginProvider);
  final user = userData.data?.isNotEmpty == true ? userData.data![0].user : null;
  final String? serverHeadline = user?.headLine;

 final String headline = isEditing
    ? _bioController.text.trim()
    : (serverHeadline?.trim() ?? '');


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
      if (isEditing)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color.fromARGB(255, 151, 144, 144)),
          ),
          child: TextField(
            controller: _bioController,
            maxLines: 5,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            decoration: InputDecoration(
              hintText: 'Write about you',
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: const Icon(Icons.check, color: Color.fromARGB(255, 33, 34, 33)),
                onPressed: () async {
                  final updatedHeadline = _bioController.text.trim();

                  try {
                    await ref.read(loginProvider.notifier).updateProfile(
                          image: null,
                          modeid: null,
                          bio: updatedHeadline,
                          modename: null,
                          prompt: null,
                          qualityId: null,
                        );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Headline updated successfully!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to upload headline: $e')),
                    );
                  }

                  setState(() {
                    isEditing = false;
                  });
                },
              ),
            ),
          ),
        )
      else
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  headline.isNotEmpty ? headline : 'Write about you',
                  style: TextStyle(
                    fontSize: 16,
                    color: headline.isNotEmpty ? Colors.black87 : Colors.black54,
                    fontStyle: headline.isNotEmpty ? FontStyle.normal : FontStyle.italic,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 15),
                onPressed: () {
                  setState(() {
                    isEditing = true;
                    _bioController.text = serverHeadline ?? '';
                  });
                },
              ),
            ],
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
          border: Border.all(color: const Color.fromARGB(255, 106, 104, 104), width: 1),
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
    final userData = ref.watch(loginProvider);
     final user =
          userData.data?.isNotEmpty == true ? userData.data![0].user : null;
          Work? work = user!.work;
          final workDisplayText = work != null? work.title! + ('at ${work.company}'): 'Add';
          Education? education = user.education;
          final educationText = education != null? education.institution! + ('in ${education.gradYear}'): 'Add';
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
        _buildProfileItem(Icons.work_outline, 'Work',
        //  workDisplayText,
        workDisplayText ,
         onTap: () {
         
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => OccupationScreen()));
        }),
        _buildProfileItem(Icons.school_outlined, 'Education', educationText , onTap: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => EducationScreen()));
        }),
        _buildProfileItem(Icons.person_outline, 'Gender', selectedGender ,
            onTap: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => UpdateGenderScreen()));
        }),
        _buildProfileItem(Icons.location_on_outlined, 'Location', 'Add',
            onTap: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => CitySearchPage()));
        }),
        _buildProfileItem(Icons.home_outlined, 'Hometown', 'Add', onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeTownSelectionScreen()));
        }),
      ],
    );
  }

  Widget _buildMoreAboutYouSection() {
     final userData = ref.watch(loginProvider);
     final user = userData.data?.isNotEmpty == true ? userData.data![0].user : null;
  
    final List<LookingFor> lookingfor = user?.lookingFor?? [].first;
    final List<Religions> religion = user?.religions?? [];
    final List<Kids> kids = user?.kids?? [];
    final List<Drinking> drinking = user?.drinking?? [];
    final List<StarSign> starsign = user?.starSign?? [].first;
   

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
        _buildProfileItem(
          Icons.search,
          'Looking For',
           lookingfor as String?,
           onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LookingForScreen()),
            );
            if (result != null) {
              setState(() {
                selectedLooking = result;
              });
            }
          },
        ),
        _buildProfileItem(Icons.favorite_border, 'Relationship',
         'Add',
            onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RelationshipScreen()),
          );
        }),
        _buildProfileItem(Icons.child_care, 'Have A Kids', 
        kids as String?,
            onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HaveKidsScreen()),
          );
          if (result != null) {
            setState(() {
              selectedkid = result;
            });
          }
        }),
        // _buildProfileItem(Icons.smoking_rooms_outlined, 'Smoking', 'Add',
        //     onTap: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => SmokingScreen()),
        //   );
        // }),
        _buildProfileItem(
            Icons.local_drink_outlined, 'Drinking',drinking as String?,
            onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DrinkingScreen()),
          );
          if (result != null) {
            setState(() {
              selectedDrink = result;
            });
          }
        }),
        _buildProfileItem(Icons.fitness_center_outlined, 'Exercise', 'Add' ,
            onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ExerciseScreen()),
          );
        }),
        _buildProfileItem(Icons.location_city_outlined, 'New To Area', 'Add',
            onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewToAreaScreen()),
          );
        }),
        _buildProfileItem(Icons.star_border, 'Star Sign', starsign as String?, onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StarSignScreen()),
          );
        }),
        _buildProfileItem(
            Icons.place_outlined, 'Religion', religion as String?,
            onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReligionScreen()),
          );
          if (result != null) {
            setState(() {
              selectedReligion = result;
            });
          }
        }),
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
                  builder: (context) =>
                      const GenderPronounsScreen(), // your target screen
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
                Icon(Icons.arrow_forward_ios,
                    color: Colors.grey[400], size: 16),
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
              InkWell(
  onTap: () {
    // Navigate to another screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LanguageSelectionScreen()),
    );
  },
  child: Icon(
    Icons.arrow_forward_ios,
    color: Colors.grey[400],
    size: 16,
  ),
),

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

  Widget _buildProfileItem(IconData icon, String title, String? value,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 16),
              Expanded(
                  child: Text(
                title,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )),
              Text(value!,
                  style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
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
