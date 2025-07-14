import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/signupprocessProviders/modeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Typeofconnection extends ConsumerStatefulWidget {
  final int selectedModeId;
  final String selectedModeName;

  const Typeofconnection({
    super.key,
    required this.selectedModeId,
    required this.selectedModeName,
  });

  @override
  ConsumerState<Typeofconnection> createState() => TypeofconnectionState();
}

class TypeofconnectionState extends ConsumerState<Typeofconnection> {
  late String? selectedOption;


  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(modesProvider.notifier).getModes();
    });
    selectedOption = widget.selectedModeName;
  }

  @override
  Widget build(BuildContext context) {

    final modeOptions =ref.watch(modesProvider).data ??[];
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Type Of Connection',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What Type Of Connection Are You Looking For On Heart Sync?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
            const Text(
              'Dates And Romance, New Friends, Or Strictly Business? You Can Change This Any Time.',
              style: TextStyle(fontSize: 16, color: Color(0xFF666666), height: 1.4),
            ),
            const SizedBox(height: 20),

            ...modeOptions.map((option) => Column(
              children: [
                _buildOptionCard(
                  title: option.value,
                  isSelected: selectedOption == option.value,
                  onTap: () => setState(() => selectedOption = option.value),
                ),
                const SizedBox(height: 12),
              ],
            )),

            const Spacer(),

            SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                final selected = modeOptions.firstWhere((e) => e.value == selectedOption);
                final int? modeId = selected.id;
                final String? modeName = selected.value;

                final statuscode = await ref.read(loginProvider.notifier).updateProfile(
                  modeid: modeId,
                  modename: modeName,
                );

                if (context.mounted) {
                  if (statuscode == 200 || statuscode == 201) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Mode updated successfully to $modeName"),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // Delay for user to read the message before popping
                    await Future.delayed(const Duration(milliseconds: 600));
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Failed to update mode. Please try again."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A5D23),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'Continue With $selectedOption',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String? title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8BC34A) : const Color(0xFFE8F5E8),
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: const Color(0xFF4A5D23), width: 2) : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$title", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)),
                  // const SizedBox(height: 8),
                  // Text(subtitle, style: TextStyle(fontSize: 14, color: isSelected ? Colors.white.withOpacity(0.9) : const Color(0xFF666666))),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? const Color(0xFF4A5D23) : Colors.grey, width: 2),
                color: isSelected ? const Color(0xFF4A5D23) : Colors.transparent,
              ),
              child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
            ),
          ],
        ),
      ),
    );
  }
}



















// import 'package:flutter/material.dart';

// class Typeofconnection extends StatefulWidget {
//   const Typeofconnection({super.key});

//   @override
//   State<Typeofconnection> createState() => TypeofconnectionState();
// }

// class TypeofconnectionState extends State<Typeofconnection> {
//   String selectedOption = 'Date'; // Default selection

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFF5F5F5),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Type Of Connection',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: false,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Main heading
//             const Text(
//               'What Type Of Connection Are You Looking For On Heart Sync?',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//                 height: 1.3,
//               ),
//             ),
//             const SizedBox(height: 8),
            
//             // Subtitle
//             const Text(
//               'Dates And Romance, New Friends, Or Strictly Business? You Can Change This Any Time.',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Color(0xFF666666),
//                 height: 1.4,
//               ),
//             ),
//             const SizedBox(height: 20),
            
//             // Options
//             _buildOptionCard(
//               title: 'Date',
//               subtitle: 'Find A Relationship, Something Casual, Or Anything In - Between',
//               isSelected: selectedOption == 'Date',
//               onTap: () => setState(() => selectedOption = 'Date'),
//             ),
//             const SizedBox(height: 12),
            
//             _buildOptionCard(
//               title: 'BFF',
//               subtitle: 'Make New Friends And Find Your Community',
//               isSelected: selectedOption == 'BFF',
//               onTap: () => setState(() => selectedOption = 'BFF'),
//             ),
//             const SizedBox(height: 12),
            
//             _buildOptionCard(
//               title: 'Bizz',
//               subtitle: 'Network Professionally And Make Career Moves',
//               isSelected: selectedOption == 'Bizz',
//               onTap: () => setState(() => selectedOption = 'Bizz'),
//             ),
            
//             const Spacer(),
            
//             // Continue button with dynamic text
//             Container(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Handle continue action
//                   print('Selected option: $selectedOption');
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF4A5D23),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   elevation: 0,
//                 ),
//                 child: Text(
//                   'Continue With $selectedOption',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOptionCard({
//     required String title,
//     required String subtitle,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFF8BC34A) : const Color(0xFFE8F5E8),
//           borderRadius: BorderRadius.circular(12),
//           border: isSelected 
//             ? Border.all(color: const Color(0xFF4A5D23), width: 2)
//             : null,
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: isSelected ? Colors.white : Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     subtitle,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: isSelected 
//                         ? Colors.white.withOpacity(0.9)
//                         : const Color(0xFF666666),
//                       height: 1.3,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               width: 24,
//               height: 24,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: isSelected 
//                     ? const Color(0xFF4A5D23)
//                     : Colors.grey,
//                   width: 2,
//                 ),
//                 color: isSelected ? const Color(0xFF4A5D23) : Colors.transparent,
//               ),
//               child: isSelected
//                 ? const Icon(
//                     Icons.check,
//                     color: Colors.white,
//                     size: 16,
//                   )
//                 : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }