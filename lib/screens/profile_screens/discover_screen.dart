import 'dart:async';
import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../provider/socket_heartsync_provider.dart';
import '../../model/socket_user_model.dart';
import '../../widgets/RecommendationCountdown.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  // Convert dob string ("06/09/2007") → Age in years
  int _calculateAge(String? dobString) {
    if (dobString == null || dobString.isEmpty) return 0;
    try {
      final dob = DateFormat("dd/MM/yyyy").parse(dobString);
      final now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socketState = ref.watch(socketUserProvider);
    final loginState = ref.watch(loginProvider);

    // Get all users from socket
    final users = socketState?.data ?? [];

    // Current logged in user data
    final myUser = loginState?.data?.first.user;

    // Extract my interests
    final myInterests = myUser?.interests
        ?.map((i) => i.interests ?? "")
        .where((i) => i.isNotEmpty)
        .toSet()
        ?? <String>{};

    // Extract my goals (lookingFor)
    final myGoals = myUser?.lookingFor
        ?.map((g) => g.value ?? "")
        .where((g) => g.isNotEmpty)
        .toSet()
        ?? <String>{};

    // Filter: similar interests
    final similarInterestUsers = users.where((user) {
      final userInterests = user.interests
          ?.map((i) => i.interests ?? "")
          .where((i) => i.isNotEmpty)
          .toSet() ?? <String>{};
      return userInterests.any((interest) => myInterests.contains(interest));
    }).toList();

    // Filter: same goals
    final sameGoalUsers = users.where((user) {
      final userGoals = user.lookingFor
          ?.map((g) => g.value ?? "")
          .where((g) => g.isNotEmpty)
          .toSet() ?? <String>{};
      return userGoals.any((goal) => myGoals.contains(goal));
    }).toList();

    return Scaffold(
      backgroundColor: DatingColors.white,
      appBar: AppBar(
        backgroundColor: DatingColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Discover",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.info_outline, color: DatingColors.everqpidColor),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: DatingColors.everqpidColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const RecommendationCountdown(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Discover New Genuine Humans With People\nWho Match Your Vibes, Refreshed Every Day.",
              textAlign: TextAlign.center,
              style: TextStyle(color: DatingColors.everqpidColor, fontSize: 12),
            ),
            const SizedBox(height: 30),
            const Text(
              "Recommended For You",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Carousel Section for Recommended Users
            if (users.isNotEmpty)
              _buildRecommendedCarousel(users.take(5).toList())
            else
              _noDataCard(),

            const SizedBox(height: 40),

            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _gradientCircleButton(Icons.thumb_down_alt_outlined, DatingColors.white),
                _gradientCircleButton(Icons.star_border_outlined, DatingColors.white),
                _gradientCircleButton(Icons.thumb_up_alt_outlined, DatingColors.white),
              ],
            ),
            const SizedBox(height: 50),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: DatingColors.everqpidColor,
                  borderRadius: BorderRadius.circular(1),
                ),
                child: const Text(
                  "Based On Your Profile And Past Matches",
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Similar Interests Section
            const Text("similar interests",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 20),
            _horizontalCardList(similarInterestUsers, "interest"),

            const SizedBox(height: 24),

            // Same Goals Section
            const Text("same dating goals",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 20),
            _horizontalCardList(sameGoalUsers, "goal"),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedCarousel(List<Data> recommendedUsers) {
    return StatefulBuilder(
      builder: (context, setState) {
        int currentIndex = 0;
        PageController pageController = PageController(
          initialPage: 0,
          viewportFraction: 0.85,
        );

        Timer? autoPlayTimer;

        void startAutoPlay() {
          autoPlayTimer?.cancel();
          autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
            if (pageController.hasClients) {
              if (currentIndex < recommendedUsers.length - 1) {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            }
          });
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          startAutoPlay();
        });

        return Column(
          children: [
            SizedBox(
              height: 450,
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemCount: recommendedUsers.length,
                itemBuilder: (context, index) {
                  final user = recommendedUsers[index];
                  final isActive = index == currentIndex;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: isActive ? 0 : 20,
                    ),
                    child: _buildCarouselProfileCard(user, isActive),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                recommendedUsers.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: currentIndex == index ? 24 : 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: currentIndex == index
                        ? DatingColors.everqpidColor
                        : DatingColors.lightgrey.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCarouselProfileCard(Data user, bool isActive) {
    final hasImage = user.profilePics != null && user.profilePics!.isNotEmpty;
    final imgUrl = hasImage ? "http://97.74.93.26:6100${user.profilePics!.first.imagePath}" : null;
    final age = _calculateAge(user.dob);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: DatingColors.everqpidColor.withOpacity(isActive ? 0.3 : 0.1),
            blurRadius: isActive ? 15 : 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: hasImage
                  ? Image.network(
                imgUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: DatingColors.lightgrey.withOpacity(0.3),
                    child: const Icon(Icons.person, size: 120, color: Colors.grey),
                  );
                },
              )
                  : Container(
                color: DatingColors.lightgrey.withOpacity(0.3),
                child: const Icon(Icons.person, size: 120, color: Colors.grey),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.firstName ?? 'Unknown'}${age > 0 ? ', $age' : ''}",
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (user.location?.name != null)
                    Text(
                      "📍 ${user.location!.name}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  const SizedBox(height: 4),
                  const Text(
                    "🟢 Active now",
                    style: TextStyle(color: DatingColors.lightgrey),
                  ),
                ],
              ),
            ),
            if (user.interests != null && user.interests!.isNotEmpty)
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: user.interests!
                      .take(3)
                      .map((interest) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: DatingColors.primaryGreen.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Text(
                      interest.interests ?? "",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _noDataCard() {
    return Container(
      height: 420,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: DatingColors.lightgrey.withOpacity(0.2),
      ),
      child: const Text("No users available yet"),
    );
  }

  Widget _gradientCircleButton(IconData icon, Color iconColor) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [DatingColors.primaryGreen, DatingColors.everqpidColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(color: DatingColors.everqpidColor, blurRadius: 4, offset: Offset(2, 2))
        ],
      ),
      child: Icon(icon, color: iconColor, size: 28),
    );
  }

  Widget _horizontalCardList(List<Data> profiles, String type) {
    if (profiles.isEmpty) {
      return Container(
        height: 270,
        alignment: Alignment.center,
        child: Text(
          "No users found with ${type == 'interest' ? 'similar interests' : 'same dating goals'}",
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return SizedBox(
      height: 270,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: profiles.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (context, index) {
          final user = profiles[index];
          final hasImage = user.profilePics != null && user.profilePics!.isNotEmpty;
          final imgUrl = hasImage ? "http://97.74.93.26:6100${user.profilePics!.first.imagePath}" : null;
          final age = _calculateAge(user.dob);

          List<String> tags = [];
          if (type == "interest" && user.interests != null) {
            tags = user.interests!
                .map((i) => i.interests ?? "")
                .where((i) => i.isNotEmpty)
                .take(2)
                .toList();
          } else if (type == "goal" && user.lookingFor != null) {
            tags = user.lookingFor!
                .map((g) => g.value ?? "")
                .where((g) => g.isNotEmpty)
                .take(2)
                .toList();
          }

          return Container(
            width: 160,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [DatingColors.middlepink, DatingColors.everqpidColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: DatingColors.primaryGreen, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: DatingColors.everqpidColor.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: hasImage
                        ? Image.network(
                      imgUrl!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          width: double.infinity,
                          color: DatingColors.lightgrey.withOpacity(0.3),
                          child: const Icon(Icons.person,
                              size: 60, color: Colors.grey),
                        );
                      },
                    )
                        : Container(
                      height: 120,
                      width: double.infinity,
                      color: DatingColors.lightgrey.withOpacity(0.3),
                      child: const Icon(Icons.person,
                          size: 60, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (tags.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: DatingColors.primaryGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),
                  const Spacer(),
                  Text(
                    "${user.firstName ?? 'Unknown'}${age > 0 ? ', $age' : ''}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
