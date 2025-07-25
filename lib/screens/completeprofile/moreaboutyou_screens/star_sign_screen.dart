import 'package:dating/provider/loginProvider.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/religion_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating/provider/loader.dart';
import '../../../provider/moreabout/starsignprovider.dart';

class StarSignScreen extends ConsumerStatefulWidget {
  const StarSignScreen({super.key});

  @override
  ConsumerState<StarSignScreen> createState() => _StarSignScreenState();
}

class _StarSignScreenState extends ConsumerState<StarSignScreen> 
    with TickerProviderStateMixin {
  List<int> selectedOptionsIds = [];
  List<String> selectedOptionsNames = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    // Fetch star signs when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(starSignProvider.notifier).getStarsign();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleOption(int id, String name) {
    setState(() {
      if (selectedOptionsIds.contains(id)) {
        selectedOptionsIds.remove(id);
        selectedOptionsNames.remove(name);
      } else {
        selectedOptionsIds.add(id);
        selectedOptionsNames.add(name);
      }
    });
  }

  void _proceedToNext()async {
    if (selectedOptionsIds.isNotEmpty) {
      // Here you can save the selected star signs
      print('Selected star signs: $selectedOptionsNames');
      print('Selected IDs: $selectedOptionsIds');
      
      // Navigate to next screen
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const ReligionScreen(),
      //   ),
      // );
      try {
                  await ref.read(loginProvider.notifier).updateProfile(causeId: null,
                                                                      image: null, 
                                                                      modeid: null,
                                                                      bio: null, 
                                                                      modename:null, 
                                                                      prompt:null,
                                                                      qualityId: null,
                                                                      starsignId:selectedOptionsIds);
                  print('Starsign updated');

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Starsign updated successfully!')),
                  );

                 
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to upload starsign: $e')),
                  );
 }
    } else {
      // Show snackbar if nothing selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one zodiac sign'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final starSignState = ref.watch(starSignProvider);
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        // actions: [
        //   TextButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => const ReligionScreen(),
        //         ),
        //       );
        //     },
        //     child: const Text(
        //       'Skip',
        //       style: TextStyle(
        //         fontSize: 16,
        //         fontWeight: FontWeight.w500,
        //         color: Colors.grey,
        //       ),
        //     ),
        //   ),
        //   const SizedBox(width: 16),
        // ],
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress indicator
                // Container(
                //   height: 4,
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //     color: Colors.grey[300],
                //     borderRadius: BorderRadius.circular(2),
                //   ),
                //   child: FractionallySizedBox(
                //     alignment: Alignment.centerLeft,
                //     widthFactor: 0.4, // Adjust based on your progress
                //     child: Container(
                //       decoration: BoxDecoration(
                //         gradient: const LinearGradient(
                //           colors: [Color(0xffB2D12E), Color(0xFF8BC34A)],
                //         ),
                //         borderRadius: BorderRadius.circular(2),
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 32),
                
                // Title with icon
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xffB2D12E), Color(0xFF8BC34A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8BC34A).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'What\'s Your Zodiac Sign?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Text(
                          //   'Select your zodiac sign to help us find better matches',
                          //   style: TextStyle(
                          //     fontSize: 14,
                          //     color: Colors.grey[600],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Selected count
                if (selectedOptionsIds.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8BC34A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF8BC34A).withOpacity(0.3)),
                      ),
                      child: Text(
                        '${selectedOptionsIds.length} selected',
                        style: const TextStyle(
                          color: Color(0xFF8BC34A),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Content Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildContent(starSignState, isLoading),
            ),
          ),
          
          // Bottom Section with Continue Button
          if (selectedOptionsIds.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _proceedToNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xffB2D12E), Color(0xFF8BC34A)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(dynamic starSignState, bool isLoading) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8BC34A)),
                  strokeWidth: 3,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Loading zodiac signs...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    // Check if API call was successful
    if (starSignState.success != true || starSignState.data == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              starSignState.message ?? 'Failed to load zodiac signs',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(starSignProvider.notifier).getStarsign();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8BC34A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    final starSigns = starSignState.data;

    if (starSigns == null || starSigns.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No zodiac signs available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    _animationController.forward();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: starSigns.length,
        itemBuilder: (context, index) {
          final starSign = starSigns[index];
          final id = starSign.id ?? 0;
          final name = starSign.name ?? 'Unknown';
          final isSelected = selectedOptionsIds.contains(id);
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: AnimatedScale(
              scale: isSelected ? 0.98 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: GestureDetector(
                onTap: () => toggleOption(id, name),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xffB2D12E), Color(0xFF8BC34A)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected 
                          ? Colors.transparent 
                          : Colors.grey.withOpacity(0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected 
                            ? const Color(0xFF8BC34A).withOpacity(0.3)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: isSelected ? 15 : 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      // Zodiac icon
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Colors.white.withOpacity(0.2)
                              : const Color(0xFF8BC34A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.star,
                          size: 18,
                          color: isSelected ? Colors.white : const Color(0xFF8BC34A),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Name
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      // Selection indicator
                      if (isSelected)
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 16,
                            color: Color(0xFF8BC34A),
                          ),
                        ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Model handles data access properly now