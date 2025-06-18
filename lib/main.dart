import 'package:dating/firebase_options.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/screens/logins/loginscreen.dart';
import 'package:dating/screens/profile_screens/chat_pay_Screen.dart';
import 'package:dating/screens/profile_screens/discover_screen.dart';
import 'package:dating/screens/profile_screens/heartsync_screen.dart';
import 'package:dating/screens/profile_screens/liked_Screen.dart';
import 'package:dating/screens/profile_screens/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✅ Add this
// import 'Views/auth/join_page.dart'; // or the correct path to your starting screen
// import 'screens/joinpage.dart';
import 'package:dating/screens/joinpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(
    const ProviderScope( // ✅ Wrap app with this
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer(builder: (context, ref, child) {
       
        // / Attempt auto-login if refresh token is not available
            return FutureBuilder<bool>(
              future: ref.read(loginProvider.notifier).tryAutoLogin(), // Attempt auto-login
              builder: (context, snapshot) {
               
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While waiting for auto-login to finish, show loading indicator
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData &&snapshot.data == true) {
                  // If auto-login is successful and refresh token is available, go to Dashboard
                  return const ProfileScreen();
                } else {
                  // If auto-login fails or no token, redirect to LoginScreen
                  return JoinPageScreen();
                }
              },
            );
        
      }),
      routes: {
         "loginscreen": (context) => LoginScreen(),
         "profilescreen": (context) =>ProfileScreen(),
   
        "discoverscreen": (context) =>const DiscoverScreen(),
    
        "myheartsyncpage": (context) =>const MyHeartsyncPage(),
    
        "likedyouscreen": (context) =>const LikedYouScreen(),
   
        "messagescreen": (context) =>MessagesScreen(),
      },
    );
  }
}
