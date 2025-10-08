import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/likes/likedislikeprovider.dart';
import 'package:dating/provider/settings/dark_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../animations/love_3d_animation.dart';
// import '../../provider/likedislikeprovider.dart';
import '../../provider/loginProvider.dart';
import '../../provider/socket_heartsync_provider.dart';
import 'package:intl/intl.dart';

import 'narrowsearch.dart';

class MyHeartsyncPage extends ConsumerStatefulWidget {
  const MyHeartsyncPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyHeartsyncPage> createState() => _MyHeartsyncPageState();
}

class _MyHeartsyncPageState extends ConsumerState<MyHeartsyncPage>
    with TickerProviderStateMixin {
  bool isLoadingMore = false;
  final CardSwiperController controller = CardSwiperController();
  int currentUserIndex = 0;
  int viewedUsersCount = 0;
  bool allUsersCompleted = false;

  // Current user location
  double? currentUserLatitude;
  double? currentUserLongitude;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _bottomActionsKey = GlobalKey();
  bool _hideFixedImage = false;
  bool _showOverlay = false;

  // Animation controllers for enhanced UI
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  bool isCardAnimating = false;
  CardSwiperDirection? currentSwipeDirection;

  // Super Like animation controllers
  bool _isSuperLikeAnimating = false;
  late AnimationController _superLikeController;
  late Animation<double> _superLikeScaleAnimation;
  late Animation<double> _superLikeOpacityAnimation;
  late Animation<double> _superLikeGlowAnimation;

  // 3D Like/Dislike animation controllers
  late AnimationController _like3dController;
  late Animation<double> _like3dRotationX;
  late Animation<double> _like3dRotationY;
  late Animation<double> _like3dScale;
  late Animation<double> _like3dOpacity;

  late AnimationController _dislike3dController;
  late Animation<double> _dislike3dRotationX;
  late Animation<double> _dislike3dRotationY;
  late Animation<double> _dislike3dScale;
  late Animation<double> _dislike3dOpacity;

  bool _showLike3DAnimation = false;
  bool _showDislike3DAnimation = false;

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
      duration: const Duration(milliseconds: 800),
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

    // 3D Like animation controller
    _like3dController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _like3dRotationX = Tween<double>(
      begin: 0.0,
      end: 6.28, // 2π radians (full rotation)
    ).animate(_like3dController);

    _like3dRotationY = Tween<double>(
      begin: 0.0,
      end: 3.14, // π radians (half rotation)
    ).animate(_like3dController);

    _like3dScale = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 2.0),
        weight: 0.4,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 2.0, end: 1.5),
        weight: 0.3,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.5, end: 0.0),
        weight: 0.3,
      ),
    ]).animate(_like3dController);

    _like3dOpacity = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        weight: 0.25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 0.50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        weight: 0.25,
      ),
    ]).animate(_like3dController);

    // 3D Dislike animation controller
    _dislike3dController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _dislike3dRotationX = Tween<double>(
      begin: 0.0,
      end: -3.14, // -π radians (reverse rotation)
    ).animate(_dislike3dController);

    _dislike3dRotationY = Tween<double>(
      begin: 0.0,
      end: 6.28, // 2π radians
    ).animate(_dislike3dController);

    _dislike3dScale = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.8),
        weight: 0.60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.8, end: 0.0),
        weight: 0.40,
      ),
    ]).animate(_dislike3dController);

    _dislike3dOpacity = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        weight: 0.40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        weight: 0.60,
      ),
    ]).animate(_dislike3dController);

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    // Initialize slide animation with default values
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(1.5, -0.2),
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

    // Add status listeners for 3D animations
    _like3dController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _showLike3DAnimation = false);
        _like3dController.reset();
      }
    });

    _dislike3dController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _showDislike3DAnimation = false);
        _dislike3dController.reset();
      }
    });

    // Add status listener for slide animation
    _slideController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isCardAnimating = false;
        });
        _slideController.reset();
      }
    });

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
    _like3dController.dispose();
    _dislike3dController.dispose();
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

  // Helper to calculate age from DOB string in 'dd/MM/yyyy' format
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

  String getCompleteImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    if (imagePath.startsWith('http')) {
      return imagePath;
    } else {
      return 'http://97.74.93.26:6100$imagePath';
    }
  }

  void _triggerLike3DAnimation() {
    setState(() {
      _showLike3DAnimation = true;
      _showDislike3DAnimation = false;
    });
    _like3dController.forward();
    HapticFeedback.heavyImpact();
  }

  void _triggerDislike3DAnimation() {
    setState(() {
      _showDislike3DAnimation = true;
      _showLike3DAnimation = false;
    });
    _dislike3dController.forward();
    HapticFeedback.mediumImpact();
  }

  void _superLikeFromFloatingButton() {
    if (_isSuperLikeAnimating || allUsersCompleted) return;

    _floatingStarController.reverse();
    handleSuperLike();
  }

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

  // Handle like action with card movement
  Future<void> handleLike() async {
    if (isCardAnimating) return;

    setState(() {
      isCardAnimating = true;
      currentSwipeDirection = CardSwiperDirection.right;
    });

    // Update slide animation for right swipe
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(1.5, -0.2),
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeInOut));

    _slideController.forward(from: 0.0);
    _triggerLike3DAnimation();

    final socketUsers = ref.read(socketUserProvider);
    final users = socketUsers?.data ?? [];

    if (users.isNotEmpty && currentUserIndex < users.length) {
      final currentUser = users[currentUserIndex];
      try {
        await ref.read(likedDislikeProvider.notifier).addLikeDislike(
              currentUser.id?.toString() ?? "",
              "right",
            );

        Future.delayed(const Duration(milliseconds: 900), () {
          _moveToNextUser();
        });
      } catch (error) {
        _showErrorSnackBar("Failed to like user");
        setState(() {
          isCardAnimating = false;
        });
      }
    }
  }

  Future<void> handleDislike() async {
    if (isCardAnimating) return;

    setState(() {
      isCardAnimating = true;
      currentSwipeDirection = CardSwiperDirection.left;
    });

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-1.5, -0.1),
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeInOut));

    _slideController.forward(from: 0.0);
    _triggerDislike3DAnimation();

    final socketUsers = ref.read(socketUserProvider);
    final users = socketUsers?.data ?? [];

    if (users.isNotEmpty && currentUserIndex < users.length) {
      final currentUser = users[currentUserIndex];
      try {
        await ref.read(likedDislikeProvider.notifier).addLikeDislike(
              currentUser.id?.toString() ?? "",
              "left",
            );

        Future.delayed(const Duration(milliseconds: 900), () {
          _moveToNextUser();
        });
      } catch (error) {
        _showErrorSnackBar("Failed to dislike user");
        setState(() {
          isCardAnimating = false;
        });
      }
    }
  }

  // Handle super like action with card movement
  Future<void> handleSuperLike() async {
    if (isCardAnimating) return;

    setState(() {
      isCardAnimating = true;
      currentSwipeDirection = CardSwiperDirection.top;
    });

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -1.5),
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeInOut));

    _slideController.forward(from: 0.0);
    _animateSuperLikeOnImage();

    HapticFeedback.mediumImpact();

    final socketUsers = ref.read(socketUserProvider);
    final users = socketUsers?.data ?? [];

    if (users.isNotEmpty && currentUserIndex < users.length) {
      final currentUser = users[currentUserIndex];
      try {
        await ref.read(likedDislikeProvider.notifier).addLikeDislike(
              currentUser.id?.toString() ?? "",
              "up",
            );

        Future.delayed(const Duration(milliseconds: 900), () {
          _moveToNextUser();
        });
      } catch (error) {
        _showErrorSnackBar("Failed to super like user");
        setState(() {
          isCardAnimating = false;
        });
      }
    }
  }

  // Move to next user logic
  void _moveToNextUser() {
    final socketUsers = ref.read(socketUserProvider);
    final users = socketUsers?.data ?? [];

    setState(() {
      viewedUsersCount++;
      currentUserIndex++;
    });

    // Check if we need to fetch more users
    if (currentUserIndex >= users.length - 3) {
      final notifier = ref.read(socketUserProvider.notifier);
      notifier.fetchNextPageIfNeeded(currentUserIndex);
    }

    // Check if no more users available
    if (currentUserIndex >= users.length) {
      setState(() {
        allUsersCompleted = true;
        _showFloatingStar = false;
      });
      _floatingStarController.reverse();
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildCompletionMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite,
            size: 80,
            color: DatingColors.everqpidColor,
          ),
          const SizedBox(height: 20),
          const Text(
            'No more users to show!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Check back later for new matches',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() {
                currentUserIndex = 0;
                allUsersCompleted = false;
                _showFloatingStar = true;
              });
              ref.read(socketUserProvider.notifier).refresh();
              _floatingStarController.forward();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: DatingColors.everqpidColor,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: const Text(
              'Refresh',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Widget for chips with optional icon
  Widget labeledChip(String label,bool isDarkMode,{IconData? icon}) {
    return Chip(
      avatar: icon != null ? Icon(icon, size: 20) : null,
      label: Text(label, style: TextStyle(fontSize: 16,color: isDarkMode? DatingColors.white : DatingColors.black, )),
      backgroundColor:  DatingColors.lightgrey,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    );
  }

  // Section title widget
  Widget sectionTitle(String title,bool isDarkMode, {double? fontSize}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize ?? 16,
          color: isDarkMode ? DatingColors.white : DatingColors.black
        ),
      ),
    );
  }

  Widget _buildFloatingSuperLikeButton() {
    return AnimatedBuilder(
      animation: _floatingStarOpacity,
      builder: (context, child) {
        if (!_showFloatingStar) return const SizedBox.shrink();
        return Positioned(
          bottom: 40,
          right: 20,
          child: Opacity(
            opacity: _floatingStarOpacity.value,
            child: GestureDetector(
              onTap: _superLikeFromFloatingButton,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: DatingColors.everqpidColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: DatingColors.everqpidColor.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 3D Like Animation Widget
  Widget _build3dLikeAnimation() {
    return AnimatedBuilder(
      animation: _like3dController,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(_like3dRotationX.value)
            ..rotateY(_like3dRotationY.value)
            ..scale(_like3dScale.value),
          child: Opacity(
            opacity: _like3dOpacity.value,
            child: CustomPaint(
              size: const Size(220, 220),
              painter: HeartBlastPainter(
                progress: _like3dOpacity.value,
                particles: [],
              ),
            ),
          ),
        );
      },
    );
  }

  // 3D Dislike Animation Widget
  Widget _build3dDislikeAnimation() {
    return AnimatedBuilder(
      animation: _dislike3dController,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateX(_dislike3dRotationX.value)
            ..rotateY(_dislike3dRotationY.value)
            ..scale(_dislike3dScale.value),
          child: Opacity(
            opacity: _dislike3dOpacity.value,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.grey.shade400.withOpacity(0.9),
                    Colors.grey.shade600.withOpacity(0.7),
                    Colors.grey.shade800.withOpacity(0.5),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    blurRadius: 25,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Multiple X icons for depth
                  Transform.scale(
                    scale: 0.6,
                    child: Icon(
                      Icons.close,
                      color: Colors.white.withOpacity(0.3),
                      size: 120,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: Icon(
                      Icons.close,
                      color: Colors.white.withOpacity(0.6),
                      size: 100,
                    ),
                  ),
                  Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 70,
                  ),
                  // Crack effects
                  Positioned(
                    top: 50,
                    left: 60,
                    child: Transform.rotate(
                      angle: _dislike3dRotationY.value * 0.3,
                      child: Container(
                        width: 2,
                        height: 35,
                        color: Colors.grey.shade300.withOpacity(0.7),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    right: 50,
                    child: Transform.rotate(
                      angle: -_dislike3dRotationX.value * 0.2,
                      child: Container(
                        width: 30,
                        height: 2,
                        color: Colors.grey.shade300.withOpacity(0.7),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 80,
                    right: 70,
                    child: Transform.rotate(
                      angle: _dislike3dRotationY.value * 0.5,
                      child: Container(
                        width: 20,
                        height: 2,
                        color: Colors.grey.shade200.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final isDarkMode = ref.watch(darkModeProvider);

    final socketUsers = ref.watch(socketUserProvider);
    final users = socketUsers?.data ?? [];
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    if (users.isEmpty && socketUsers?.pagination != true) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor ,
        body: Center(
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
                      child: const Icon(Icons.favorite,
                          color: Colors.white, size: 40),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "Finding Perfect Matches...",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (allUsersCompleted || currentUserIndex >= users.length) {
      return Scaffold(
         backgroundColor: Theme.of(context).scaffoldBackgroundColor ,
        body: _buildCompletionMessage(),
      );
    }

    final user = users[currentUserIndex];

    return Scaffold(
       backgroundColor: Theme.of(context).scaffoldBackgroundColor ,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragEnd: (details) {
          final velocity = details.velocity.pixelsPerSecond.dx;
          if (velocity > 300) {
            // Swipe right - like
            handleLike();
          } else if (velocity < -300) {
            // Swipe left - dislike
            handleDislike();
          }
        },
        child: Stack(
          children: [
            // Main scrollable content
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Photo container with slide animation and swipe gestures

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Next image logic (cycle back to zero when at end)
                        var images = user.profilePics ?? [];
                        if (images.isNotEmpty) {
                          _currentImageIndex =
                              (_currentImageIndex + 1) % images.length;
                        }
                      });
                    },
                    child: Container(
                      height: screenHeight * 0.95,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                        image: user.profilePics != null &&
                                user.profilePics!.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(getCompleteImageUrl(user
                                    .profilePics![_currentImageIndex]
                                    .imagePath)),
                                fit: BoxFit.cover,
                              )
                            : const DecorationImage(
                                image: AssetImage('assets/default_profile.png'),
                                fit: BoxFit.cover,
                              ),
                      ),
                      child: Stack(
                        children: [
                          // Gradient overlay at bottom
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 150,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Colors.black87, Colors.transparent],
                                ),
                              ),
                            ),
                          ),
                          // Name and age
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Text(
                              '${user.firstName ?? "User name"}, ${_calculateAge(user.dob)}',
                              style: TextStyle(
                                color: DatingColors.white,
                                fontSize: screenWidth * 0.07,
                                fontWeight: FontWeight.bold,
                                shadows: const [
                                  Shadow(
                                    blurRadius: 8,
                                    color: DatingColors.black,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_isSuperLikeAnimating)
                            Center(
                                child: AnimatedBuilder(
                              animation: _superLikeScaleAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _superLikeScaleAnimation.value,
                                  child: Opacity(
                                    opacity: _superLikeOpacityAnimation.value,
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: DatingColors.everqpidColor,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: DatingColors.everqpidColor
                                                .withOpacity(
                                                    _superLikeGlowAnimation
                                                        .value),
                                            blurRadius: 30,
                                            spreadRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )),
                          if (_showLike3DAnimation)
                            Center(child: _build3dLikeAnimation()),
                          if (_showDislike3DAnimation)
                            Center(child: _build3dDislikeAnimation()),
                        ],
                      ),
                    ),
                  ),

                  // Content sections below image
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: Container(
                      color: isDarkMode? DatingColors.black : DatingColors.white,
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.025),

                          // About Me Section
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                            child: Container(
                              width: screenWidth,
                              padding: EdgeInsets.all(screenWidth * 0.02),
                              
                              decoration: BoxDecoration(
                                color: isDarkMode? DatingColors.black : DatingColors.white,
                                border: Border.all(color: DatingColors.everqpidColor)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  sectionTitle('About me', isDarkMode,
                                      fontSize: screenWidth * 0.05),
                                  Wrap(
                                    spacing: screenWidth * 0.02,
                                    runSpacing: screenHeight * 0.02,
                                    children: [
                                      if (user.height != null)
                                        labeledChip('${user.height} cm',isDarkMode,
                                            icon: Icons.straighten),
                                      if (user.exercise != null)
                                        labeledChip(user.exercise ?? '',isDarkMode,
                                            icon: Icons.fitness_center),
                                      if (user.gender != null)
                                        labeledChip(user.gender ?? '',isDarkMode,
                                            icon: Icons.person),
                                      if (user.haveKids != null)
                                        labeledChip(user.haveKids ?? '',isDarkMode,
                                            icon: Icons.child_care),
                                      if (user.religions != null)
                                        ...user.religions!
                                            .map((r) => labeledChip(
                                                r.religion ?? '',isDarkMode,
                                                icon: Icons.temple_hindu))
                                            .toList(),
                                      if (user.newToArea != null)
                                        labeledChip(user.newToArea ?? '',isDarkMode,
                                            icon: Icons.home_work),
                                      if (user.drinking != null)
                                        ...user.drinking!
                                            .map((d) => labeledChip(
                                                d.preference ?? '',isDarkMode,
                                                icon: Icons.local_bar))
                                            .toList(),
                                      if (user.smoking != null)
                                        labeledChip(user.smoking ?? '',isDarkMode,
                                            icon: Icons.smoking_rooms),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          // I'm Looking For Section
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 1,
                            child: Container(
                              width: screenWidth,
                              padding: EdgeInsets.all(screenWidth * 0.04),
                             
                              decoration: BoxDecoration(
                                color: isDarkMode? DatingColors.black : DatingColors.white,
                                border: Border.all(color: DatingColors.everqpidColor)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  sectionTitle('I\'m Looking For',isDarkMode,
                                      fontSize: screenWidth * 0.05),
                                  Wrap(
                                    spacing: screenWidth * 0.1,
                                    runSpacing: screenHeight * 0.01,
                                    children: user.lookingFor != null
                                        ? user.lookingFor!
                                            .map((lf) => labeledChip(
                                                lf.value ?? '',isDarkMode,
                                                icon: Icons.search))
                                            .toList()
                                        : [],
                                  )
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          // My Interests Section
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 3,
                            child: Container(
                              width: screenWidth,
                              padding: EdgeInsets.all(screenWidth * 0.02),
                               decoration: BoxDecoration(
                                color: isDarkMode? DatingColors.black : DatingColors.white,
                                border: Border.all(color: DatingColors.everqpidColor)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  sectionTitle('My Interests',isDarkMode,
                                      fontSize: screenWidth * 0.05),
                                  Wrap(
                                    spacing: screenWidth * 0.02,
                                    runSpacing: screenHeight * 0.01,
                                    children: user.interests != null
                                        ? user.interests!
                                            .map((interest) => labeledChip(
                                                interest.interests ?? '',isDarkMode,
                                                icon: Icons.local_activity))
                                            .toList()
                                        : [],
                                  )
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          // Favorite qualities Section
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 3,
                            child: Container(
                              width: screenWidth,
                              padding: EdgeInsets.all(screenWidth * 0.02),
                               decoration: BoxDecoration(
                                color: isDarkMode? DatingColors.black : DatingColors.white,
                                border: Border.all(color: DatingColors.everqpidColor)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  sectionTitle('Favorite qualities',isDarkMode,
                                      fontSize: screenWidth * 0.05),
                                  Wrap(
                                    spacing: screenWidth * 0.02,
                                    runSpacing: screenHeight * 0.01,
                                    children: user.qualities != null
                                        ? user.qualities!
                                            .map((quality) => labeledChip(
                                                quality.name ?? '',isDarkMode,
                                                icon: Icons.star))
                                            .toList()
                                        : [],
                                  )
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          // Languages Section
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            elevation: 3,
                            child: Container(
                              width: screenWidth,
                              padding: EdgeInsets.all(screenWidth * 0.02),
                               decoration: BoxDecoration(
                                color: isDarkMode? DatingColors.black : DatingColors.white,
                                border: Border.all(color: DatingColors.everqpidColor)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  sectionTitle('Languages',isDarkMode,
                                      fontSize: screenWidth * 0.05),
                                  Wrap(
                                    spacing: screenWidth * 0.02,
                                    runSpacing: screenHeight * 0.01,
                                    children: user.spokenLanguages != null
                                        ? user.spokenLanguages!
                                            .map((lang) => labeledChip(
                                                lang.name ?? '',isDarkMode,
                                                icon: Icons.language))
                                            .toList()
                                        : [],
                                  )
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          // My Location Section
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 3,
                            child: Container(
                              width: screenWidth,
                              padding: EdgeInsets.all(screenWidth * 0.02),
                               decoration: BoxDecoration(
                                color: isDarkMode? DatingColors.black : DatingColors.white,
                                border: Border.all(color: DatingColors.everqpidColor)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  sectionTitle('My Location',isDarkMode,
                                      fontSize: screenWidth * 0.05),
                                  if (user.location != null &&
                                      user.location!.name != null)
                                    labeledChip(user.location!.name ?? '',isDarkMode,
                                        icon: Icons.location_on),
                                  if (user.hometown != null)
                                    labeledChip(user.hometown ?? '',isDarkMode,
                                        icon: Icons.home),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // Action Buttons Row with functionality
                          Row(
                            key: _bottomActionsKey,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: screenWidth * 0.08,
                                backgroundColor: Colors.redAccent.shade100,
                                child: IconButton(
                                  icon: Icon(Icons.close,
                                      color: Colors.white,
                                      size: screenWidth * 0.08),
                                  onPressed: handleDislike,
                                ),
                              ),
                              CircleAvatar(
                                radius: screenWidth * 0.08,
                                backgroundColor: DatingColors.everqpidColor,
                                child: IconButton(
                                  icon: Icon(Icons.star,
                                      color: Colors.white,
                                      size: screenWidth * 0.08),
                                  onPressed: handleSuperLike,
                                ),
                              ),
                              CircleAvatar(
                                radius: screenWidth * 0.08,
                                backgroundColor: DatingColors.darkGreen,
                                child: IconButton(
                                  icon: Icon(Icons.favorite,
                                      color: Colors.white,
                                      size: screenWidth * 0.08),
                                  onPressed: handleLike,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.05),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Floating overlay app bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDarkMode ? DatingColors.black : Colors.white.withOpacity(0.9),
                    border: Border.all(color: DatingColors. everqpidColor),
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
                            colors: [
                              DatingColors.everqpidColor,
                              DatingColors.lightpink
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.favorite,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                       Expanded(
                        child: Text(
                          'EVER QPID',
                          style: TextStyle(
                            color: isDarkMode ? DatingColors.white : DatingColors.black,
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
                          icon: Icon(Icons.tune,
                              color: DatingColors.secondaryText),
                          onPressed: () async {
                            HapticFeedback.lightImpact();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NarrowSearchScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Floating star button
            _buildFloatingSuperLikeButton(),
          ],
        ),
      ),
    );
  }
}
