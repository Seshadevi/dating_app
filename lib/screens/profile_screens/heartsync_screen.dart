
import 'package:dating/model/peoples_all_model.dart';
import 'package:dating/provider/peoples_all_provider.dart';
import 'package:dating/screens/profile_screens/profile_bottomNavigationbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(peoplesProvider.notifier).getPeoplesAll();
    });
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
                        // cardPadding: EdgeInsets.zero,
                        backCardOffset: const Offset(0, 0),
                        padding: EdgeInsets.zero,
                        onSwipe: (previousIndex, currentIndex, direction) {
                          setState(() {
                            currentCardIndex = currentIndex ?? 0;
                          });
                          
                          if (currentIndex != null && currentIndex >= allUsers.length - 3 && !isLoadingMore) {
                            _loadMoreUsers();
                          }
                          
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
                      
                      // Bottom action buttons
                      // Positioned(
                      //   bottom: 20,
                      //   left: 0,
                      //   right: 0,
                      //   child: _buildActionButtons(),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Reject button
          GestureDetector(
            onTap: () {
              controller.swipe(CardSwiperDirection.left);
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 2),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.close,
                color: Colors.red,
                size: 24,
              ),
            ),
          ),
          
          // Super like button
          GestureDetector(
            onTap: () {
              controller.swipe(CardSwiperDirection.top);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 2),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.star,
                color: Colors.blue,
                size: 20,
              ),
            ),
          ),
          
          // Like button
          GestureDetector(
            onTap: () {
              controller.swipe(CardSwiperDirection.right);
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 2),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite,
                color: Colors.green,
                size: 24,
              ),
            ),
          ),
        ],
      ),
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
            // Main image section with background
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.85, // 85% of screen height
              child: Stack(
                children: [
                  // Background gradient image (full screen)
                  Positioned(
            top: 10,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              // bottomLeft: Radius.circular(10),
              // bottomRight: Radius.circular(10),
            ),
              child: Image.asset(
                "assets/users_all.png",
                 width: 400, // your custom width
               height: 700, // your custom height
                fit: BoxFit.cover,
              ),
            ),
          ),
                  
                  // Main curved user image (fixed width and height)
                 Positioned(
            top: 20,
            left: (MediaQuery.of(context).size.width - 300) / 2, // Center horizontally
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
         Positioned(
  top: 500,
  left: (MediaQuery.of(context).size.width - 220) / 2, // center align
  child: SizedBox(
    width: 220, // Ensure there's space to layout 3 icons
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            print("Pass tapped");
          },
          child: Image.asset(
            "assets/usersstar.png",
            width: 60,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
        GestureDetector(
          onTap: () {
            print("Like tapped");
          },
          child: Image.asset(
            "assets/userslike.png",
            width: 60,
            height: 150,
            fit: BoxFit.cover,
          ),
        ),
        GestureDetector(
          onTap: () {
            print("Favorite tapped");
          },
          child: Image.asset(
            "assets/userscross.png",
            width:65,
            height: 65,
            fit: BoxFit.cover,
          ),
        ),
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
                      // decoration: BoxDecoration(
                      //   gradient: LinearGradient(
                      //     begin: Alignment.bottomCenter,
                      //     end: Alignment.topCenter,
                      //     colors: [
                      //       Colors.black.withOpacity(0.8),
                      //       Colors.black.withOpacity(0.4),
                      //       const Color.fromARGB(0, 27, 25, 25),
                      //     ],
                      //   ),
                      // ),
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
                    const SizedBox(height: 100), // space for action buttons if needed
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildRoundIcon(String assetPath, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
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
    }
  }

  void _handleReject(int index) {
    if (index < allUsers.length) {
      final user = allUsers[index];
      print('Rejected user: ${user.firstName}');
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
    path.lineTo(0, size.height); // Left bottom
    path.lineTo(size.width - 40, size.height); // Start curve before right
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0); // Right top
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
    path.quadraticBezierTo(0, 0, topLeft, 0); // Top-left
    path.lineTo(size.width - topRight, 0);
    path.quadraticBezierTo(size.width, 0, size.width, topRight); // Top-right

    path.lineTo(size.width, size.height - bottomRight);
    path.quadraticBezierTo(size.width, size.height, size.width - bottomRight, size.height); // Bottom-right

    path.lineTo(bottomLeft, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - bottomLeft); // Bottom-left

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}