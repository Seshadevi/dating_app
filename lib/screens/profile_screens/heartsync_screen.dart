import 'package:dating/model/peoples_all_model.dart';
import 'package:dating/provider/peoples_all_provider.dart';
import 'package:dating/screens/profile_screens/profile_bottomNavigationbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'dart:math' as math;

class MyHeartsyncPage extends ConsumerStatefulWidget {
  const MyHeartsyncPage({super.key});

  @override
  ConsumerState<MyHeartsyncPage> createState() => _MyHeartsyncPageState();
}

class _MyHeartsyncPageState extends ConsumerState<MyHeartsyncPage> {
  bool isLoadingMore = false;
  final CardSwiperController controller = CardSwiperController();
  List<Users> allUsers = [];
  int currentCardIndex = 0;
  
  // Current user location (you'll need to get this from your login model/API)
  double? currentUserLatitude;
  double? currentUserLongitude;
   final ScrollController _scrollController = ScrollController();
  final GlobalKey _imageKey = GlobalKey();
  bool _hideFixedImage = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(peoplesProvider.notifier).getPeoplesAll();
      _getCurrentUserLocation(); // Get current user location
       _scrollController.addListener(_checkVisibility);
     
    });
  }
  void _checkVisibility() {
    // Check if scrollable image is visible
    final box = _imageKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      final position = box.localToGlobal(Offset.zero).dy;
      final screenHeight = MediaQuery.of(context).size.height;

      if (position > 0 && position < screenHeight) {
        // Image is on screen → hide fixed one
        if (!_hideFixedImage) {
          setState(() {
            _hideFixedImage = true;
          });
        }
      } else {
        // Image is off screen → show fixed one
        if (_hideFixedImage) {
          setState(() {
            _hideFixedImage = false;
          });
        }
      }
    }
  }

  // Method to get current user location from your login model/API
  void _getCurrentUserLocation() {
    // TODO: Replace with actual API call to get current user location
    // Example:
    // final currentUser = ref.read(currentUserProvider);
    // currentUserLatitude = currentUser.latitude;
    // currentUserLongitude = currentUser.longitude;
    
    // For now, using dummy data - replace with your actual implementation
    currentUserLatitude = 17.3850; // Hyderabad latitude
    currentUserLongitude = 78.4867; // Hyderabad longitude
  }

  // Calculate distance between two coordinates
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    
    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }
  @override
