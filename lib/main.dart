import 'package:dating/firebase_options.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/screens/FriendOnboardingScreen.dart';
import 'package:dating/screens/addHeadlineScreen.dart';
import 'package:dating/screens/beKindScreen.dart';
import 'package:dating/screens/causes_Community.dart';
import 'package:dating/screens/choose_foodies.dart';
import 'package:dating/screens/completeprofile/complete_profile.dart';
import 'package:dating/screens/datePromtSelection.dart';
import 'package:dating/screens/face_screen.dart';
import 'package:dating/screens/familyPlaneScreen.dart';
import 'package:dating/screens/gender_display_screen.dart';
import 'package:dating/screens/genderselection_screen.dart';
import 'package:dating/screens/height_selection_screen.dart';
import 'package:dating/screens/importantLife.dart';
import 'package:dating/screens/introMail.dart';
import 'package:dating/screens/introPage_screen.dart';
import 'package:dating/screens/lifeStryle_habits.dart';
import 'package:dating/screens/location_screen.dart';
import 'package:dating/screens/logins/loginscreen.dart';
import 'package:dating/screens/meet_selection.dart';
import 'package:dating/screens/mode_screen.dart';
import 'package:dating/screens/notification_screen.dart';
import 'package:dating/screens/openingMoveScreen.dart';
import 'package:dating/screens/partners_selections.dart';
import 'package:dating/screens/profile_screens/chat_pay_Screen.dart';
import 'package:dating/screens/profile_screens/discover_screen.dart';
import 'package:dating/screens/profile_screens/heartsync_screen.dart';
import 'package:dating/screens/profile_screens/liked_Screen.dart';
import 'package:dating/screens/profile_screens/narrowsearch.dart';
import 'package:dating/screens/profile_screens/profile_bottomNavigationbar.dart';
import 'package:dating/screens/profile_screens/profile_screen.dart';
import 'package:dating/screens/valueSelection.dart';
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
      //  print("build main.dart");
      //  final authState = ref.watch(loginProvider);
      //       // Watch the authentication state
      //       // Check for a valid access token
      //       final accessToken = authState.data?.isNotEmpty == true
      //           ? authState.data![0].accessToken
      //           : null;
      //       // final status = authState.data?.isNotEmpty == true
      //       //     ? authState.data![0].
      //       //     : null;
      //       print('token/main $accessToken');
      //       // print('status...$status');
      //       // Check if the user has a valid refresh token
      //       if (accessToken != null && accessToken.isNotEmpty 
      //       // && (status=='Active'||status=='active')
      //       ) {
      //         print('navigate to the dashboard....................');
      //         return const  ProfileScreen(); // User is authenticated, redirect to Home
      //       } else {
      //         print('No valid refresh token, trying auto-login');
      //       }
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
                  return const CustomBottomNavigationBar();
                } else {
                  // If auto-login fails or no token, redirect to LoginScreen
                  return JoinPageScreen();
                }
              },
            );
        
      }
      ),
      routes: {
         "/loginscreen" : (context) => LoginScreen(),
         "/locationScreen":(context) => LocationScreen(),
         "/allownotification":(context)=> AllowNotification(),
         "/intropage" :(context) => IntroPageScreen(),
         '/genderstaticselection':(context) => GenderSelectionScreen(),
         "/profileshowscreen":(context) => GenderDisplayScreen(),
         "/emailscreen" :(context) => IntroMail(),
         "/modescreen" :(context) => IntroDatecategory(),
         "/intromeetgender":(context)=> IntroMeetselection(),
         "/partnersSelection":(context)=>InrtoPartneroption(),
         "/heightscreen":(context) =>HeightSelectionScreen(),
         "/interestScreen":(context) => InterestsScreen(),
         "/qualityScreen":(context) => ValuesSelectionScreen(),
         "/habbitsScreen":(context) => LifestyleHabitsScreen(),
         "/familyPlanScreen":(context) =>FamilyPlanScreen(),
         "/religionScreen":(context) => ReligionSelectorWidget(),
         "/causesScreen":(context) => CausesScreen(),
         "/promptsScreen":(context) => DatePromptScreen(),
         "/defaultmessagesScreen":(context) => OpeningMoveScreen(),
         "/photosScreen":(context) => PhotoUploadScreen(),
         "/addheadlinescreen":(context)=>AddHeadlineScreen(),
         "/termsandconditions":(context)=>BeKindScreen(),
         "/finalStageSingupScreen":(context) => FriendOnboardingScreen(),
         "profilescreen" : (context) => ProfileScreen(),
         "discoverscreen": (context) =>const DiscoverScreen(),
         "myheartsyncpage": (context) =>const MyHeartsyncPage(),
         "/narrowsearch":(context) => NarrowSearchScreen() ,
         "likedyouscreen": (context) =>const LikedYouScreen(),
         "messagescreen": (context) => MessagesScreen(),
         "/custombottomnav": (context) => CustomBottomNavigationBar(),
         "/completeprofile": (context) =>BumbleDateProfileScreen(),
      },
    );
  }
}
