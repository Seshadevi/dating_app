import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:your_app/viewmodels/onboarding_viewmodel.dart';
import 'package:dating/Viewmodels/onboarding_viewmodel.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingViewModel(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Consumer<OnboardingViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: LinearProgressIndicator(
                    value: (viewModel.currentIndex + 1) / viewModel.pages.length,
                    color: Colors.blue,  // You can change the color as per your design
                    backgroundColor: Colors.grey.shade200,
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: PageView(
                    controller: viewModel.controller,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      viewModel.currentIndex = index;
                      viewModel.notifyListeners();
                    },
                    children: viewModel.pages,
                  ),
                ),
                GestureDetector(
                  onTap: viewModel.nextPage,  // Move to the next page
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Icon(Icons.arrow_forward, size: 40, color: Colors.blue),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
