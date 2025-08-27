import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/model/loginmodel.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/screens/completeprofile/causeScreen.dart';
import 'package:dating/screens/completeprofile/id_verification_screen.dart';
import 'package:dating/screens/completeprofile/interests.dart';
import 'package:dating/screens/completeprofile/lifeBadgesScreen.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/drinking_screen.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/exercise_screen.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/kids_screen.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/languagesscreen.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/new_to_area_screen.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/relationship_screen.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/religion_screen.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/smoking_screen.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/star_sign_screen.dart';
import 'package:dating/screens/completeprofile/profile_strength_detailScreen.dart';
import 'package:dating/screens/completeprofile/pronoun_screen.dart';
import 'package:dating/screens/completeprofile/qualities.dart';
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
  List<String> localPrompts = [];
  int? editingPromptIndex; // Track which prompt is being edited
  TextEditingController _editPromptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

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
  final GlobalKey _workSectionKey = GlobalKey();

  final ImagePicker _picker = ImagePicker();
  // final TextEditingController _bioController = TextEditingController();
  // String selectedGender = 'Man';
   @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == 'work_section') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final contextForSection = _workSectionKey.currentContext;
        if (contextForSection != null) {
          Scrollable.ensureVisible(
            contextForSection,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          debugPrint("✅ Scrolled to Work Section");
        } else {
          debugPrint("⚠ Work section not found in widget tree");
        }
      });
    }
  }
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

          final userkidList = user.kids;
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
            userReligion = userReligionList[0].religion.toString();
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
      backgroundColor: DatingColors.white,
      appBar: AppBar(
        backgroundColor: DatingColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: DatingColors.black),
          onPressed: () => Navigator.pushNamed(context, '/custombottomnav'),
        ),
        title: Text(
          'everquid ${user?.mode ?? ''}',
          style: TextStyle(
            color: DatingColors.black,
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
            SizedBox(height: 15),

            // Photos and Videos Section
            _buildPhotosVideosSection(),
            SizedBox(height: 15),

            // Get Verified Section
            _buildGetVerifiedSection(),
            SizedBox(height: 15),

            // My Life Section
            _buildQualitiesSection(context),
            SizedBox(height: 15),

            // Interests Section
            _buildInterestsSection(context),
            SizedBox(height: 15),
            // Interests Section
            _buildCausesSection(context),
            SizedBox(height: 15),

            // Prompts Section
            _buildPromptsSection(context),
            SizedBox(height: 15),

            // Bio Section
            _buildBioSection(),
            SizedBox(height: 15),

            // About You Section
            _buildAboutYouSection(),
            SizedBox(height: 15),

            // More About You Section
            _buildMoreAboutYouSection(),
            SizedBox(height: 15),

            // Pronouns Section
            _buildPronounsSection(),
            SizedBox(height: 15),

            // Languages Section
            _buildLanguagesSection(),
            SizedBox(height: 15),

            // Connected Accounts Section
            _buildConnectedAccountsSection(),
            SizedBox(height: 15),
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
            color: DatingColors.black,
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
                colors: [DatingColors.primaryGreen, DatingColors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.all(2), // This simulates the border thickness
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: DatingColors.white,
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
                      color: DatingColors.black,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios,
                      color: DatingColors.lightgrey, size: 16),
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
      final profilePics = user.profilePics;
      for (int i = 0; i < profilePics!.length && i < 6; i++) {
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
          'Select Photos',
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
            color: DatingColors.lightgrey,
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
              colors: [DatingColors.primaryGreen, DatingColors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(
              color: image != null ? DatingColors.surfaceGrey : DatingColors.white,
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
                            color: DatingColors.darkGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: DatingColors.white,
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
                      color: DatingColors.lightgrey,
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
                  leading: Icon(Icons.delete, color: DatingColors.errorRed),
                  title:
                      Text('Remove Photo', style: TextStyle(color: DatingColors.errorRed)),
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
      if (source == ImageSource.gallery) {
        // Pick multiple images from gallery
        final List<XFile>? pickedFiles = await _picker.pickMultiImage();
        if (pickedFiles != null && pickedFiles.isNotEmpty) {
          final files =
              pickedFiles.take(6).map((xfile) => File(xfile.path)).toList();

          setState(() {
            for (int i = 0; i < files.length; i++) {
              selectedImages[i] = FileImage(files[i]);
            }
            // Clear remaining slots if less than 6
            for (int i = files.length; i < 6; i++) {
              selectedImages[i] = null;
            }
          });

          await _uploadProfileImages(files);
        }
        return;
      }

      // For camera pick, single image as before
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        setState(() {
          selectedImages[index] = FileImage(imageFile);
        });
        await _uploadProfileImages([imageFile]);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image(s): $e')),
      );
    }
  }

  Future<void> _uploadProfileImages(List<File> imageFiles) async {
    try {
      await ref.read(loginProvider.notifier).updateProfile(
            image: imageFiles,
            modeid: null,
            bio: null,
            modename: null,
            prompt: null,
            qualityId: null,
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image(s) updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image(s): $e')),
      );
    }
  }

  void _uploadProfileImage(List<File> imageFile, int index) async {
    print('Uploading image at index $index: ${imageFile.length}');

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

      print('Uploading image at index $index: ${imageFile.length}');

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
                color: DatingColors.middlegrey, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Get Verified',
                style: TextStyle(
                  fontSize: 16,
                  color: DatingColors.black,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: DatingColors.surfaceGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Not ID Verified',
                style: TextStyle(
                  fontSize: 12,
                  color: DatingColors.middlegrey,
                ),
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, color: DatingColors.lightgrey, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildQualitiesSection(BuildContext context) {
    final userData = ref.watch(loginProvider);
    final user =
        userData.data?.isNotEmpty == true ? userData.data![0].user : null;
    final List<Qualities> qualities =
        List<Qualities>.from(user?.qualities ?? []);
    print('qualities...........$qualities');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Qualities',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: DatingColors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Get specific about the things you love.',
          style: TextStyle(
            fontSize: 14,
            color: DatingColors.lightgrey,
          ),
        ),
        const SizedBox(height: 16),

        /// Entire content inside one Card-like container
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: DatingColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DatingColors.mediumGrey),
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
                      Icon(Icons.bookmark_border,
                          size: 20, color: DatingColors.black),
                      SizedBox(width: 8),
                      Text(
                        'Favorite quality',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios,
                          size: 16, color: DatingColors.lightgrey),
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
                      final name = quality.name ?? '';
                      final emoji = '🌟';
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: DatingColors.surfaceGrey,
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
                      top: BorderSide(color: DatingColors.surfaceGrey),
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
    final List<Interests> interests =
        List<Interests>.from(user?.interests ?? []);
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
            color: DatingColors.lightgrey,
          ),
        ),
        const SizedBox(height: 16),

        // ✅ Entire content inside one Card-like container
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: DatingColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DatingColors.mediumGrey),
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
                          size: 20, color: DatingColors.black),
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
                          size: 16, color: DatingColors.lightgrey),
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
                    children: interests.map<Widget>((interest) {
                      final name = interest.interests;
                      final emoji = '🌟';
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: DatingColors.surfaceGrey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(emoji),
                            const SizedBox(width: 6),
                            Text(
                              name as String,
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
                      'id': interest.id,
                      'interests': interest.interests,
                      'emoji': '🌟' // ✅ Include emoji if you use it later
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
                      top: BorderSide(color: DatingColors.surfaceGrey),
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
    final user =
        userData.data?.isNotEmpty == true ? userData.data![0].user : null;
    final List<CausesAndCommunities> causes =
        List<CausesAndCommunities>.from(user?.causesAndCommunities ?? []);
    print('causes................$causes');
    print('Raw user causes: ${user?.causesAndCommunities}');
    print('Raw JSON from API: ${userData.data?[0].user?.toJson()}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Causes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: DatingColors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Get specific about the things you love.',
          style: TextStyle(
            fontSize: 14,
            color: DatingColors.lightgrey,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: DatingColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DatingColors.mediumGrey),
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
                      Icon(Icons.bookmark_border,
                          size: 20, color: DatingColors.black),
                      SizedBox(width: 8),
                      Text(
                        'Favorite causes',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios,
                          size: 16, color: DatingColors.lightgrey),
                    ],
                  ),
                ),
              ),

              // Selected causes chips
              if (causes.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: causes.map<Widget>((cause) {
                      final name = cause.causesAndCommunities ?? '';
                      final emoji = '🌟';
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: DatingColors.surfaceGrey,
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: DatingColors.surfaceGrey),
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
    final user =
        userData.data?.isNotEmpty == true ? userData.data![0].user : null;

    // Always store and work with List<String>
    final List<String> serverPrompts =
        user?.prompts?.map((p) => p.prompt).toList().cast<String>() ?? [];

    final List<String> prompts =
        localPrompts.isNotEmpty ? localPrompts : serverPrompts;

    List<TextEditingController> _editPromptControllers = List.generate(
      3,
      (i) => TextEditingController(
        text: i < prompts.length ? prompts[i] : '',
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prompts',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: DatingColors.black),
        ),
        const SizedBox(height: 8),
        const Text(
          'Add personality to your profile with prompts.',
          style: TextStyle(fontSize: 14, color: DatingColors.lightgrey),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: DatingColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DatingColors.mediumGrey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (editingPromptIndex == null)
                ...prompts.asMap().entries.map((entry) {
                  final promptText = entry.value;

                  return Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: DatingColors.lightgrey),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            promptText,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: DatingColors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: DatingColors.black, size: 15),
                          onPressed: () {
                            setState(() {
                              editingPromptIndex = 0;
                              _editPromptControllers = List.generate(
                                3,
                                (i) => TextEditingController(
                                  text: i < prompts.length ? prompts[i] : '',
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: DatingColors.lightGreen,
                        border: Border(
                          bottom: BorderSide(color: DatingColors.surfaceGrey),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                              .take(3)
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      border:
                          Border(top: BorderSide(color: DatingColors.surfaceGrey)),
                    ),
                    child: Row(
                      children: const [
                        Expanded(
                          child: Text(
                            'Add Prompt',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Icon(Icons.add, size: 20),
                      ],
                    ),
                  ),
                ),
              if (isAddingPrompt)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: DatingColors.lightGreen,
                    border:
                        Border(top: BorderSide(color: DatingColors.surfaceGrey)),
                  ),
                  child: TextField(
                    controller: _promptController,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 15, color: DatingColors.black),
                    decoration: InputDecoration(
                      hintText: 'Write your prompt...',
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.check, color: DatingColors.primaryGreen),
                        onPressed: () {
                          final promptText = _promptController.text.trim();
                          if (promptText.isNotEmpty) {
                            setState(() {
                              localPrompts = [
                                ...prompts,
                                promptText,
                              ].take(3).toList(); // limit to 3
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
    final user =
        userData.data?.isNotEmpty == true ? userData.data![0].user : null;
    final String? serverHeadline = user?.headLine;

    final String headline =
        isEditing ? _bioController.text.trim() : (serverHeadline?.trim() ?? '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bio',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: DatingColors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Write a few short words about you',
          style: TextStyle(
            fontSize: 14,
            color: DatingColors.middlegrey,
          ),
        ),
        const SizedBox(height: 10),
        if (isEditing)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            decoration: BoxDecoration(
              color:  DatingColors.white,
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: DatingColors.middlegrey),
            ),
            child: TextField(
              controller: _bioController,
              maxLines: 5,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(fontSize: 12, color: DatingColors.black),
              decoration: InputDecoration(
                hintText: 'Write about you',
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check,
                      color: DatingColors.black),
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
                        const SnackBar(
                            content: Text('Headline updated successfully!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Failed to upload headline: $e')),
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
              color: DatingColors.surfaceGrey,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: DatingColors.mediumGrey),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    headline.isNotEmpty ? headline : 'Write about you',
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          headline.isNotEmpty ? DatingColors.black : DatingColors.black,
                      fontStyle: headline.isNotEmpty
                          ? FontStyle.normal
                          : FontStyle.italic,
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
          color: DatingColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: DatingColors.mediumGrey, width: 1),
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
            Icon(Icons.arrow_forward_ios, color: DatingColors.middlegrey, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutYouSection() {
  final userData = ref.watch(loginProvider);
  final user = userData.data?.isNotEmpty == true ? userData.data![0].user : null;

  final workTitle = user?.work?.title ?? '';
  final workCompany = user?.work?.company ?? '';
  final workDisplayText = (workTitle.isNotEmpty || workCompany.isNotEmpty)
      ? '$workTitle${workCompany.isNotEmpty ? ' at $workCompany' : ''}'
      : 'Add';
 Education? education = user?.education;
    final educationText = education != null
        ? education.institution! + (' in ${education.gradYear}')
        : 'Add';

  final selectGender = user?.gender ?? 'Add';

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'About You',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: DatingColors.black),
      ),
      const SizedBox(height: 16),
      _buildProfileItem(Icons.work_outline, 'Work', workDisplayText, onTap: () {
        Navigator.pushNamed(context, '/occupationscreen');
      }),
      _buildProfileItem(Icons.school_outlined, 'Education', educationText, onTap: () {
        Navigator.pushNamed(context, '/educationscreen');
      }),
      _buildProfileItem(Icons.person_outline, 'Gender', selectGender, onTap: () {
        Navigator.pushNamed(context, '/updategenderscreen');
      }),
      _buildProfileItem(Icons.location_on_outlined, 'Location', 'Add', onTap: () {
        Navigator.pushNamed(context, '/citysearchpage');
      }),
      _buildProfileItem(Icons.home_outlined, 'Hometown', 'Add', onTap: () {
        Navigator.pushNamed(context, '/hometownscreen');
      }),
    ],
  );
}

Widget _buildMoreAboutYouSection() {
  final userData = ref.watch(loginProvider);
  final user = userData.data?.isNotEmpty == true ? userData.data![0].user : null;

  final lookingfor = (user?.lookingFor?.isNotEmpty ?? false)
      ? (user?.lookingFor?.first.value ?? 'Add')
      : 'Add';

  final religion = (user?.religions?.isNotEmpty ?? false)
      ? (user?.religions?.first.religion ?? 'Add')
      : 'Add';

  final kids = (user?.kids?.isNotEmpty ?? false)
      ? (user?.kids?.first.kids ?? 'Add')
      : 'Add';

  final drinking = (user?.drinking?.isNotEmpty ?? false)
      ? (user?.drinking?.first.preference ?? 'Add')
      : 'Add';

  final  smoking = (user?.smoking?.isNotEmpty ?? false)
      ? user?.smoking
      : 'Add';
  // final  height = (user?.height) != null
  //     ? user?.height
  //     : 'Add';
  
  // final  newtoarea = (user?.newToArea?.isNotEmpty ?? false)
  //     ? user?.newToArea
  //     : 'Add';
  // final  relationship = (user?.relationship) != null
  //     ? user?.relationship
  //     : 'Add';
  final  educationLevel = (user?.educationLevel?.isNotEmpty ?? false)
      ? user?.educationLevel
      : 'Add';
  final  havekids = (user?.haveKids?.isNotEmpty ?? false)
      ? user?.haveKids
      : 'Add';
  final  industry = (user?.industries?.isNotEmpty ?? false)
      ? user?.industries
      : 'Add';
  final  experiences = (user?.experiences?.isNotEmpty ?? false)
      ? user?.experiences
      : 'Add';
      

  final starsign = user?.starSign?.name ?? 'Add';
  final exercise = user?.exercise ?? 'Add';
    final  height = user?.height
      ??'Add';

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'More About You',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      const SizedBox(height: 8),
      Text(
        'Share More Details About Yourself Are Curious About',
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
      const SizedBox(height: 16),
      _buildProfileItem(Icons.place_outlined, 'Height', 'add', onTap: () {
        Navigator.pushNamed(context,'/heightscreenprofile');
        
      }),
      _buildProfileItem(Icons.search, 'Looking For', lookingfor, onTap: () {
        Navigator.pushNamed(context,'/lookingforscreen');
      }),
      _buildProfileItem(Icons.favorite_border, 'Relationship', 'add', onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => RelationshipScreen()));
      }),
      _buildProfileItem(Icons.child_care, 'Kids', kids, onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => HaveKidsScreen()));
      }),
      _buildProfileItem(Icons.smoking_rooms_outlined, 'Smoking', smoking!, onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => SmokingScreen()));
      }),
      _buildProfileItem(Icons.local_drink_outlined, 'Drinking', drinking, onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => DrinkingScreen()));
      }),
      _buildProfileItem(Icons.fitness_center_outlined, 'Exercise', exercise, onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ExerciseScreen()));
      }),
      _buildProfileItem(Icons.location_city_outlined, 'New To Area', 'Add', onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => NewToAreaScreen()));
      }),
      _buildProfileItem(Icons.star_border, 'Star Sign', starsign, onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => StarSignScreen()));
      }),
      _buildProfileItem(Icons.place_outlined, 'Religion', religion, onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ReligionScreen()));
      }),
      // ====================================
      _buildProfileItem(Icons.business_sharp, 'Experience', 'add', onTap: () {
        Navigator.pushNamed(context, '/experiencescreen');
      }),
      _buildProfileItem(Icons.factory, 'Industries', 'add', onTap: () {
        Navigator.pushNamed(context, '/industryscreen');
      }),
      _buildProfileItem(Icons.school, 'EducationLevel', educationLevel!, onTap: () {
        Navigator.pushNamed(context, '/educaationlevelscreen');
      }),
      _buildProfileItem(Icons.baby_changing_station, 'Have Kids', havekids!, onTap: () {
        Navigator.pushNamed(context, '/havekidscreen');
      }),
      
    ],
  );
}


  Widget _buildPronounsSection() {
    final userData = ref.watch(loginProvider);
    final user =
        userData.data?.isNotEmpty == true ? userData.data![0].user : null;
    final pronoun = user?.pronouns;
    return SingleChildScrollView(
      child: Column(
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
          if (pronoun!=null)
  Chip(
    label: Text(pronoun),
    backgroundColor: DatingColors.primaryGreen,
  )
else
  Text(
    'No pronouns added yet.',
    style: TextStyle(color: DatingColors.middlegrey),
  ),


          SizedBox(height: 6),
          // SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: DatingColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: DatingColors.mediumGrey, width: 1),
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
                      'Select Your Pronouns',
                      style: TextStyle(
                        fontSize: 16,
                        color: DatingColors.black,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      color: DatingColors.lightgrey, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguagesSection() {
    final userData = ref.watch(loginProvider);
    final user =
        userData.data?.isNotEmpty == true ? userData.data![0].user : null;

    // Make sure to handle type casting properly
    //  final List<Language> languages = (user?.spokenLanguages != null)
    //   ? (user!.spokenLanguages )
    final List<Language> languages =
        List<Language>.from(user?.spokenLanguages ?? []);
    print('languages........$languages');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Languages',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: DatingColors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Choose The Languages You Know',
          style: TextStyle(
            fontSize: 14,
            color: DatingColors.middlegrey,
          ),
        ),
        SizedBox(height: 6),

        // Show selected languages here
        if (languages.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: languages
                .map((lang) => Chip(
                      label: Text(lang.name ?? ''),
                      backgroundColor: DatingColors.primaryGreen,
                    ))
                .toList(),
          )
        else
          Text(
            'No languages added yet.',
            style: TextStyle(color: DatingColors.lightgrey),
          ),

        SizedBox(height: 6),

        // Add Your Languages Row
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: DatingColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DatingColors.mediumGrey, width: 1),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LanguageSelectionScreen(),
                    ),
                  );
                },
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: DatingColors.lightgrey,
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
            color: DatingColors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Show Off Your Favourite Music',
          style: TextStyle(
            fontSize: 14,
            color: DatingColors.middlegrey,
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: DatingColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DatingColors.mediumGrey, width: 1),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: DatingColors.darkGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.music_note,
                      color: DatingColors.white,
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
                        color: DatingColors.black,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      color: DatingColors.middlegrey, size: 16),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Show Your Recently Played Songs On Your Profile And Allow The Songs You Listen To Recommendation Conversation Starters Based On Shared Music Tastes',
                style: TextStyle(
                  fontSize: 14,
                  color: DatingColors.middlegrey,
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
                      color: DatingColors.primaryGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.music_note,
                      color: DatingColors.middlegrey,
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
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: DatingColors.middlegrey)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(icon, color: DatingColors.black),
              const SizedBox(width: 16),
              Expanded(
                  child: Text(
                title,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )),
              Text(value,style: const TextStyle(fontSize: 16, color: DatingColors.middlegrey)),
              const Icon(Icons.arrow_forward_ios, size: 16, color: DatingColors.middlegrey),
            ],
          ),
        ),
      ),
    );
  }

  // void _showGenderDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Select Gender'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             _buildGenderOption('Man'),
  //             _buildGenderOption('Woman'),
  //             _buildGenderOption('Non-binary'),
  //             _buildGenderOption('Other'),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildGenderOption(String gender) {
  //   return RadioListTile<String>(
  //     title: Text(gender),
  //     value: gender,
  //     groupValue: selectedGender,
  //     onChanged: (String? value) {
  //       setState(() {
  //         selectedGender = value!;
  //       });
  //       Navigator.pop(context);
  //     },
  //   );
  // }
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
