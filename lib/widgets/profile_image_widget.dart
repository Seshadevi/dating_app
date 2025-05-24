import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String url;
  final double top;
  final double left;
  final double width;
  final double height;

  const ProfileImageWidget({
    Key? key,
    required this.url,
    required this.top,
    required this.left,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(url, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
