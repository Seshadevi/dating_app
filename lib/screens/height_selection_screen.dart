import 'package:dating/screens/choose_foodies.dart';
import 'package:dating/screens/partners_selections.dart';
import 'package:flutter/material.dart';

class HeightSelectionScreen extends StatefulWidget {
  final String email;
  final double latitude;
  final double longitude;
  final String userName;
  final String dateOfBirth;
  final String selectedGender;
  final bool showGenderOnProfile;
  final showMode;
  final String? gendermode;
  final Set<int> selectionOptionIds;

  const HeightSelectionScreen({
    Key? key,
    required this.email,
    required this.latitude,
    required this.longitude,
    required this.userName,
    required this.dateOfBirth,
    required this.selectedGender,
    required this.showGenderOnProfile,
    this.showMode,
    this.gendermode,
    required this.selectionOptionIds,
  }) : super(key: key);

  @override
  State<HeightSelectionScreen> createState() => _HeightSelectionScreenState();
}

class _HeightSelectionScreenState extends State<HeightSelectionScreen> {
  int _selectedHeight = 154;
  final int _minHeight = 120;
  final int _maxHeight = 240;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LinearProgressIndicator(
              value: 9 / 16,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 147, 179, 3)),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InrtoPartneroption(
                        email: widget.email,
                        latitude: widget.latitude,
                        longitude: widget.longitude,
                        userName: widget.userName,
                        dateOfBirth: widget.dateOfBirth,
                        selectedGender: widget.selectedGender,
                        showGenderOnProfile: widget.showGenderOnProfile,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Now lets Talk About You",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
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
          Align(
            alignment: Alignment.bottomRight,
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: screenWidth * 0.125,
                height: screenWidth * 0.125,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xffB2D12E), Color(0xff000000)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InterestsScreen(
                          email: widget.email,
                          latitude: widget.latitude,
                          longitude: widget.longitude,
                          userName: widget.userName,
                          dateOfBirth: widget.dateOfBirth,
                          selectedGender: widget.selectedGender,
                          showGenderOnProfile: widget.showGenderOnProfile,
                          showMode: widget.showMode,
                          gendermode: widget.gendermode,
                          selectedHeight: _selectedHeight,
                          selectionOptionIds: widget.selectionOptionIds,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
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
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToIndex(_currentValue - widget.minValue);
    });
  }

  void _scrollToIndex(int index) {
    final targetOffset =
        index * 120.0 - MediaQuery.of(context).size.width / 2 + 60;
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

        return GestureDetector(
          onTap: () {
            setState(() {
              _currentValue = height;
              widget.onChanged(_currentValue);
            });
            _scrollToIndex(index);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
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
