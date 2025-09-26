import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/plans/plansfullprovider.dart';
import 'package:dating/screens/tab_bar/spotlight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikedYouScreen extends ConsumerStatefulWidget {
  const LikedYouScreen({super.key});
  @override
  ConsumerState<LikedYouScreen> createState() => _LikedYouState();
}

class _LikedYouState extends ConsumerState<LikedYouScreen> {
  @override
  void initState() {
    super.initState();
    print("✅ Entered LikedYouScreen");
    Future.microtask(() {
      ref.read(plansFullProvider.notifier).getPlans();

      // final socket = ref.watch(socketProvider);

      //   socket.onConnect((_) {
      //     print("✅ Socket connected");

      //     // Emit events
      //     socket.emit('getAvailableUsers');
      //     // socket.emit('getUserPlanPurchases');
      //   });

      //   socket.on('getAvailableUsers', (data) {
      //     print("📡 Likes Data: $data");
      //   });

      //   socket.on('userPlanPurchasesData', (data) {
      //     print("📊 Plan Purchases: $data");
      //   });

      //   socket.onDisconnect((_) {
      //     print("🔌 Socket disconnected");
      //   });

      //  // Listen to WebSocket messages
      // final socket = ref.read(webSocketProvider);
      // socket.stream.listen(
      //   (message) {
      //     print("📩 WebSocket Message: $message");
      //   },
      //   onError: (error) {
      //     print("❌ WebSocket Error: $error");
      //   },
      //   onDone: () {
      //     print("🛑 WebSocket Connection Closed");
      //   },
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(plansFullProvider);
     final plans = model.data ?? [];
     // Separate plans with and without features
    final plansWithoutFeatures = plans.where((p) => 
        p.planType?.features?.isEmpty ?? true).toList();
    
    // Filter top 2 boxes (Spotlight & Superswipe)
    final spotlightPlan = plansWithoutFeatures.where((p) => 
        p.title?.toLowerCase().contains('spotlight') == true).firstOrNull;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Liked You',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, 
        centerTitle: false,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.settings_outlined, color: Colors.black),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "When People Are Into You, They’ll \nAppear Here.\nEnjoy.",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 32),
            Image.asset(
              'assets/Liked_image1.png', // replace with your image asset
              height: 200,
            ),
            const SizedBox(height: 180),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [DatingColors.everqpidColor,DatingColors.everqpidColor],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                onPressed: () {
                  // Add your action here
                 if (spotlightPlan!.typeId!= null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SpotlightScreen(typeId: spotlightPlan.typeId!),
                                  ),
                                );
                              }
                },
                child: const Text(
                  "Try A Spotlight",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 3,),
    );
  }
}
