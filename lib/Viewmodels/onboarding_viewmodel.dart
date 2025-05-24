import 'package:flutter/material.dart';
// import 'package:your_app/models/user_profile_model.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController controller = PageController();
  int currentIndex = 0;

  // UserProfileModel userProfile = UserProfileModel(
  //   firstName: '',
  //   birthday: DateTime.now(),
  //   gender: '',
  //   showGenderOnProfile: true,
  //   purpose: '',
  // );

  // List of pages for the onboarding process
  List<Widget> get pages => [
        _buildIntroPage(),
        _buildGenderDisplayPage(),
        _buildGenderSelectionPage(),
        _buildPhotoUploadPage(),
        _buildPurposeSelectionPage(),
        _buildFinalInfoPage(),
      ];

  // Move to the next page
  void nextPage() {
    if (currentIndex < pages.length - 1) {
      controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  // Update gender (called when a user selects gender)
  void updateGender(String gender) {
    // userProfile.gender = gender;
    notifyListeners();
  }

  // Update the purpose (called when a user selects the purpose)
  void updatePurpose(String purpose) {
    // userProfile.purpose = purpose;
    notifyListeners();
  }

  // Toggle the visibility of gender on profile
  void toggleGenderVisibility(bool value) {
    // userProfile.showGenderOnProfile = value;
    notifyListeners();
  }

  // Pages for onboarding process
  Widget _buildIntroPage() {
    return Center(child: Text('Welcome to the App!'));
  }

  Widget _buildGenderDisplayPage() {
    return Center(child: Text('Show gender on profile?'));
  }

  Widget _buildGenderSelectionPage() {
    return Center(child: Text('Select your gender'));
  }

  Widget _buildPhotoUploadPage() {
    return Center(child: Text('Upload your photo'));
  }

  Widget _buildPurposeSelectionPage() {
    return Center(child: Text('Select your purpose'));
  }

  Widget _buildFinalInfoPage() {
    return Center(child: Text('Almost done!'));
  }
}
