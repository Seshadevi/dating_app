import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/model/peoples_all_model.dart';
import 'package:dating/provider/likedislikeprovider.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/peoples_all_provider.dart';
import 'package:dating/screens/profile_screens/profile_bottomNavigationbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:dating/provider/socket_users_combined_provider.dart';
import 'package:dating/screens/profile_screens/narrowsearch.dart';
import 'dart:math' as math;
import 'package:geocoding/geocoding.dart';

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
  int viewedUsersCount = 0; // Track viewed users
  bool allUsersCompleted = false; // Track if all users are completed
  
  // Current user location (you'll need to get this from your login model/API)
  double? currentUserLatitude;
  double? currentUserLongitude;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _imageKey = GlobalKey();
  bool _hideFixedImage = false;
  CardSwiperDirection? _swipeDirection;
  bool _showOverlay = false;
  SearchFilters? _filters;

  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // ref.read(peoplesProvider.notifier).getPeoplesAll();

    ref.read(socketUserProvider.notifier).reset();

    final userModel = ref.read(loginProvider); // <- use `read` instead of `watch` inside initState

  //  final userModel = ref.read(loginProvider);
  final location = userModel.data != null && userModel.data!.isNotEmpty
      ? userModel.data!.first.user?.location
      : null;


    currentUserLatitude = location?.latitude?.toDouble();
    currentUserLongitude = location?.longitude?.toDouble();

    _scrollController.addListener(_checkVisibility);
  });
}

List<Users> _applyClientFilters(List<Users> input) {
  final f = _filters;
  if (f == null) return input; // nothing selected yet
  return input.where((u) => _matchesFilters(u, f)).toList();
}

bool _matchesFilters(Users u, SearchFilters f) {
  // Age (from dob)
  final dob = u.dob;
  if (dob != null && dob.isNotEmpty) {
    final age = _ageFromDob(dob);
    if (age != null) {
      final min = f.minAge - (f.relaxAge ? 2 : 0);
      final max = f.maxAge + (f.relaxAge ? 2 : 0);
      if (age < min || age > max) return false;
    }
  }

  // Distance (needs both sides to have coords)
  if (u.latitude != null && u.longitude != null &&
      currentUserLatitude != null && currentUserLongitude != null) {
    final limitKm = f.maxDistanceKm + (f.relaxDistance ? 20 : 0);
    final dKm = _calculateDistance(
      currentUserLatitude!, currentUserLongitude!, u.latitude!, u.longitude!
    );
    if (dKm > limitKm) return false;
  }

  // Interests -> your "qualities" IDs
  if (f.interestIds.isNotEmpty) {
    final qids = (u.qualities ?? []).map((q) => q.id).whereType<int>().toSet();
    if (qids.intersection(f.interestIds).isEmpty) return false;
  }

  // Languages (if present on this Users model)
  if (f.languageNames.isNotEmpty && u.languages != null) {
    final userLangs = u.languages!
        .map((l) => l.name?.toLowerCase())
        .whereType<String>()
        .toSet();
    final wanted = f.languageNames.map((s) => s.toLowerCase()).toSet();
    if (userLangs.intersection(wanted).isEmpty) return false;
  }

  // Height (if your Users has height)
  if (u.height != null) {
    final minH = f.minHeightCm - (f.relaxHeight ? 5 : 0);
    final maxH = f.maxHeightCm + (f.relaxHeight ? 5 : 0);
    if (u.height! < minH || u.height! > maxH) return false;
  }

  // (Optional) genderId + relationship if your Users exposes those as IDs/strings.

  return true;
}

