import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/settings/dark_mode_provider.dart';
import 'package:dating/screens/feedback/general_question.dart';
import 'package:dating/screens/feedback/helpwith_payment.dart';
import 'package:dating/screens/feedback/report_safty_concern.dart';
import 'package:dating/screens/feedback/request_mydate.dart';
import 'package:dating/screens/feedback/technical_issues.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Feedbackpage extends ConsumerStatefulWidget {
  const Feedbackpage({super.key});

  @override
  ConsumerState<Feedbackpage> createState() => FeedbackpageSate();
}

class FeedbackpageSate extends ConsumerState<Feedbackpage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Feedback',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Generalquestionpage()));
              },
              child:_buildFeedbackOption('Ask A General Question'), 
            ),
            
            const SizedBox(height: 16),
               GestureDetector(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HelpwithPayment()));
              },
           child: _buildFeedbackOption('Help With Payment'),
               ),
            const SizedBox(height: 16),
             GestureDetector(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ReportSaftyConcern()));
              },

            child:_buildFeedbackOption('Report A Safety Concern'),
             ),

            const SizedBox(height: 16),
             GestureDetector(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RequestMydate()));
              },

           child: _buildFeedbackOption('Request My Data'),
             ),
            const SizedBox(height: 16),
             GestureDetector(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TechnicalIssues()));
              },

           child: _buildFeedbackOption('Report A Technical Issue'),
             ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackOption(String title) {
    return
//      GestureDetector(
//       onTap: () {
//   Navigator.push(context, MaterialPageRoute(builder: (context) => Generalquestionpage()));
// },
//       child: 
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
      // ),
    );
  }
}