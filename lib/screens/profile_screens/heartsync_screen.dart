
import 'package:dating/model/loginmodel.dart';
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
    print("PeoplesModel: ${peoplesModel}");
    print("Users: ${peoplesModel.users}");


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          'Heart Sync',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: const [Icon(Icons.more_vert, color: Colors.black), SizedBox(width: 16)],
      ),
      body: users.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("No users available", style: TextStyle(fontSize: 18, color: Colors.grey))
                ],
              ),
            )
          : CardSwiper(
              controller: controller,
              cardsCount: users.length,
              numberOfCardsDisplayed: 1,
              isLoop: false,
              onSwipe: (previousIndex, currentIndex, direction) {
                if (currentIndex == users.length - 1 && !isLoadingMore) {
                  setState(() => isLoadingMore = true);
                  ref.read(peoplesProvider.notifier).getPeoplesAll().then((_) {
                    setState(() => isLoadingMore = false);
                  });
                }
                return true;
              },
              cardBuilder: (BuildContext context, int index, int hOffset, int vOffset) {
                return _buildUserCard(users[index]);
              },
            ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    );
  }

  Widget _buildUserCard(Users user) {
    final profilePic = user.profilePics?.firstWhere(
      (pic) => pic.isPrimary == true,
      orElse: () => ProfilePics(url: null),
    )?.url;

    final fullUrl = profilePic != null && profilePic.isNotEmpty
        ? 'https://yourdomain.com$profilePic'
        : null;


return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: fullUrl != null
                    ? Image.network(
                        fullUrl,
                        width: double.infinity,
                        height: 350,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.grey[300],
                        height: 350,
                        child: const Center(child: Icon(Icons.broken_image, size: 80, color: Colors.grey)),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 26,
                      child: const Icon(Icons.close, color: Colors.black),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.pinkAccent,
                      radius: 30,
                      child: const Icon(Icons.favorite, color: Colors.white),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.green[300],
                      radius: 26,
                      child: const Icon(Icons.star, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.firstName ?? ''}, ${_getAge(user.dob ?? '')}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.bio ?? '',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    const Text("About", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      user.bio ?? 'No bio available.',
                      style: const TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text("Interest", style: TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: user.qualities?.map((e) => _buildChip(e.name ?? '', icon: Icons.interests)).toList() ?? [],
                    ),
                    const SizedBox(height: 16),
                    const Text("About Me", style: TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _infoChip("📏", user.height ?? ''),
                        _infoChip("📖", user.education ?? ''),
                        _infoChip("♐️", user.zodiac ?? ''),
                        _infoChip("🍷", user.drinking?.firstOrNull?.preference ?? ''),
                        _infoChip("🪷", user.religions?.firstOrNull?.religion ?? ''),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text("I Am Looking For", style: TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
          
          
          spacing: 6,
                      runSpacing: 6,
                      children: user.age?.map((e) => _buildChip(e.goal ?? '', icon: Icons.favorite_outline))?.toList() ?? [],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, {IconData? icon}) {
    return Chip(
      backgroundColor: const Color(0xFFF0F0F0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      avatar: icon != null ? Icon(icon, size: 16, color: Colors.black54) : null,
      label: Text(label, style: const TextStyle(color: Colors.black87)),
    );
  }

  Widget _infoChip(String emoji, String label) {
    return Chip(
      label: Text('$emoji $label'),
      backgroundColor: const Color(0xFFEFEFEF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  String _getAge(String dob) {
    try {
      final birthDate = DateTime.parse(dob);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return '$age';
    } catch (e) {
      return '';
    }
  }
}