int? _ageFromDob(String dob) {
  try {
    final b = DateTime.parse(dob);
    final now = DateTime.now();
    var age = now.year - b.year;
    if (now.month < b.month || (now.month == b.month && now.day < b.day)) age--;
    return age;
  } catch (_) {
    return null;
  }
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
  // void _getCurrentUserLocation() {
    // TODO: Replace with actual API call to get current user location
    // Example:
    // final currentUser = ref.read(currentUserProvider);
    // currentUserLatitude = currentUser.latitude;
    // currentUserLongitude = currentUser.longitude;
    
    // For now, using dummy data - replace with your actual implementation
  //   currentUserLatitude = 17.3850; // Hyderabad latitude
  //   currentUserLongitude = 78.4867; // Hyderabad longitude
  // }
  
  Future<String> _getPlaceName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        // You can customize how much of the address you want to show
        return "${place.locality}, ${place.administrativeArea}";
      } else {
        return "Unknown location";
      }
    } catch (e) {
      return "Location error";
    }
  }

  // Calculate distance between two coordinates
 double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371; // in kilometers

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

  double userLat = user.latitude ?? 0.0;
  double userLon = user.longitude ?? 0.0;

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

  // Method to update progress and check completion
  void _updateProgress() {
    setState(() {
      viewedUsersCount++;
      if (viewedUsersCount >= allUsers.length) {
        allUsersCompleted = true;
      }
    });
  }

  // Method to show completion dialog
  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('All Users Viewed!'),
          content: const Text('You have viewed all available users. Would you like to refresh and see more users?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetProgress();
              },
              child: const Text('Refresh'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to previous screen
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  // Method to reset progress
  void _resetProgress() {
    setState(() {
      viewedUsersCount = 0;
      allUsersCompleted = false;
      currentCardIndex = 0;
    });
    // Optionally reload users
    ref.read(peoplesProvider.notifier).getPeoplesAll();
  }

  @override
  Widget build(BuildContext context) {
    // final peoplesModel = ref.watch(peoplesProvider);
    // final users = peoplesModel.users ?? [];
    final users = ref.watch(socketUserProvider);
    print("📡 Total socket users in UI: ${users.length}");
    // Update allUsers when new data comes
    allUsers = users.map((e) => Users.fromJson(e)).toList();
    final visibleUsers = _applyClientFilters(allUsers); 
    // after: allUsers = users.map((e) => Users.fromJson(e)).toList();
    final int cardsCount = allUsers.length;
    final int displayed = cardsCount >= 2 ? 2 : cardsCount; // 1 when only one user

    // if (users.isNotEmpty && allUsers.isEmpty) {
    //   allUsers = List.from(users);
    // }

    // print("PeoplesModel: ${peoplesModel}");
    // print("Users: ${peoplesModel.users}");

    return Scaffold(
      backgroundColor: DatingColors.white,
      body: visibleUsers.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("Loading users...", style: TextStyle(fontSize: 18, color: DatingColors.mediumGrey))
                ],
              ),
            )
          :cardsCount == 0
        ? const Center(
            child: Text(
              "Users not found",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ):Column(
              children: [
                // Custom AppBar with Progress Bar
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.arrow_back, color: DatingColors.black),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                'Heart Sync',
                                style: TextStyle(color: DatingColors.black, fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                             IconButton(
                                icon: const Icon(Icons.tune, color: DatingColors.black),
                                  onPressed: () async {
                                    final result = await Navigator.pushNamed(context, '/narrowsearch');
                                    if (result is SearchFilters) {
                                      setState(() {
                                        _filters = result;
                                        // reset progress when filters change
                                        viewedUsersCount = 0;
                                        allUsersCompleted = false;
                                        currentCardIndex = 0;
                                      });
                                    }
                                  },
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Progress Bar
                        Container(
                          width: double.infinity,
                          height: 8,
                          decoration: BoxDecoration(
                            color: DatingColors.mediumGrey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Stack(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: MediaQuery.of(context).size.width * 
                                    (viewedUsersCount / allUsers.length),
                                height: 8,
                                decoration: BoxDecoration(
                                  color: allUsersCompleted ? DatingColors.errorRed: DatingColors.primaryGreen,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // const SizedBox(height: 8),
                        // Progress Text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Viewed: $viewedUsersCount/${visibleUsers.length}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: DatingColors.mediumGrey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              allUsersCompleted ? 'Completed!' : '${(viewedUsersCount / (visibleUsers.isEmpty ? 1 : visibleUsers.length) * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 12,
                                color: allUsersCompleted ? DatingColors.primaryGreen :DatingColors.lightpink,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Completion Message (if all users are viewed)
                if (allUsersCompleted)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: DatingColors.lightGreen,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: DatingColors.lightGreen),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: DatingColors.darkGreen, size: 24),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'All users viewed! No more cards to swipe.',
                            style: TextStyle(
                              color: DatingColors.darkGreen,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _resetProgress,
                          child: const Text('Refresh'),
                        ),
                      ],
                    ),
                  ),
                
                // Full Screen Card Content
                Expanded(
                  child: Stack(
                    children: [
                      // Show card swiper only if not all users are completed
                      if (!allUsersCompleted)
                        CardSwiper(
                          controller: controller,
                          cardsCount: cardsCount,
                          numberOfCardsDisplayed: displayed,
                          isLoop: false, // Disable loop when tracking progress
                          allowedSwipeDirection: const AllowedSwipeDirection.symmetric(horizontal: true),
                          backCardOffset: const Offset(0, 20),
                          padding: EdgeInsets.zero,
                          
                          onSwipe: (previousIndex, currentIndex, direction) {
                             setState(() {
                            currentCardIndex = currentIndex ?? 0;
                            _swipeDirection = direction;
                            _showOverlay = true;
                            viewedUsersCount++;
                            allUsersCompleted = viewedUsersCount >= cardsCount; // << filtered total
                          });

                          // Hide overlay after 300ms
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (mounted) {
                              setState(() {
                                _showOverlay = false;
                              });
                            }
                          });
                                                    
                            // Update progress
                            _updateProgress();
                            
                            // Show completion dialog when all users are viewed
                            if (allUsersCompleted) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _showCompletionDialog();
                              });
                            }
                            
                            // if (currentIndex != null && currentIndex >= allUsers.length - 3 && !isLoadingMore) {
                            //   _loadMoreUsers();
                            // }
                            if (currentIndex != null) {
                                      ref.read(socketUserProvider.notifier).fetchNextPageIfNearEnd(currentIndex);
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
                          // cardBuilder: (BuildContext context, int index, int hOffset, int vOffset) {
                          //   if (index >= allUsers.length) return Container();
                          //   return _buildUserCard(allUsers[index % allUsers.length]);
                          // },
                          cardBuilder: (BuildContext context, int index, int hOffset, int vOffset) {
                            if (index >= visibleUsers.length) return Container();

                            return Stack(
                              children: [
                                _buildUserCard(visibleUsers[index % allUsers.length]),

                               if (_showOverlay && _swipeDirection != null)
                              Positioned(
                                top: 250,
                                left: _swipeDirection == CardSwiperDirection.right ? 140 : null,
                                right: _swipeDirection == CardSwiperDirection.left ? 140 : null,
                                child: Icon(
                                  _swipeDirection == CardSwiperDirection.right
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  size: 80,
                                  color: _swipeDirection == CardSwiperDirection.right
                                      ? DatingColors.primaryGreen
                                      : DatingColors.errorRed,
                                ),
                              ),

                              ],
                            );
                          },

                        ),
                      
                      // Show completion screen when all users are viewed
                      if (allUsersCompleted)
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.favorite,
                                size: 80,
                                color: DatingColors.lightpink,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'All Done!',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'You have viewed all available users.\nCheck back later for more profiles!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: DatingColors.lightgrey,
                                ),
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: _resetProgress,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: DatingColors.darkGreen,
                                  foregroundColor: DatingColors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'View Again',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      // Fixed image (not moving while scrolling)
                      if (!_hideFixedImage && !allUsersCompleted)
                        Positioned(
                          right: 30,
                          top: 500,
                          child: AnimatedOpacity(
                            opacity: _hideFixedImage ? 0.0 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: Image.asset(
                              "assets/usersstar.png",
                              width: 60,
                              height: 60,
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
                                color: DatingColors.lightgrey,
                                child: const Center(
                                  child: Icon(Icons.person, size: 80, color: DatingColors.lightgrey),
                                ),
                              ),
                      ),
                    ),
                  ),
                  
                  // Action buttons
                  // Positioned(
                  //   top: 545,
                  //   left: 40,
                  //   child: SizedBox(
                  //     width: 250,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         GestureDetector(
                  //           onTap: () {
                  //             if (!allUsersCompleted) {
                  //               print("Like tapped");
                  //             }
                  //           },
                  //           child: Image.asset(
                  //             "assets/userslike.png",
                  //             width: 50,
                  //             height: 50,
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  
                  // User name and age overlay
                  Positioned(
                    bottom: 0,
                    top: 485,
                    left: 10,
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
                      // if (user.height != null && user.height!.isNotEmpty)
                      //   _buildInfoChip("📏", user.height!),
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
                    "📍Location",
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
                        FutureBuilder<String>(
                          future: _getPlaceName(user.latitude ?? 17.4065, user.longitude ?? 78.4772),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Text("Loading location...");
                            } else if (snapshot.hasError || !snapshot.hasData) {
                              return const Text("Location unavailable");
                            } else {
                              return Text(
                                snapshot.data!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              );
                            }
                          },
                        ),
                        Text(
                          "📌Coordinates: ${user.latitude?.toStringAsFixed(4) ?? 'N/A'}, ${user.longitude?.toStringAsFixed(4) ?? 'N/A'}",
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
                            _buildActionButton(
                              "assets/userscross.png",
                              () {
                                if (!allUsersCompleted) {
                                  controller.swipe(CardSwiperDirection.left);
                                  _handleReject(currentCardIndex);
                                }
                              },
                            ),
                            // ⭐ Super Like button → lift it upward
                            Transform.translate(
                              offset: const Offset(0, -40), // Move up by 20 pixels
                              child: _buildActionButton(
                                "assets/usersstar.png",
                                () {
                                  if (!allUsersCompleted) {
                                    controller.swipe(CardSwiperDirection.top);
                                    _handleSuperLike(currentCardIndex);
                                  }
                                },
                                key: _imageKey,
                              ),
                            ),
                            _buildActionButton(
                              "assets/userslike.png",
                              () {
                                if (!allUsersCompleted) {
                                  controller.swipe(CardSwiperDirection.right);
                                  _handleLike(currentCardIndex);
                                }
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
                              backgroundColor: const Color(0xFF869E23),
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
    VoidCallback onTap, {
    Key? key,
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

      return Stack(
        children: [
          Container(
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
                      width: double.infinity,
                      height: double.infinity,
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
          ),

          // 👇 Positioned icon (your action icon like "userslike.png")
          // Positioned(
          //   bottom: 8,
          //   right: 230,
          //   child: GestureDetector(
          //     onTap: () {
          //       // TODO: handle tap
          //       print("Icon tapped on image $index");
          //     },
          //     child: Image.asset(
          //       "assets/userslike.png", // replace with your asset path
          //       width: 76,
          //       height: 76,
          //     ),
          //   ),
          // ),
        ],
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

    // Trigger the like API via provider
    ref.read(likedDislikeProvider.notifier).addLikeDislike(
      user.id.toString(), // or just user.userId if it's already a String
      'right',
    );
  }
}


void _handleReject(int index) {
  if (index < allUsers.length) {
    final user = allUsers[index];
    print('Rejected user: ${user.firstName}');

    // Trigger the dislike API via provider
    ref.read(likedDislikeProvider.notifier).addLikeDislike(
      user.id.toString(), // ensure it's a string if your API expects one
      'left',
    );
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