void didUpdateWidget(covariant MyHeartsyncPage oldWidget) {
  super.didUpdateWidget(oldWidget);
  _checkVisibility(); // ✅ Recheck visibility when widget updates
}


  String _getDistanceText(Users user) {
    if (currentUserLatitude == null || currentUserLongitude == null) {
      return "Location not available";
    }
    
    // TODO: Get user's latitude and longitude from the user model
    // For now, using dummy data - replace with actual user coordinates
    double userLat = user.latitude ?? 17.4065; // Default to Hyderabad if not available
    double userLon = user.longitude ?? 78.4772;
    
    double distance = _calculateDistance(
      currentUserLatitude!,
      currentUserLongitude!,
      userLat,
      userLon,
    );
    
    if (distance < 1) {
      return "${(distance * 1000).round()} meters away";
    } else {
      return "${distance.toStringAsFixed(1)} km away";
    }
  }

  @override
  Widget build(BuildContext context) {
    final peoplesModel = ref.watch(peoplesProvider);
    final users = peoplesModel.users ?? [];
     
    
    // Update allUsers when new data comes
    if (users.isNotEmpty && allUsers.isEmpty) {
      allUsers = List.from(users);
    }

    print("PeoplesModel: ${peoplesModel}");
    print("Users: ${peoplesModel.users}");

    return Scaffold(
      backgroundColor: Colors.white,
      body: allUsers.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("Loading users...", style: TextStyle(fontSize: 18, color: Colors.grey))
                ],
              ),
            )
          : Column(
              children: [
                // Custom AppBar
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_back, color: Colors.black),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'Heart Sync',
                            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const Icon(Icons.more_vert, color: Colors.black),
                      ],
                    ),
                  ),
                ),
                
                // Full Screen Card Content
                Expanded(
                  child: Stack(
                    children: [
                      CardSwiper(
                        controller: controller,
                        cardsCount: allUsers.length,
                        numberOfCardsDisplayed: 1,
                        isLoop: true,
                        allowedSwipeDirection: const AllowedSwipeDirection.symmetric(horizontal: true),
                        backCardOffset: const Offset(0, 0),
                        padding: EdgeInsets.zero,
                        onSwipe: (previousIndex, currentIndex, direction) {
                          setState(() {
                            currentCardIndex = currentIndex ?? 0;
                          });
                          
                          if (currentIndex != null && currentIndex >= allUsers.length - 3 && !isLoadingMore) {
                            _loadMoreUsers();
                          }
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                  _checkVisibility(); // ✅ This ensures visibility is rechecked after card changes
                                });

                          
                          if (direction == CardSwiperDirection.left) {
                            _handleReject(previousIndex);
                          } else if (direction == CardSwiperDirection.right) {
                            _handleLike(previousIndex);
                          }
                          
                          return true;
                        },
                        cardBuilder: (BuildContext context, int index, int hOffset, int vOffset) {
                          if (index >= allUsers.length) return Container();
                          return _buildUserCard(allUsers[index % allUsers.length]);
                        },
                      ),
                       // Fixed image (not moving while scrolling)
       // Add this inside the Stack in your Scaffold (NOT inside _buildUserCard)
if (!_hideFixedImage)
  Positioned(
    right: 30,
    top: 540,
    child: AnimatedOpacity(
      opacity: _hideFixedImage ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Image.asset(
        "assets/usersstar.png",
        width: 60,
        height: 60,
        // key: _imageKey
      ),
    ),
  ),

                    ],
                  ),
                ),
              ],
            ),
      // bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    );
  }

  Widget _buildUserCard(Users user) {
    final profilePic = user.profilePics?.firstWhere(
      (pic) => pic.isPrimary == true,
      orElse: () => ProfilePics(url: null),
    ).url;

    final fullUrl = profilePic != null && profilePic.isNotEmpty
        ? 'http://97.74.93.26:6100$profilePic'
        : null;

    final remainingImages =
        user.profilePics?.where((pic) => pic.isPrimary != true).toList() ?? [];

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Static usersstar.png image at the top of every page
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   padding: const EdgeInsets.symmetric(vertical: 10),
            //   child: Center(
            //     child: Image.asset(
            //       "assets/usersstar.png",
            //       width: 60,
            //       height: 60,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            
            // Main image section with background
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.85,
              child: Stack(
                children: [
                  // Background gradient image
                  Positioned(
                    top: 10,
                    left: 20,
                    right: 20,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child: Image.asset(
                        "assets/users_all.png",
                        width: 400,
                        height: 700,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
//                 Image.asset(
//   "assets/usersstar.png",
//   // key: _imageKey, // 👈 Important for visibility tracking
//   width: 60,
//   height: 60,  
// ),

                  // Main curved user image
                  Positioned(
                    top: 20,
                    left: (MediaQuery.of(context).size.width - 300) / 2,
                    child: ClipPath(
                      clipper: CustomCornerClipper(
                        topLeft: 30,
                        topRight: 30,
                        bottomLeft: 0,
                        bottomRight: 200,
                      ),
                      child: Container(
                        width: 300,
                        height: 550,
                        child: fullUrl != null
                            ? Image.network(
                                fullUrl,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.person, size: 80, color: Colors.grey),
                                ),
                              ),
                      ),
                    ),
                  ),
                  
                  // Action buttons
                  Positioned(
                    top: 500,
                    left: (MediaQuery.of(context).size.width - 220) / 1,
                    child: SizedBox(
                      width: 290,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // GestureDetector(
                          //   onTap: () {
                          //     controller.swipe(CardSwiperDirection.top);
                          //     print("Super like tapped");
                          //   },
                          //   child: Image.asset(
                          //     "assets/usersstar.png",
                          //     width: 80,
                          //     height: 80,
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          GestureDetector(
                            onTap: () {
                              controller.swipe(CardSwiperDirection.right);
                              print("Like tapped");
                            },
                            child: Image.asset(
                              "assets/userslike.png",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     controller.swipe(CardSwiperDirection.left);
                          //     print("Reject tapped");
                          //   },
                          //   child: Image.asset(
                          //     "assets/userscross.png",
                          //     width: 80,
                          //     height: 80,
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  
                  // User name and age overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${user.firstName ?? ''}, ${_getAge(user.dob ?? '')}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable profile info section
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About section
                  if (user.bio != null && user.bio!.isNotEmpty) ...[
                    const Text(
                      "About",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.bio!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // About Me section
                  const Text(
                    "About Me",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (user.height != null && user.height!.isNotEmpty)
                        _buildInfoChip("📏", user.height!),
                      if (user.education != null && user.education!.isNotEmpty)
                        _buildInfoChip("🎓", user.education!),
                      if (user.zodiac != null && user.zodiac!.isNotEmpty)
                        _buildInfoChip("⭐", user.zodiac!),
                      if (user.drinking?.firstOrNull?.preference != null &&
                          user.drinking!.first.preference!.isNotEmpty)
                        _buildInfoChip("🍷", user.drinking!.first.preference!),
                      if (user.religions?.firstOrNull?.religion != null &&
                          user.religions!.first.religion!.isNotEmpty)
                        _buildInfoChip("🕉", user.religions!.first.religion!),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Interests section
                  if (user.qualities != null && user.qualities!.isNotEmpty) ...[
                    const Text(
                      "Interests",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: user.qualities!
                          .map((quality) => _buildInterestChip(quality.name ?? ''))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Looking for section
                  if (user.age != null && user.age!.isNotEmpty) ...[
                    const Text(
                      "I Am Looking For",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: user.age!
                          .map((goal) => _buildInterestChip(goal.goal ?? ''))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Remaining images section
                  if (remainingImages.isNotEmpty) ...[
                    const Text(
                      "More Photos",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRemainingImages(remainingImages),
                    const SizedBox(height: 20),
                  ],

                  // Location section
                  const Text(
                    "Location",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              _getDistanceText(user),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Coordinates: ${user.latitude?.toStringAsFixed(4) ?? 'N/A'}, ${user.longitude?.toStringAsFixed(4) ?? 'N/A'}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Action buttons section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        // Three action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Positioned(

                              child: _buildActionButton(
                                "assets/userscross.png",
                                "",
                                const Color.fromARGB(255, 202, 193, 192),
                                () {
                                  controller.swipe(CardSwiperDirection.left);
                                  _handleReject(currentCardIndex);
                                },
                              ),
                            ),
                           Positioned(
                              top:200,
                              child: _buildActionButton(
                              "assets/usersstar.png",
                              "",
                              const Color.fromARGB(255, 234, 235, 236),
                              key: _imageKey,
                              () {
                                controller.swipe(CardSwiperDirection.top);
                                _handleSuperLike(currentCardIndex);
                              },
                            ),
                           ),
                            _buildActionButton(
                              "assets/userslike.png",
                              
                              "",
                              const Color.fromARGB(255, 225, 227, 225),
                              () {
                                controller.swipe(CardSwiperDirection.right);
                                _handleLike(currentCardIndex);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        
                        // Suggest to friends button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:Color(0xFF869E23),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              "Suggest to Friends",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
  String assetPath,
  String label,
  Color color,
  VoidCallback onTap, {
  Key? key, // 
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          key: key,
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: color.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              assetPath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    ),
  );
}


  Widget _buildRemainingImages(List<ProfilePics> images) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 0,
        mainAxisSpacing: 16,
        childAspectRatio: 0.5,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final imageUrl = images[index].url;
        final fullUrl = imageUrl != null && imageUrl.isNotEmpty
            ? 'http://97.74.93.26:6100$imageUrl'
            : null;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: fullUrl != null
                ? Image.network(
                    fullUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                        ),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.image, size: 40, color: Colors.grey),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildInterestChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.pink.shade200),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.pink.shade700,
        ),
      ),
    );
  }

  Widget _buildInfoChip(String emoji, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _loadMoreUsers() async {
    if (isLoadingMore) return;
    
    setState(() => isLoadingMore = true);
    
    try {
      await ref.read(peoplesProvider.notifier).getPeoplesAll();
      final peoplesModel = ref.read(peoplesProvider);
      final newUsers = peoplesModel.users ?? [];
      
      if (newUsers.isNotEmpty) {
        setState(() {
          allUsers.addAll(newUsers);
        });
      }
    } catch (e) {
      print('Error loading more users: $e');
    } finally {
      setState(() => isLoadingMore = false);
    }
  }

  void _handleLike(int index) {
    if (index < allUsers.length) {
      final user = allUsers[index];
      print('Liked user: ${user.firstName}');
      // TODO: Add your like API call here
    }
  }

  void _handleReject(int index) {
    if (index < allUsers.length) {
      final user = allUsers[index];
      print('Rejected user: ${user.firstName}');
      // TODO: Add your reject API call here
    }
  }

  void _handleSuperLike(int index) {
    if (index < allUsers.length) {
      final user = allUsers[index];
      print('Super liked user: ${user.firstName}');
      // TODO: Add your super like API call here
    }
  }

 

  String _getAge(String dob) {
    try {
      final birthDate = DateTime.parse(dob);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month || 
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return '$age';
    } catch (e) {
      return '';
    }
  }
}

class CurvedBottomRightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width - 40, size.height);
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class CustomCornerClipper extends CustomClipper<Path> {
  final double topLeft;
  final double topRight;
  final double bottomLeft;
  final double bottomRight;

  CustomCornerClipper({
    this.topLeft = 0,
    this.topRight = 0,
    this.bottomLeft = 0,
    this.bottomRight = 0,
  });

  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, topLeft);
    path.quadraticBezierTo(0, 0, topLeft, 0);
    path.lineTo(size.width - topRight, 0);
    path.quadraticBezierTo(size.width, 0, size.width, topRight);

    path.lineTo(size.width, size.height - bottomRight);
    path.quadraticBezierTo(size.width, size.height, size.width - bottomRight, size.height);

    path.lineTo(bottomLeft, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - bottomLeft);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}