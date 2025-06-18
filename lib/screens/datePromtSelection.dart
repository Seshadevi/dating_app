
import 'package:dating/screens/editprompt_screen.dart';
import 'package:dating/screens/face_screen.dart';
import 'package:flutter/material.dart';

class DatePromptScreen extends StatefulWidget {
  final String email;
  final double latitude;
  final double longitude;
  final String userName;
  final String dateOfBirth;
  final String selectedGender;
  final bool showGenderOnProfile;
  final dynamic showMode;
  final String? gendermode;
  final dynamic selectionOptionIds;
  final dynamic selectedHeight;
  final List<int> selectedInterestIds;
  final List<int> selectedqualitiesIDs;
  final List<int> selectedhabbits;
  final List<int> selectedkids;
  final List<int> selectedreligions;
  final List<int> selectedcauses;

  DatePromptScreen({
    super.key,
    required this.email,
    required this.latitude,
    required this.longitude,
    required this.userName,
    required this.dateOfBirth,
    required this.selectedGender,
    required this.showGenderOnProfile,
    this.showMode,
    this.gendermode,
    this.selectionOptionIds,
    this.selectedHeight,
    required this.selectedInterestIds,
    required this.selectedqualitiesIDs,
    required this.selectedhabbits,
    required this.selectedkids,
    required this.selectedreligions,
    required this.selectedcauses,
  });

  @override
  _DatePromptScreenState createState() => _DatePromptScreenState();
}

class _DatePromptScreenState extends State<DatePromptScreen> {
  final List<String> allPrompts = [
    "Write Your Own Opening Move Prompt",
    "Window Seat Or Aisle? Convince ……",
    "The Key To My Heart Is ……",
  ];

