import 'dart:ui';
import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/likes/likedislikeprovider.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:dating/provider/socket_users_combined_provider.dart';
import 'package:dating/screens/profile_screens/narrowsearch.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

class MyHeartsyncPage extends ConsumerStatefulWidget {
  const MyHeartsyncPage({super.key});

  @override
  ConsumerState<MyHeartsyncPage> createState() => _MyHeartsyncPageState();
}

class _MyHeartsyncPageState extends ConsumerState<MyHeartsyncPage>
    with TickerProviderStateMixin {
  bool isLoadingMore = false;
  final CardSwiperController controller = CardSwiperController();
  List<Map<String, dynamic>> allUsers = [];
  int currentCardIndex = 0;
  int viewedUsersCount = 0;
  bool allUsersCompleted = false;

  // Current user location
  double? currentUserLatitude;
  double? currentUserLongitude;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _bottomActionsKey = GlobalKey();
  bool _hideFixedImage = false;
  CardSwiperDirection? _swipeDirection;
  bool _showOverlay = false;

  // Animation controllers for enhanced UI
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  // Super Like animation controllers - Bumble style
  bool _isSuperLikeAnimating = false;
  late AnimationController _superLikeController;
  late Animation<double> _superLikeScaleAnimation;
  late Animation<double> _superLikeOpacityAnimation;
  late Animation<double> _superLikeGlowAnimation;

  // Floating star button visibility
  bool _showFloatingStar = true;
  late AnimationController _floatingStarController;
  late Animation<double> _floatingStarOpacity;

  // Enhanced variables
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _superLikeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _floatingStarController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    // Super Like animations
    _superLikeScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _superLikeController,
      curve: Curves.elasticOut,
    ));

    _superLikeOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _superLikeController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    _superLikeGlowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _superLikeController,
      curve: Curves.easeInOut,
    ));

    _floatingStarOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _floatingStarController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(socketUserProvider.notifier).reset();

      final userModel = ref.read(loginProvider);
      final location = userModel.data != null && userModel.data!.isNotEmpty
          ? userModel.data!.first.user?.location
          : null;

      currentUserLatitude = location?.latitude?.toDouble();
      currentUserLongitude = location?.longitude?.toDouble();

      _scrollController.addListener(_checkFloatingStarVisibility);

      _floatingStarController.forward();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _scrollController.dispose();
    _superLikeController.dispose();
    _floatingStarController.dispose();
    super.dispose();
  }

  void _checkFloatingStarVisibility() {
    final RenderBox? bottomActionsBox =
        _bottomActionsKey.currentContext?.findRenderObject() as RenderBox?;

    if (bottomActionsBox != null) {
      final position = bottomActionsBox.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;

      final shouldHide = position.dy < screenHeight - 100;

      if (shouldHide && _showFloatingStar) {
        setState(() => _showFloatingStar = false);
        _floatingStarController.reverse();
      } else if (!shouldHide && !_showFloatingStar && !allUsersCompleted) {
        setState(() => _showFloatingStar = true);
        _floatingStarController.forward();
      }
    }
  }

  // Age calculation method
  int _calculateAge(String? dobString) {
    if (dobString == null || dobString.isEmpty) return 0;
    try {
      final dob = DateFormat("dd/MM/yyyy").parse(dobString);
      final now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return 0;
    }
  }

  // Super Like animation
  void _animateSuperLikeOnImage() {
    if (_isSuperLikeAnimating) return;

    setState(() {
      _isSuperLikeAnimating = true;
    });

    HapticFeedback.mediumImpact();

    _superLikeController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _superLikeController.reset();
        setState(() {
          _isSuperLikeAnimating = false;
        });
      });
      });
    }

  void _superLikeFromFloatingButton() {
    if (_isSuperLikeAnimating || allUsersCompleted) return;

    _floatingStarController.reverse();
    _animateSuperLikeOnImage();

    Future.delayed(const Duration(milliseconds: 200), () {
      if (!allUsersCompleted) {
        controller.swipe(CardSwiperDirection.top);
      }
    });
  }

  // Helper methods for extracting user data - UPDATED for new JSON structure
  String _getUserName(Map<String, dynamic> user) {
    final firstName = user['firstName'] ?? '';
    final lastName = user['lastName'] ?? '';
    if (firstName.isEmpty && lastName.isEmpty) {
      return 'User ${user['id'] ?? ''}';
    }
    return '$firstName $lastName'.trim();
  }

  String _getUserNameWithAge(Map<String, dynamic> user) {
    final firstName = user['firstName'] ?? '';
    final dob = user['dob'];
    final age = _calculateAge(dob);

    if (age > 0) {
      return '$firstName, $age';
    } else {
      return firstName.isNotEmpty ? firstName : 'User ${user['id'] ?? ''}';
    }
  }

  String _getUserDistance(Map<String, dynamic> user) {
    final location = user['location'];
    if (location == null ||
        currentUserLatitude == null ||
        currentUserLongitude == null) {
      return 'Location not available';
    }

    final userLat = location['latitude']?.toDouble();
    final userLon = location['longitude']?.toDouble();

    if (userLat == null || userLon == null) {
      return 'Location not available';
    }

    final distance = _calculateDistance(
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

  // UPDATED: Profile images with new server path format - MULTIPLE IMAGES SUPPORT
  List<String> _getUserProfileImages(Map<String, dynamic> user) {
    final profilePics = user['profile_pics'] as List?;
    final userId = user['id'];

    if (profilePics == null || profilePics.isEmpty || userId == null) return [];

    return profilePics
        .map((pic) {
          String? imagePath = pic['imagePath'] ?? '';

          // Extract filename from path like "/Uploadsdating/531/1758611355333_1000110215.jpg"
          if (imagePath!.startsWith('/')) {
            imagePath = imagePath.substring(1); // Remove leading slash
          }

          // Build full URL
          if (imagePath!.isNotEmpty) {
            return 'http://97.74.93.26:6100/$imagePath';
          }

          return '';
        })
        .where((url) => url.isNotEmpty)
        .toList();
  }

  String _getUserBio(Map<String, dynamic> user) {
    return user['headLine'] ?? '';
  }

  List<String> _getUserModes(Map<String, dynamic> user) {
    final modes = user['modes'] as List?;
    if (modes == null) return [];
    return modes
        .map((mode) => mode['value']?.toString() ?? '')
        .where((mode) => mode.isNotEmpty)
        .toList();
  }

  List<String> _getUserInterests(Map<String, dynamic> user) {
    final raw = user['interests'];
    if (raw == null) return [];

    if (raw is List) {
      final interests = raw
          .map((interest) {
            if (interest is Map) {
              final name = interest['interests'] ??
                  interest['name'] ??
                  interest['title'] ??
                  interest['value'] ??
                  '';
              return name.toString().trim();
            }
            if (interest is String) {
              return interest.trim();
            }
            return '';
          })
          .where((interest) => interest.isNotEmpty)
          .toList();

      return interests;
    }

    if (raw is String) {
      if (raw.isEmpty) return [];
      final interests = raw
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      return interests;
    }

    return [];
  }

  String _getUserEducation(Map<String, dynamic> user) {
    final educations = user['educations'] as List?;
    if (educations == null || educations.isEmpty) return '';

    final education = educations.first['institution']?.toString() ??
        educations.first['name']?.toString() ??
        '';
    return education.trim();
  }

  String _getUserWork(Map<String, dynamic> user) {
    final work = user['work'];
    if (work != null && work is Map) {
      return work['title']?.toString()?.trim() ?? '';
    }

    final industries = user['industries'] as List?;
    if (industries == null || industries.isEmpty) return '';
    final industry = industries.first['industry']?.toString() ?? '';
    return industry.trim();
  }

  String _getUserQualities(Map<String, dynamic> user) {
    final qualities = user['qualities'] as List?;
    if (qualities == null) return '';
    return qualities
        .map((q) => q['name']?.toString() ?? '')
        .where((q) => q.isNotEmpty)
        .join(', ');
  }

  String _getUserReligion(Map<String, dynamic> user) {
    final religions = user['religions'] as List?;
    if (religions == null || religions.isEmpty) return '';
    return religions.first['religion']?.toString()?.trim() ?? '';
  }

  String _getUserDrinking(Map<String, dynamic> user) {
    final drinking = user['drinking'] as List?;
    if (drinking == null || drinking.isEmpty) return '';
    return drinking.first['preference']?.toString()?.trim() ?? '';
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371;
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * math.pi / 180;

  void _updateProgress() {
    setState(() {
      viewedUsersCount++;
      if (viewedUsersCount >= allUsers.length) {
        allUsersCompleted = true;
        _showFloatingStar = false;
        _floatingStarController.reverse();
      }
    });
  }

  void _resetProgress() {
    setState(() {
      viewedUsersCount = 0;
      allUsersCompleted = false;
      currentCardIndex = 0;
      _showFloatingStar = true;
    });
    _floatingStarController.forward();
    ref.read(socketUserProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    final socketUsers = ref.watch(socketUserProvider);

    allUsers = List<Map<String, dynamic>>.from(socketUsers);
    final int cardsCount = allUsers.length;
    final int displayed = cardsCount >= 2 ? 2 : cardsCount;

    return Scaffold(
      backgroundColor: DatingColors.backgroundWhite,
      body: socketUsers.isEmpty
          ? _buildLoadingWidget()
          : Stack(
              children: [
                Column(
                  children: [
                    _buildEnhancedAppBar(),
                    if (allUsersCompleted) _buildCompletionBanner(),
                    Expanded(
                        child:
                            _buildCardStack(allUsers, cardsCount, displayed)),
                  ],
                ),
                _buildFloatingSuperLikeButton(),
              ],
            ),
    );
  }

  Widget _buildFloatingSuperLikeButton() {
    return AnimatedBuilder(
      animation: _floatingStarOpacity,
      builder: (context, child) {
        return Positioned(
          bottom: 100,
          right: 20,
          child: Opacity(
            opacity: _floatingStarOpacity.value,
            child: GestureDetector(
              onTap: _superLikeFromFloatingButton,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: DatingColors.yellow,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: DatingColors.yellow.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.black,
                  size: 35,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        DatingColors.everqpidColor,
                        DatingColors.lightpink
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child:
                      const Icon(Icons.favorite, color: Colors.white, size: 40),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            "Finding Perfect Matches...",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: DatingColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedAppBar() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [DatingColors.everqpidColor, DatingColors.lightpink],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.favorite, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'EVER QPID',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: DatingColors.surfaceGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(Icons.tune, color: DatingColors.secondaryText),
                onPressed: () async {
                  HapticFeedback.lightImpact();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NarrowSearchScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionBanner() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [DatingColors.lightGreen, DatingColors.lightGreen],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: DatingColors.successGreen.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: DatingColors.successGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.check_circle,
                  color: DatingColors.successGreen, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All profiles viewed! 🎉',
                    style: TextStyle(
                      color: DatingColors.successGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'No more cards to swipe right now',
                    style: TextStyle(
                      color: DatingColors.successGreen.withOpacity(0.8),
                      fontSize: 14,
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

  Widget _buildCardStack(
      List<Map<String, dynamic>> users, int cardsCount, int displayed) {
    return Stack(
      children: [
        if (!allUsersCompleted)
          CardSwiper(
            controller: controller,
            cardsCount: cardsCount,
            numberOfCardsDisplayed: displayed,
            isLoop: false,
            allowedSwipeDirection: const AllowedSwipeDirection.all(),
            backCardOffset: const Offset(0, 20),
            padding: EdgeInsets.zero,
            onSwipe: (previousIndex, currentIndex, direction) {
              HapticFeedback.mediumImpact();

              if (previousIndex != null) {
                if (direction == CardSwiperDirection.right) {
                  _handleLike(previousIndex);
                } else if (direction == CardSwiperDirection.left) {
                  _handleReject(previousIndex);
                } else if (direction == CardSwiperDirection.top) {
                  _handleSuperLike(previousIndex);
                }
              }

              setState(() {
                currentCardIndex = currentIndex ?? 0;
                _swipeDirection = direction;
                _showOverlay = true;
                viewedUsersCount++;
                allUsersCompleted = viewedUsersCount >= cardsCount;
              });

              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) {
                  setState(() => _showOverlay = false);
                }
              });

              _updateProgress();

              if (allUsersCompleted) {
                _slideController.forward();
              }

              if (currentIndex != null) {
                ref
                    .read(socketUserProvider.notifier)
                    .fetchNextPageIfNeeded(currentIndex);
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _checkFloatingStarVisibility();
              });

              return true;
            },
            cardBuilder:
                (BuildContext context, int index, int hOffset, int vOffset) {
              if (index >= users.length) return Container();

              return Stack(
                children: [
                  _buildBumbleStyleUserCard(users[index]),
                  if (_showOverlay && _swipeDirection != null)
                    _buildSwipeOverlay(),
                ],
              );
            },
          ),
        if (allUsersCompleted) _buildCompletionScreen(),
      ],
    );
  }

  Widget _buildSuperLikeImageOverlay() {
    return AnimatedBuilder(
      animation: _superLikeController,
      builder: (context, child) {
        return _isSuperLikeAnimating
            ? Center(
                child: ScaleTransition(
                  scale: _superLikeScaleAnimation,
                  child: FadeTransition(
                    opacity: _superLikeOpacityAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: DatingColors.yellow,
                        boxShadow: [
                          BoxShadow(
                            color: DatingColors.yellow.withOpacity(
                                _superLikeGlowAnimation.value * 0.6),
                            blurRadius: 40 * _superLikeGlowAnimation.value,
                            spreadRadius: 10 * _superLikeGlowAnimation.value,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(32),
                      child:
                          const Icon(Icons.star, color: Colors.black, size: 70),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget _buildSwipeOverlay() {
    IconData overlayIcon = Icons.favorite;
    Color overlayColor = DatingColors.successGreen;

    if (_swipeDirection == CardSwiperDirection.right) {
      overlayIcon = Icons.favorite;
      overlayColor = DatingColors.successGreen;
    } else if (_swipeDirection == CardSwiperDirection.left) {
      overlayIcon = Icons.close;
      overlayColor = DatingColors.errorRed;
    } else if (_swipeDirection == CardSwiperDirection.top) {
      overlayIcon = Icons.star;
      overlayColor = DatingColors.yellow;
    }

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black.withOpacity(0.3),
        ),
        child: Center(
          child: AnimatedScale(
            scale: _showOverlay ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: overlayColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                overlayIcon,
                size: 60,
                color: _swipeDirection == CardSwiperDirection.top
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionScreen() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            DatingColors.lightpinks,
            DatingColors.middlepink,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        DatingColors.everqpidColor,
                        DatingColors.lightpink
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: DatingColors.everqpidColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child:
                      const Icon(Icons.favorite, size: 60, color: Colors.white),
                ),
              );
            },
          ),
          const SizedBox(height: 30),
          Text(
            'All Done! 🎉',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: DatingColors.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'You have viewed all available users.\nCheck back later for more profiles!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: DatingColors.secondaryText,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: _resetProgress,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: DatingColors.lightpink,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 5,
            ),
          ),
        ],
      ),
    );
  }

  // BUMBLE-STYLE USER CARD WITH MULTIPLE IMAGES SUPPORT
  Widget _buildBumbleStyleUserCard(Map<String, dynamic> user) {
    final profileImages = _getUserProfileImages(user);
    final userNameWithAge = _getUserNameWithAge(user);
    final userDistance = _getUserDistance(user);
    final userBio = _getUserBio(user);
    final userInterests = _getUserInterests(user);
    final userEducation = _getUserEducation(user);
    final userWork = _getUserWork(user);

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // MULTIPLE IMAGES SECTION - BUMBLE STYLE
                _buildMultipleImagesSection(
                    user, profileImages, userNameWithAge, userDistance),
                // PROFILE INFO SECTION - BUMBLE STYLE
                _buildBumbleProfileInfo(
                    user, userBio, userInterests, userEducation, userWork),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // BUMBLE-STYLE MULTIPLE IMAGES SECTION
  Widget _buildMultipleImagesSection(
    Map<String, dynamic> user,
    List<String> profileImages,
    String userNameWithAge,
    String userDistance,
  ) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Stack(
        children: [
          // Multiple Images PageView
          if (profileImages.isNotEmpty)
            PageView.builder(
              itemCount: profileImages.length,
              onPageChanged: (page) {
                setState(() {
                  _currentImageIndex = page;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.network(
                    profileImages[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: DatingColors.surfaceGrey,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                                DatingColors.everqpidColor),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: DatingColors.mediumGrey,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person,
                                  size: 100, color: DatingColors.lightgrey),
                              const SizedBox(height: 16),
                              Text(
                                userNameWithAge,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          else
            Container(
              color: DatingColors.mediumGrey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person,
                        size: 100, color: DatingColors.lightgrey),
                    const SizedBox(height: 16),
                    Text(
                      userNameWithAge,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Super Like overlay
          _buildSuperLikeImageOverlay(),

          // Image indicator dots - BUMBLE STYLE
          if (profileImages.length > 1)
            Positioned(
              top: 50,
              left: 16,
              right: 16,
              child: Row(
                children: profileImages.asMap().entries.map((entry) {
                  final isActive = entry.key == _currentImageIndex;
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ]
                            : [],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          // Gradient overlay for better text visibility
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 200,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black87,
                  ],
                ),
              ),
            ),
          ),

          // User info overlay - BUMBLE STYLE
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        userNameWithAge,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 4,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Text(
                        userDistance,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Quick bio preview
                if (_getUserBio(user).isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getUserBio(user),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // BUMBLE-STYLE PROFILE INFO SECTION
  Widget _buildBumbleProfileInfo(
    Map<String, dynamic> user,
    String userBio,
    List<String> userInterests,
    String userEducation,
    String userWork,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // My Bio section
          if (userBio.isNotEmpty) ...[
            _buildBumbleSectionHeader("My Bio", "💬"),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                userBio,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // My Basics section
          _buildBumbleSectionHeader("My Basics", "ℹ"),
          const SizedBox(height: 12),
          Column(
            children: [
              if (userEducation.isNotEmpty)
                _buildBumbleBasicRow("🎓", "Education", userEducation),
              if (userWork.isNotEmpty)
                _buildBumbleBasicRow("💼", "Work", userWork),
              if (user['height'] != null)
                _buildBumbleBasicRow("📏", "Height", "${user['height']} cm"),
              if (_getUserReligion(user).isNotEmpty)
                _buildBumbleBasicRow("🙏", "Religion", _getUserReligion(user)),
              if (_getUserDrinking(user).isNotEmpty)
                _buildBumbleBasicRow("🍷", "Drinking", _getUserDrinking(user)),
              if (user['smoking']?.toString().isNotEmpty == true)
                _buildBumbleBasicRow(
                    "🚭", "Smoking", user['smoking'].toString()),
              if (user['exercise']?.toString().isNotEmpty == true)
                _buildBumbleBasicRow(
                    "💪", "Exercise", user['exercise'].toString()),
            ],
          ),
          const SizedBox(height: 24),

          // My Interests section
          if (userInterests.isNotEmpty) ...[
            _buildBumbleSectionHeader("My Interests", "❤"),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: userInterests
                  .where((interest) => interest.trim().isNotEmpty)
                  .map((interest) => _buildBumbleInterestChip(interest.trim()))
                  .toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Action buttons
          Container(
            key: _bottomActionsKey,
            child: _buildBumbleActionButtons(user),
          ),
        ],
      ),
    );
  }

  Widget _buildBumbleSectionHeader(String title, String emoji) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildBumbleBasicRow(String emoji, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBumbleInterestChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: DatingColors.yellow.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: DatingColors.yellow.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildBumbleActionButtons(Map<String, dynamic> user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          // Main action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Pass button (Reject)
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  if (!allUsersCompleted) {
                    controller.swipe(CardSwiperDirection.left);
                  }
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.close, color: Colors.grey, size: 30),
                ),
              ),

              // Super Like button
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  if (!allUsersCompleted) {
                    controller.swipe(CardSwiperDirection.top);
                  }
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: DatingColors.yellow,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: DatingColors.yellow.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.star, color: Colors.black, size: 35),
                ),
              ),

              // Like button (Heart)
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  if (!allUsersCompleted) {
                    controller.swipe(CardSwiperDirection.right);
                  }
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: DatingColors.successGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: DatingColors.successGreen.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child:
                      const Icon(Icons.favorite, color: Colors.white, size: 28),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Hide and Report
          GestureDetector(
            onTap: () {
              // Show report dialog
            },
            child: Text(
              "Hide and Report",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Handler methods
  void _handleLike(int index) {
    if (index < allUsers.length) {
      final user = allUsers[index];
      ref.read(likedDislikeProvider.notifier).addLikeDislike(
            user['id'].toString(),
            'right',
          );
    }
  }

  void _handleReject(int index) {
    if (index < allUsers.length) {
      final user = allUsers[index];
      ref.read(likedDislikeProvider.notifier).addLikeDislike(
            user['id'].toString(),
            'left',
          );
    }
  }

  void _handleSuperLike(int index) {
    if (index < allUsers.length) {
      final user = allUsers[index];
      ref.read(likedDislikeProvider.notifier).addLikeDislike(
            user['id'].toString(),
            'super',
          );
    }
  }
}
