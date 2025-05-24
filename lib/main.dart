import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✅ Add this
// import 'Views/auth/join_page.dart'; // or the correct path to your starting screen
// import 'screens/joinpage.dart';
import 'package:dating/screens/joinpage.dart';
void main() {
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
      home:JoinPageScreen(), 
      // JoinPageScreen(), // ✅ or whatever your first screen is
    );
  }
}