  // Track which prompts are selected and their answers
  Map<int, String> selectedPrompts = {}; // index -> answer
  
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress bar
              LinearProgressIndicator(
                value: 16 / 18,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 147, 179, 3),
                ),
              ),
              const SizedBox(height: 10),

              // Top row: Back button and Skip
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigate back to previous screen (CausesScreen)
                    },
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      // Skip to next screen
                      // _navigateToNextScreen();
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title
              const Text(
                "Choose Five Things\nYou Are Really Into",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10),

              // Subtitle
              Text(
                "A Joy, Obviously, But Go Ahead\nAnd Answer In Your Own Words.",
                style: TextStyle(
                  color: Colors.grey[700],
                  height: 1.4,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),

              // Prompt List
              Expanded(
                child: ListView.builder(
                  itemCount: allPrompts.length,
                  itemBuilder: (context, index) =>
                      _buildPromptTile(allPrompts[index], index),
                ),
              ),

              // Bottom Row
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${selectedPrompts.length}/3 Selected"),
                    Row(
                      children: [
                        // Forward Arrow Button - only enabled if at least 2 prompts selected
                        Material(
                          elevation: 6,
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            width: screen.width * 0.125,
                            height: screen.width * 0.125,
                            decoration: BoxDecoration(
                              gradient: selectedPrompts.length >= 2
                                  ? const LinearGradient(
                                      colors: [Color(0xffB2D12E), Color(0xff000000)],
                                    )
                                  : LinearGradient(
                                      colors: [Colors.grey[400]!, Colors.grey[600]!],
                                    ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios,
                                  color: Colors.white),
                              onPressed: () => { 
                                if(selectedPrompts.length >= 2){
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PhotoUploadScreen(),
                                          ),
                                        )
                                }
                                else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please add 2 prompts")),
                                )
                                }
                              }
                                                      
                                  
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromptTile(String label, int index) {
    bool isSelected = selectedPrompts.containsKey(index);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFF869E23), Color(0xFF000000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isSelected && selectedPrompts[index]!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      selectedPrompts[index]!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              if (isSelected) ...[
                // Edit button
                GestureDetector(
                  onTap: () => _editPrompt(index, label),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: const Text(
                      "Edit",
                     style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Delete button
                GestureDetector(
                  onTap: () => _deletePrompt(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ] else
                // Add button
                GestureDetector(
                  onTap: () => _addPrompt(index, label),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: const Text(
                      "Add",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _addPrompt(int index, String promptText) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PromptEditScreen(
          promptText: promptText,
          onSave: (answer) {
            setState(() {
              selectedPrompts[index] = answer;
            });
          },
        ),
      ),
    );
  }

  void _editPrompt(int index, String promptText) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PromptEditScreen(
          promptText: promptText,
          initialAnswer: selectedPrompts[index] ?? '',
          onSave: (answer) {
            setState(() {
              selectedPrompts[index] = answer;
            });
          },
        ),
      ),
    );
  }

  void _deletePrompt(int index) {
    setState(() {
      selectedPrompts.remove(index);
    });
  }
}

//   void _navigateToNextScreen() {
//     // Navigate to PhotoUploadScreen or next screen
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PhotoUploadScreen(),
//       ),
//     );
//   }
// }



// // Placeholder for PhotoUploadScreen - replace with your actual implementation
// class PhotoUploadScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Photo Upload')),
//       body: const Center(
//         child: Text('Photo Upload Screen'),
//       ),
//     );
//   }
// }
















// import 'package:dating/screens/causes_Community.dart';
// import 'package:dating/screens/face_screen.dart';
// import 'package:flutter/material.dart';

// class DatePromptScreen extends StatelessWidget {
//   final String email;
//   final double latitude;
//   final double longitude;
//   final String userName;
//   final String dateOfBirth;
//   final String selectedGender;
//   final bool showGenderOnProfile;
//   final dynamic showMode;
//   final String? gendermode;
//   final dynamic selectionOptionIds;
//   final dynamic selectedHeight;
//   final List<int> selectedInterestIds;
//   final List<int> selectedqualitiesIDs;
//   final List<int> selectedhabbits;
//   final List<int> selectedkids;
//   final List<int> selectedreligions;
//   final List<int> selectedcauses;

//   DatePromptScreen({
//     super.key,
//     required this.email,
//     required this.latitude,
//     required this.longitude,
//     required this.userName,
//     required this.dateOfBirth,
//     required this.selectedGender,
//     required this.showGenderOnProfile,
//     this.showMode,
//     this.gendermode,
//     this.selectionOptionIds,
//     this.selectedHeight,
//     required this.selectedInterestIds,
//     required this.selectedqualitiesIDs,
//     required this.selectedhabbits,
//     required this.selectedkids,
//     required this.selectedreligions,
//     required this.selectedcauses,
//   });

//   final List<String> prompts = [
//     "Write Your Own Opening Move Prompt",
//     "Window Seat Or Aisle? Convince Me Either Way ……",
//     "The Key To My Heart Is ……",
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final screen = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Progress bar
//               LinearProgressIndicator(
//                 value: 7 / 16,
//                 backgroundColor: Colors.grey[300],
//                 valueColor: const AlwaysStoppedAnimation<Color>(
//                   Color.fromARGB(255, 147, 179, 3),
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // Top row: Back button and Skip
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back_ios),
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => CausesScreen(
//                             email: email,
//                             latitude: latitude,
//                             longitude: longitude,
//                             userName: userName,
//                             dateOfBirth: dateOfBirth,
//                             selectedGender: selectedGender,
//                             showGenderOnProfile: showGenderOnProfile,
//                             showMode: showMode,
//                             gendermode: gendermode,
//                             selectionOptionIds: selectionOptionIds,
//                             selectedHeight: selectedHeight,
//                             selectedInterestIds: selectedInterestIds,
//                             selectedqualitiesIDs: selectedqualitiesIDs,
//                             selectedhabbits: selectedhabbits,
//                             selectedkids: selectedkids,
//                             selectedreligions: selectedreligions,
//                             // selectedcauses: selectedcauses,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   const Spacer(),
//                   const Text(
//                     'Skip',
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // Title
//               const Text(
//                 "Choose Five Things\nYou Are Really Into",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Poppins',
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // Subtitle
//               Text(
//                 "A Joy, Obviously, But Go Ahead\nAnd Answer In Your Own Words.",
//                 style: TextStyle(
//                   color: Colors.grey[700],
//                   height: 1.4,
//                   fontSize: 16,
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Prompt List
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: prompts.length,
//                   itemBuilder: (context, index) =>
//                       _buildPromptTile(prompts[index]),
//                 ),
//               ),

//               // Bottom Row
//               Padding(
//                 padding: const EdgeInsets.only(top: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text("0/3 Selected"),
//                     Row(
//                       children: [
//                         // Decorative Forward Arrow Button (Disabled logic for now)
//                         Material(
//                           elevation: 6,
//                           borderRadius: BorderRadius.circular(50),
//                           child: Container(
//                             width: screen.width * 0.125,
//                             height: screen.width * 0.125,
//                             decoration: BoxDecoration(
//                               gradient: const LinearGradient(
//                                 colors: [Color(0xffB2D12E), Color(0xff000000)],
//                               ),
//                               borderRadius: BorderRadius.circular(50),
//                             ),
//                             child: IconButton(
//                               icon: const Icon(Icons.arrow_forward_ios,
//                                   color: Colors.white),
//                               onPressed: () {
//                                 // TODO: Implement next screen logic
//                                 Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             PhotoUploadScreen()));
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPromptTile(String label) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF869E23), Color(0xFF000000)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Flexible(
//             child: Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(50),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black26,
//                   offset: Offset(0, 2),
//                   blurRadius: 4,
//                 )
//               ],
//             ),
//             child: const Text(
//               "Add",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
