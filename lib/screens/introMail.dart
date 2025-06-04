import 'package:flutter/material.dart';
import '../screens/datecategory.dart';

class IntroMail extends StatelessWidget {
  const IntroMail({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return
        //  Scaffold(
        //   backgroundColor: Colors.white,
        //   resizeToAvoidBottomInset: true,
        //   body:
        GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "We'll Use This To Recover Your \nAccount ASAP If You Can't Log In.",
                    style: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 15.0,
                      letterSpacing: 1.08,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your Email',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'poppins',
                      fontSize: 20.0,
                      letterSpacing: 1.28,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 15),
                  _buildTextField(width: double.infinity),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'poppins',
                            fontSize: 16.0,
                            letterSpacing: 1.28,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          width: screenWidth * 0.125,
                          height: screenWidth * 0.125,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xffB2D12E), Color(0xff000000)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => IntroDatecategory()));
                            },
                            icon: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Positioned(
              top: 300,
              bottom: 2500,
              child: Image.asset(
                'assets/mail_frame.png',
                fit: BoxFit.contain,
              ),
            )
          ],
        ),
      ),
    );
    // );
  }

  Widget _buildTextField({required double width}) {
    return Material(
      elevation: 10.0,
      borderRadius: BorderRadius.circular(18.0),
      child: Container(
        width: width,
        height: 60,
        decoration: BoxDecoration(
          color: Color(0xffE9F1C4),
          borderRadius: BorderRadius.circular(18.0),
          border: Border.all(
            color: Color(0xff92AB26),
            width: 1.0,
          ),
        ),
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: InputBorder.none,
          ),
          style: TextStyle(
            color: Color(0xff92AB26),
            fontFamily: 'Inter',
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}
