// import 'package:dating/constants/dating_app_user.dart';
// import 'package:flutter/material.dart';

// class FavoritesScreen extends StatelessWidget {
//   const FavoritesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: DatingColors.white,
//       appBar: AppBar(
//         backgroundColor: DatingColors.white,
//         elevation: 1,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: DatingColors.black
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'My Favourite',
//           style: TextStyle(
//             color: DatingColors.black,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           // Determine cross axis count based on screen width
//           int crossAxisCount;
//           double crossAxisSpacing;
//           double mainAxisSpacing;
//           double padding;

//           if (constraints.maxWidth < 600) {
//             // Mobile - keep original settings
//             crossAxisCount = 2;
//             crossAxisSpacing = 16;
//             mainAxisSpacing = 16;
//             padding = 16;
//           } else if (constraints.maxWidth < 900) {
//             // Tablet
//             crossAxisCount = 3;
//             crossAxisSpacing = 20;
//             mainAxisSpacing = 20;
//             padding = 24;
//           } else {
//             // Desktop
//             crossAxisCount = 4;
//             crossAxisSpacing = 24;
//             mainAxisSpacing = 24;
//             padding = 32;
//           }

//           return Padding(
//             padding: EdgeInsets.all(padding),
//             child: GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: crossAxisCount,
//                 crossAxisSpacing: crossAxisSpacing,
//                 mainAxisSpacing: mainAxisSpacing,
//                 childAspectRatio: 0.5, // Keep original aspect ratio
//               ),
//               itemCount: profiles.length,
//               itemBuilder: (context, index) {
//                 return ProfileCard(profile: profiles[index]);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class ProfileCard extends StatelessWidget {
//   final Profile profile;

//   const ProfileCard({super.key, required this.profile});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Profile Image with Gradient Border - Keep exact same sizes
//         SizedBox(
//           height: 250,
//           child: Stack(
//             children: [
//               SizedBox(
//                 height: 225,
//                 width: double.infinity,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     gradient: const LinearGradient(
//                       colors: [DatingColors.primaryGreen, DatingColors.black],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                   ),
//                   padding: const EdgeInsets.all(9),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(21),
//                       image: DecorationImage(
//                         image: NetworkImage(profile.imageUrl),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Image.asset(
//                     'assets/Red_Heart.png',
//                     height: 50,
//                     width: 50,
//                   ))
//             ],
//           ),
//         ),
//         const SizedBox(height: 4),
//         // Profile Info Card - Keep exact same sizes
//         Container(
//           height: 84,
//           width: double.infinity,
//           padding: const EdgeInsets.all(8), // Keep original padding
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(25),
//               color: DatingColors.lightGreen,
//               border: Border.all(width: 2, color: DatingColors.primaryGreen)),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Flexible(
//                     // Only added Flexible here to prevent overflow
//                     child: Text(
//                       profile.name,
//                       style: const TextStyle(
//                         fontSize: 14, // Keep original font size
//                         fontWeight: FontWeight.w600,
//                         color: DatingColors.black,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   if (profile.isVerified)
//                     Row(
//                       children: [
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Container(
//                           padding: const EdgeInsets.all(2),
//                           decoration: const BoxDecoration(
//                             color: DatingColors.primaryGreen,
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.check,
//                             color: DatingColors.white,
//                             size: 10, // Keep original icon size
//                           ),
//                         ),
//                       ],
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 2),
//               Container(
//                 padding: const EdgeInsets.all(3),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(
//                     width: 1,
//                     color: DatingColors.darkGreen,
//                   ),
//                 ),
//                 child: Text(
//                   profile.distance,
//                   style: TextStyle(
//                     fontSize: 12, // Keep original font size
//                     color: DatingColors.middlegrey,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               const SizedBox(height: 1),
//               Text(
//                 profile.profession,
//                 style: TextStyle(
//                   fontSize: 10, // Keep original font size
//                   color: DatingColors.middlegrey,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class Profile {
//   final String name;
//   final String distance;
//   final String profession;
//   final String imageUrl;
//   final bool isVerified;

//   Profile({
//     required this.name,
//     required this.distance,
//     required this.profession,
//     required this.imageUrl,
//     required this.isVerified,
//   });
// }

// // Sample data
// final List<Profile> profiles = [
//   Profile(
//     name: 'Meera',
//     distance: '5.2km away',
//     profession: 'CIVIL ENGINEER',
//     imageUrl:
//         'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=400&fit=crop&crop=face',
//     isVerified: false,
//   ),
//   Profile(
//     name: 'Halima',
//     distance: '5.2km away',
//     profession: 'MODEL, USA',
//     imageUrl:
//         'https://images.unsplash.com/photo-1534751516642-a1af1ef26a56?w=300&h=400&fit=crop&crop=face',
//     isVerified: true,
//   ),
//   Profile(
//     name: 'Halima',
//     distance: '5.2km away',
//     profession: 'MODEL, USA',
//     imageUrl:
//         'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=300&h=400&fit=crop&crop=face',
//     isVerified: true,
//   ),
//   Profile(
//     name: 'Halima',
//     distance: '5.2km away',
//     profession: 'MODEL, USA',
//     imageUrl:
//         'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=400&fit=crop&crop=face',
//     isVerified: true,
//   ),
//   Profile(
//     name: 'Meera',
//     distance: '5.2km away',
//     profession: 'CIVIL ENGINEER',
//     imageUrl:
//         'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=400&fit=crop&crop=face',
//     isVerified: false,
//   ),
//   Profile(
//     name: 'Halima',
//     distance: '5.2km away',
//     profession: 'MODEL, USA',
//     imageUrl:
//         'https://images.unsplash.com/photo-1534751516642-a1af1ef26a56?w=300&h=400&fit=crop&crop=face',
//     isVerified: true,
//   ),
//   Profile(
//     name: 'Halima',
//     distance: '5.2km away',
//     profession: 'MODEL, USA',
//     imageUrl:
//         'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=300&h=400&fit=crop&crop=face',
//     isVerified: true,
//   ),
//   Profile(
//     name: 'Halima',
//     distance: '5.2km away',
//     profession: 'MODEL, USA',
//     imageUrl:
//         'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=400&fit=crop&crop=face',
//     isVerified: true,
//   ),
// ];
import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/model/likes/likeduser/likedusers.dart';
import 'package:dating/provider/likes/liked/likedprovider.dart';
import 'package:dating/provider/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(likedUsersprovider.notifier).getLikedUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final likedUsers = ref.watch(likedUsersprovider);
    final isLoading = ref.watch(loadingProvider);

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
          'My Favourite',
          style: TextStyle(
            color: DatingColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: DatingColors.primaryGreen,
              ),
            )
          : (likedUsers.data == null || likedUsers.data?.isEmpty == true)
              ? _buildEmptyState()
              : _buildUsersList(likedUsers.data ?? []),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 40,
            color: DatingColors.middlegrey,
          ),
          const SizedBox(height: 16),
          Text(
            'No Favorites Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: DatingColors.middlegrey,
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
              childAspectRatio: 0.65, // Adjusted for better proportions
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
        // Image Section with Dynamic Height
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
        // Info Section with Dynamic Height
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