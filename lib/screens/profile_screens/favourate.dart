import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/model/likes/likeduser/likedusers.dart';
import 'package:dating/provider/likes/liked/likedprovider.dart';
import 'package:dating/provider/likes/likedislikeprovider.dart';
import 'package:dating/provider/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(likedUsersprovider.notifier).getLikedUsers();
      ref.read(likedDislikeProvider.notifier).getLikedDislike();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DatingColors.white,
      appBar: AppBar(
        backgroundColor: DatingColors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: DatingColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Favourites',
          style: TextStyle(
            color: DatingColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            decoration: BoxDecoration(
              color: DatingColors.white,
              border: Border(
                bottom: BorderSide(
                  color: DatingColors.middlegrey.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: DatingColors.primaryGreen,
              unselectedLabelColor: DatingColors.middlegrey,
              indicatorColor: DatingColors.primaryGreen,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'Liked Me'),
                Tab(text: 'I Liked'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLikedMeTab(),
          _buildILikedTab(),
        ],
      ),
    );
  }

  Widget _buildLikedMeTab() {
    final likedUsers = ref.watch(likedUsersprovider);
    final isLoading = ref.watch(loadingProvider);

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: DatingColors.primaryGreen,
        ),
      );
    }

    if (likedUsers.data == null || likedUsers.data?.isEmpty == true) {
      return _buildEmptyState('No one has liked you yet');
    }

    return _buildUsersList(likedUsers.data ?? []);
  }

  Widget _buildILikedTab() {
    final likeDislikeData = ref.watch(likedDislikeProvider);
    final isLoading = ref.watch(loadingProvider);

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: DatingColors.primaryGreen,
        ),
      );
    }

    // Check if we have any data
    // Note: Your current model has single Data object, not a list
    // You need to update the model to support List<Data> for this to work properly
    
    return _buildEmptyState('You haven\'t liked anyone yet\n\nPlease update LikeDislikeModel to return a list of users');
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: DatingColors.middlegrey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: DatingColors.middlegrey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Start swiping to find your match!',
            style: TextStyle(
              fontSize: 14,
              color: DatingColors.middlegrey.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(List<Data> users) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double crossAxisSpacing;
        double mainAxisSpacing;
        double padding;

        if (constraints.maxWidth < 600) {
          crossAxisCount = 2;
          crossAxisSpacing = 16;
          mainAxisSpacing = 16;
          padding = 16;
        } else if (constraints.maxWidth < 900) {
          crossAxisCount = 3;
          crossAxisSpacing = 20;
          mainAxisSpacing = 20;
          padding = 24;
        } else {
          crossAxisCount = 4;
          crossAxisSpacing = 24;
          mainAxisSpacing = 24;
          padding = 32;
        }

        return Padding(
          padding: EdgeInsets.all(padding),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
              childAspectRatio: 0.65,
            ),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return DynamicProfileCard(user: users[index]);
            },
          ),
        );
      },
    );
  }

  // Build list for "I Liked" tab using LikeDislikeData
  Widget _buildILikedUsersList(List<dynamic> users) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double crossAxisSpacing;
        double mainAxisSpacing;
        double padding;

        if (constraints.maxWidth < 600) {
          crossAxisCount = 2;
          crossAxisSpacing = 16;
          mainAxisSpacing = 16;
          padding = 16;
        } else if (constraints.maxWidth < 900) {
          crossAxisCount = 3;
          crossAxisSpacing = 20;
          mainAxisSpacing = 20;
          padding = 24;
        } else {
          crossAxisCount = 4;
          crossAxisSpacing = 24;
          mainAxisSpacing = 24;
          padding = 32;
        }

        return Padding(
          padding: EdgeInsets.all(padding),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
              childAspectRatio: 0.65,
            ),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final likeData = users[index];
              // Convert LikeDislikeData to Data format for card
              final userData = Data(
                userId: likeData.userId,
                firstName: likeData.firstName,
                lastName: likeData.lastName,
                email: likeData.email,
                image: likeData.image,
                likedAt: likeData.createdAt,
              );
              return DynamicProfileCard(user: userData);
            },
          ),
        );
      },
    );
  }
}

class DynamicProfileCard extends StatelessWidget {
  final Data user;

  const DynamicProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final imageUrl = user.image?.isNotEmpty == true
        ? user.image!
        : 'https://via.placeholder.com/300x400';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          flex: 3,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [DatingColors.primaryGreen, DatingColors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: const EdgeInsets.all(9),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(21),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: DatingColors.middlegrey,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: DatingColors.primaryGreen,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset(
                    'assets/Red_Heart.png',
                    height: 50,
                    width: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.favorite,
                        size: 50,
                        color: Colors.red,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: DatingColors.lightGreen,
            border: Border.all(width: 2, color: DatingColors.primaryGreen),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      _getFullName(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: DatingColors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: DatingColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: DatingColors.white,
                      size: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: DatingColors.darkGreen,
                  ),
                ),
                child: Text(
                  _getFormattedDate(),
                  style: const TextStyle(
                    fontSize: 11,
                    color: DatingColors.middlegrey,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getFullName() {
    final firstName = user.firstName ?? '';
    final lastName = user.lastName ?? '';

    if (firstName.isEmpty && lastName.isEmpty) {
      return 'Unknown User';
    }

    return '$firstName $lastName'.trim();
  }

  String _getFormattedDate() {
    if (user.likedAt == null || user.likedAt?.isEmpty == true) {
      return 'Recently liked';
    }

    try {
      final likedDate = DateTime.parse(user.likedAt!);
      final now = DateTime.now();
      final difference = now.difference(likedDate);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      debugPrint('Error parsing date: $e');
      return 'Recently liked';
    }
  }
}