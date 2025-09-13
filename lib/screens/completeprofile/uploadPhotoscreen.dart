
import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/screens/completeprofile/capture_document.dart';
import 'package:flutter/material.dart';
class UploadPhotoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DatingColors.white,
      appBar: AppBar(
        backgroundColor: DatingColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: DatingColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Upload Photo Of ID',
          style: TextStyle(
            color: DatingColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    // Cloud upload icon
                    Container(
                      width: 80,
                      height: 60,
                      decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [DatingColors.primaryGreen, DatingColors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                      child: Icon(
                        Icons.cloud_upload,
                        color: DatingColors.white,
                        size: 30,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Upload a Photo Of Your ID',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: DatingColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Make Sure Your ID Is Still Valid And Not Expired',
                      style: TextStyle(
                        fontSize: 14,
                        color: DatingColors.middlegrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    // Accepted Forms of ID
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Accepted Forms Of ID',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: DatingColors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // ID options
                    _buildIDOption('Pan', true),
                    // _buildIDOption('Driver\'s License', true),
                    // _buildIDOption('Residence Permit', true),
                    _buildIDOption('AdhaarID', true),
                    SizedBox(height: 24),
                    // Warning box
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: DatingColors.surfaceGrey,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: DatingColors.yellow),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.warning,
                            color: DatingColors.yellow,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'How We Are Use Your ID',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'We\'ll Verify Your Birthdate And Match Your ID To Your Photos Without Changing Your Profile Name',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: DatingColors.middlegrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'By Submitting A Selfie And ID, You Agree To Identity Verification, Including Facial Recognition. To Opt Out, Request A Manual Review. See Our Privacy Policy And WMP\'s Notice For Details. JG',
                      style: TextStyle(
                        fontSize: 11,
                        color: DatingColors.middlegrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            // Upload button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Container(
                 decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [DatingColors.primaryGreen, DatingColors.black],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CaptureDocumentsScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DatingColors.black,
                    shadowColor: DatingColors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Upload Photo Of ID',
                    style: TextStyle(
                      color:DatingColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIDOption(String text, bool isChecked) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
           decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [DatingColors.everqpidColor, DatingColors.everqpidColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
            child: isChecked
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  )
                : null,
          ),
          SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

// Third Screen - Capture Documents (Selfie and ID)
