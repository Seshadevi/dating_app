import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Favourite',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Determine cross axis count based on screen width
          int crossAxisCount;
          double crossAxisSpacing;
          double mainAxisSpacing;
          double padding;

          if (constraints.maxWidth < 600) {
            // Mobile - keep original settings
            crossAxisCount = 2;
            crossAxisSpacing = 16;
            mainAxisSpacing = 16;
            padding = 16;
          } else if (constraints.maxWidth < 900) {
            // Tablet
            crossAxisCount = 3;
            crossAxisSpacing = 20;
            mainAxisSpacing = 20;
            padding = 24;
          } else {
            // Desktop
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
                childAspectRatio: 0.5, // Keep original aspect ratio
              ),
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                return ProfileCard(profile: profiles[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final Profile profile;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile Image with Gradient Border - Keep exact same sizes
        SizedBox(
          height: 250,
          child: Stack(
            children: [
              SizedBox(
                height: 225,
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF869E23), Color(0xFF000000)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: const EdgeInsets.all(9),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      image: DecorationImage(
                        image: NetworkImage(profile.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/Red_Heart.png',
                    height: 50,
                    width: 50,
                  ))
            ],
          ),
        ),
        const SizedBox(height: 4),
        // Profile Info Card - Keep exact same sizes
        Container(
          height: 84,
          width: double.infinity,
          padding: const EdgeInsets.all(8), // Keep original padding
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: const Color(0xFFE9F1C4),
              border: Border.all(width: 2, color: const Color(0xFF869E23))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    // Only added Flexible here to prevent overflow
                    child: Text(
                      profile.name,
                      style: const TextStyle(
                        fontSize: 14, // Keep original font size
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (profile.isVerified)
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 10, // Keep original icon size
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: const Color(0xFF869E23),
                  ),
                ),
                child: Text(
                  profile.distance,
                  style: TextStyle(
                    fontSize: 12, // Keep original font size
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                profile.profession,
                style: TextStyle(
                  fontSize: 10, // Keep original font size
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Profile {
  final String name;
  final String distance;
  final String profession;
  final String imageUrl;
  final bool isVerified;

  Profile({
    required this.name,
    required this.distance,
    required this.profession,
    required this.imageUrl,
    required this.isVerified,
  });
}

// Sample data
final List<Profile> profiles = [
  Profile(
    name: 'Meera',
    distance: '5.2km away',
    profession: 'CIVIL ENGINEER',
    imageUrl:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=400&fit=crop&crop=face',
    isVerified: false,
  ),
  Profile(
    name: 'Halima',
    distance: '5.2km away',
    profession: 'MODEL, USA',
    imageUrl:
        'https://images.unsplash.com/photo-1534751516642-a1af1ef26a56?w=300&h=400&fit=crop&crop=face',
    isVerified: true,
  ),
  Profile(
    name: 'Halima',
    distance: '5.2km away',
    profession: 'MODEL, USA',
    imageUrl:
        'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=300&h=400&fit=crop&crop=face',
    isVerified: true,
  ),
  Profile(
    name: 'Halima',
    distance: '5.2km away',
    profession: 'MODEL, USA',
    imageUrl:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=400&fit=crop&crop=face',
    isVerified: true,
  ),
  Profile(
    name: 'Meera',
    distance: '5.2km away',
    profession: 'CIVIL ENGINEER',
    imageUrl:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=400&fit=crop&crop=face',
    isVerified: false,
  ),
  Profile(
    name: 'Halima',
    distance: '5.2km away',
    profession: 'MODEL, USA',
    imageUrl:
        'https://images.unsplash.com/photo-1534751516642-a1af1ef26a56?w=300&h=400&fit=crop&crop=face',
    isVerified: true,
  ),
  Profile(
    name: 'Halima',
    distance: '5.2km away',
    profession: 'MODEL, USA',
    imageUrl:
        'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=300&h=400&fit=crop&crop=face',
    isVerified: true,
  ),
  Profile(
    name: 'Halima',
    distance: '5.2km away',
    profession: 'MODEL, USA',
    imageUrl:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=400&fit=crop&crop=face',
    isVerified: true,
  ),
];
