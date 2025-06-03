import 'package:flutter/material.dart';

class OpeningMoveScreen extends StatefulWidget {
  const OpeningMoveScreen({Key? key}) : super(key: key);

  @override
  State<OpeningMoveScreen> createState() => _OpeningMoveScreenState();
}

class _OpeningMoveScreenState extends State<OpeningMoveScreen> {
  final List<String> prompts = [
    "Write Your Own Opening Move Prompt",
    "Window Seat Or Aisle? Convince Me Either Way ……",
    "What’s The Next Thing You’re Looking Forward To?",
    "If You Were A Food, What Food Would You Be And Why?"
  ];

  final List<int> selectedIndexes = [];

  @override
  Widget build(BuildContext context) {
    return 
    // Scaffold(
    //   backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: const Icon(Icons.arrow_back, color: Colors.black),
      //   actions: [
      //     TextButton(
      //       onPressed: () {},
      //       child: const Text(
      //         "Skip",
      //         style: TextStyle(color: Colors.black),
      //       ),
      //     ),
      //   ],
      //   bottom: PreferredSize(
      //     preferredSize: const Size.fromHeight(2),
      //     child: Container(
      //       height: 2,
      //       color: Colors.lightGreen,
      //     ),
      //   ),
      // ),
      // body: Padding(
      //   padding: const EdgeInsets.all(20),
      //   child: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   "What Will Your\nOpening Move Be?",
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.w900,
            //   ),
            // ),
            // const SizedBox(height: 12),
            const Text(
              "Choose A First Message For All\n Your New Matches To Reply To.\nEasy!",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            // const SizedBox(height: 14),
            ...List.generate(prompts.length, (index) {
              final isSelected = selectedIndexes.contains(index);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedIndexes.remove(index);
                    } else if (selectedIndexes.length < 3) {
                      selectedIndexes.add(index);
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F8E7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          prompts[index],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // const SizedBox(width: 12),
                      Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: Colors.grey.shade700,
                      ),
                    ],
                  ),
                ),
              );
            }),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // const Text(
                //   "Skip",
                //   style: TextStyle(fontSize: 10),
                // ),
                Text(
                  "${selectedIndexes.length}/3 Selected",
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     // Handle next
                //   },
                //   child: Container(
                //     padding: const EdgeInsets.all(12),
                //     decoration: const BoxDecoration(
                //       shape: BoxShape.circle,
                //       gradient: LinearGradient(
                //         colors: [Color(0xFF8BC34A), Color(0xFF558B2F)],
                //       ),
                //     ),
                //     child: const Icon(Icons.arrow_forward, color: Colors.white),
                //   ),
                // ),
              ],
            ),
          ],
        // ),
      // ),
    );
  }
}
