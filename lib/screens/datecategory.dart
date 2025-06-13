import 'package:flutter/material.dart';

class IntroDatecategory extends StatefulWidget {
  final String email;
  final Function(String selectedGender, String email) onSelectionComplete;

  const IntroDatecategory({
    super.key,
    required this.email,
    required this.onSelectionComplete,
  });

  @override
  State<IntroDatecategory> createState() => _IntroDatecategoryState();
}

class _IntroDatecategoryState extends State<IntroDatecategory> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Romance And Butterflies Or A Beautiful Friendship? Choose A Mode To Find Your People.",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.0,
              fontWeight: FontWeight.w300,
              height: 1.3,
            ),
          ),
          SizedBox(height: screenHeight * 0.03),

          // Gender / Category Options
          _buildGenderOption(
            "Date",
            Color(0xffE9F1C4),
            "find a relationship, something casual , or anything in-between",
          ),
          SizedBox(height: screenHeight * 0.01),
          _buildGenderOption(
            "BFF",
            Color(0xffE9F1C4),
            "make new friends and find your community",
          ),
          SizedBox(height: screenHeight * 0.01),
          _buildGenderOption(
            "Bizz",
            Color(0xffE9F1C4),
            "network professionally and make career moves",
          ),

          SizedBox(height: screenHeight * 0.04),

          Row(
            children: [
              Icon(Icons.remove_red_eye_outlined, color: Colors.grey[600]),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "You’ll Only Be Shown To People In The Same Mode As You.",
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.4,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(
      String gender, Color defaultColor, String description) {
    final isSelected = selectedGender == gender;
    final textColor =
        isSelected ? Colors.white : const Color.fromARGB(255, 90, 118, 81);

    return InkWell(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });

        // Trigger the callback to send data to parent
        widget.onSelectionComplete(gender, widget.email);
      },
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff92AB26) : defaultColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            width: 2,
            color: isSelected ? Color(0xffE9F1C4) : Colors.transparent,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  gender,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    color: textColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Colors.white
                          : const Color.fromARGB(255, 90, 118, 81),
                      width: 2,
                    ),
                    color: isSelected
                        ? const Color.fromARGB(255, 90, 118, 81)
                        : Colors.transparent,
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                color: textColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
