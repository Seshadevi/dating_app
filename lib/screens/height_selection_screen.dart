import 'package:flutter/material.dart';

class HeightSelectionScreen extends StatefulWidget {
  const HeightSelectionScreen({Key? key}) : super(key: key);

  @override
  State<HeightSelectionScreen> createState() => _HeightSelectionScreenState();
}

class _HeightSelectionScreenState extends State<HeightSelectionScreen> {
  int _selectedHeight = 154;
  final int _minHeight = 120;
  final int _maxHeight = 240;

  @override
  Widget build(BuildContext context) {
    return
    //  Scaffold(
    //   backgroundColor: Colors.white,
    //   body: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Padding(
          //   padding: EdgeInsets.only(left: 30, top: 50, right: 30),
          //   child: Text(
          //     "Now Let's Talk About You",
          //     style: TextStyle(
          //       fontSize: 34,
          //       fontWeight: FontWeight.bold,
          //       color: Colors.black,
          //     ),
          //   ),
          // ),
          const Padding(
            padding: EdgeInsets.only(left: 30, top: 20, right: 30),
            child: Text(
              "Let's get the small talk out of the way. we'll get into the deep and meaningful later.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30, top: 40, bottom: 30),
            child: Text(
              "your height",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                height: 300,
                child: HeightBubblesSelector(
                  minValue: _minHeight,
                  maxValue: _maxHeight,
                  initialValue: _selectedHeight,
                  onChanged: (value) {
                    setState(() {
                      _selectedHeight = value;
                    });
                  },
                ),
              ),
            ),
          ),
          // Center(
          //   child: Container(
          //     width: 56,
          //     height: 56,
          //     margin: EdgeInsets.only(bottom: 20),
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         colors: [
          //           Color(0xffB2D12E),
          //           Color(0xff000000),
          //         ],
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //       ),
          //       shape: BoxShape.circle,
          //     ),
          //     child: IconButton(
          //         icon: Icon(
          //           Icons.arrow_forward,
          //           color: Colors.white,
          //         ),
          //         onPressed: () {
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => HeightSelectionScreen()));
          //         }),
          //   ),
          // ),
          // const SizedBox(height: 20),
        ],
      // ),
    );
  }
}

class HeightBubblesSelector extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int initialValue;
  final Function(int) onChanged;

  const HeightBubblesSelector({
    Key? key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<HeightBubblesSelector> createState() => _HeightBubblesSelectorState();
}

class _HeightBubblesSelectorState extends State<HeightBubblesSelector> {
  late ScrollController _scrollController;
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _scrollController = ScrollController(
      initialScrollOffset: (_currentValue - widget.minValue) * 100.0,
    );
  }

  void _scrollToIndex(int index) {
    final targetOffset = index * 100.0 - MediaQuery.of(context).size.width / 2 + 50;
    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: widget.maxValue - widget.minValue + 1,
      itemBuilder: (context, index) {
        final height = widget.minValue + index;
        final isSelected = height == _currentValue;

        // Diagonal Y position (adjust this curve for steeper or shallower arc)
        final verticalOffset = 40 - (index - (_currentValue - widget.minValue)) * 10;

        return GestureDetector(
          onTap: () {
            setState(() {
              _currentValue = height;
              widget.onChanged(_currentValue);
            });
            _scrollToIndex(index);
          },
          child: Padding(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: verticalOffset.toDouble().clamp(10, 80),
              bottom: 100,
            ),
            child: HeightBubble(
              height: height,
              isSelected: isSelected,
            ),
          ),
        );
      },
    );
  }
}


class HeightBubble extends StatelessWidget {
  final int height;
  final bool isSelected;

  const HeightBubble({
    Key? key,
    required this.height,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gradient = isSelected
        ? const LinearGradient(
            colors: [Color(0xFFBEDC62), Color(0xFF000000)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFFE8F3C1), Color(0xFFE8F3C1)],
          );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isSelected ? 150 : 100,
      height: isSelected ? 150 : 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(2, 4),
                  blurRadius: 20,
                )
              ]
            : [],
      ),
      child: Center(
        child: Text(
          '$height cm',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: isSelected ? 18 : 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
