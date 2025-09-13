// import 'package:dating/constants/dating_app_user.dart';
// import 'package:flutter/material.dart';

// import 'dart:io';


// import 'package:image_picker/image_picker.dart';

// class CaptureDocumentsScreen extends StatefulWidget {
//   @override
//   _CaptureDocumentsScreenState createState() => _CaptureDocumentsScreenState();
// }

// class _CaptureDocumentsScreenState extends State<CaptureDocumentsScreen> {
//   File? _selfieImage;
//   File? _idImage;
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _takeSelfie() async {
//     final XFile? image = await _picker.pickImage(
//       source: ImageSource.camera,
//       preferredCameraDevice: CameraDevice.front,
//     );
//     if (image != null) {
//       setState(() {
//         _selfieImage = File(image.path);
//       });
//     }
//   }

//   Future<void> _captureID() async {
//     final XFile? image = await _picker.pickImage(
//       source: ImageSource.camera,
//     );
//     if (image != null) {
//       setState(() {
//         _idImage = File(image.path);
//       });
//     }
//   }

//   Future<void> _selectFromGallery(bool isSelfie) async {
//     final XFile? image = await _picker.pickImage(
//       source: ImageSource.gallery,
//     );
//     if (image != null) {
//       setState(() {
//         if (isSelfie) {
//           _selfieImage = File(image.path);
//         } else {
//           _idImage = File(image.path);
//         }
//       });
//     }
//   }

//   void _submitDocuments() {
//     if (_selfieImage != null && _idImage != null) {
//       // Show success dialog
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Success!'),
//             content: Text('Your documents have been submitted for verification.'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
             
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       // Show error message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please capture both selfie and ID photo'),
//           backgroundColor: DatingColors.errorRed,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: DatingColors.white,
//       appBar: AppBar(
//         backgroundColor: DatingColors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: DatingColors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Capture Documents',
//           style: TextStyle(
//             color: DatingColors.black,
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Please capture both documents for verification',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: DatingColors.lightgrey,
//                 ),
//               ),
//               SizedBox(height: 32),
              
//               // Selfie Section
//               Text(
//                 '1. Take a Selfie',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: DatingColors.black,
//                 ),
//               ),
//               SizedBox(height: 16),
//               Container(
//                 width: double.infinity,
//                 height: 200,
//                 decoration: BoxDecoration(
//                   color: DatingColors.surfaceGrey,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: DatingColors.surfaceGrey),
//                 ),
//                 child: _selfieImage != null
//                     ? ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.file(
//                           _selfieImage!,
//                           fit: BoxFit.cover,
//                         ),
//                       )
//                     : Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.camera_alt,
//                             size: 48,
//                             color:DatingColors.lightgrey,
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             'No selfie captured',
//                             style: TextStyle(
//                               color: DatingColors.lightgrey,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//               ),
//               SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: _takeSelfie,
//                       icon: Icon(Icons.camera_alt, size: 20),
//                       label: Text('Take Selfie'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: DatingColors.darkGreen,
//                         foregroundColor: DatingColors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () => _selectFromGallery(true),
//                       icon: Icon(Icons.photo_library, size: 20),
//                       label: Text('Gallery'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: DatingColors.darkGreen,
//                         side: BorderSide(color: DatingColors.darkGreen),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
              
//               SizedBox(height: 32),
              
//               // ID Document Section
//               Text(
//                 '2. Capture ID Document',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: DatingColors.black,
//                 ),
//               ),
//               SizedBox(height: 16),
//               Container(
//                 width: double.infinity,
//                 height: 200,
//                 decoration: BoxDecoration(
//                   color: DatingColors.surfaceGrey,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: DatingColors.surfaceGrey),
//                 ),
//                 child: _idImage != null
//                     ? ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.file(
//                           _idImage!,
//                           fit: BoxFit.cover,
//                         ),
//                       )
//                     : Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.credit_card,
//                             size: 48,
//                             color: DatingColors.surfaceGrey,
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             'No ID document captured',
//                             style: TextStyle(
//                               color: DatingColors.lightgrey,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//               ),
//               SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: _captureID,
//                       icon: Icon(Icons.camera_alt, size: 20),
//                       label: Text('Capture ID'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: DatingColors.darkGreen,
//                         foregroundColor: DatingColors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () => _selectFromGallery(false),
//                       icon: Icon(Icons.photo_library, size: 20),
//                       label: Text('Gallery'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: DatingColors.darkGreen,
//                         side: BorderSide(color:DatingColors.primaryGreen),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
              
//               SizedBox(height: 32),
              
//               // Submit Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _submitDocuments,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: (_selfieImage != null && _idImage != null)
//                         ? DatingColors.primaryGreen
//                         : DatingColors.lightgrey,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ),
//                   child: Text(
//                     'Submit Documents',
//                     style: TextStyle(
//                       color: DatingColors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 24), // Add some bottom padding
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/document_upload_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CaptureDocumentsScreen extends ConsumerStatefulWidget {
  @override
  _CaptureDocumentsScreenState createState() => _CaptureDocumentsScreenState();
}

class _CaptureDocumentsScreenState extends ConsumerState<CaptureDocumentsScreen> {
  File? _selfieImage; // step 1 (camera only)
  File? _aadharImage; // step 2
  File? _panImage;    // step 3

  final ImagePicker _picker = ImagePicker();

  bool get _allowAadhar => _selfieImage != null;
  bool get _allowPan => _aadharImage != null;
  bool get _readyToSubmit =>
      _selfieImage != null && _aadharImage != null && _panImage != null;

  // --- Step 1: Selfie (camera only) ---
  Future<void> _takeSelfie() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    if (image != null) {
      setState(() {
        _selfieImage = File(image.path);
        // When selfie is captured, allow Aadhar
      });
    }
  }

  // --- Step 2: Aadhar (camera or gallery) ---
  Future<void> _captureAadhar() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (image != null) {
      setState(() {
        _aadharImage = File(image.path);
      });
    }
  }

  Future<void> _selectAadharFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _aadharImage = File(image.path);
      });
    }
  }

  // --- Step 3: PAN (camera or gallery) ---
  Future<void> _capturePan() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (image != null) {
      setState(() {
        _panImage = File(image.path);
      });
    }
  }

  Future<void> _selectPanFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _panImage = File(image.path);
      });
    }
  }

 Future<void> _submitDocuments() async {
  if (_readyToSubmit) {
    await ref.read(documentProvider.notifier).sendDocuments(
      selfie: _selfieImage!,   // camera only
      aadhar: _aadharImage!,   // camera or gallery
      pan: _panImage!,         // camera or gallery
    );

    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Success!'),
        content: Text('Your documents have been submitted for verification.'),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Please capture Selfie, Aadhar and PAN'),
        backgroundColor: DatingColors.errorRed,
      ),
    );
  }
}


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
          'Capture Documents',
          style: TextStyle(
            color: DatingColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please capture all three for verification (Selfie → Aadhar → PAN)',
                style: TextStyle(fontSize: 16, color: DatingColors.lightgrey),
              ),
              const SizedBox(height: 32),

              // ===== 1) Selfie =====
              _sectionTitle('1. Take a Selfie'),
              const SizedBox(height: 16),
              _previewBox(_selfieImage, fallbackIcon: Icons.camera_alt, emptyText: 'No selfie captured'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _takeSelfie, // camera only
                      icon: const Icon(Icons.camera_alt, size: 20),
                      label: const Text('Take Selfie'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DatingColors.everqpidColor,
                        foregroundColor: DatingColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // No gallery for selfie (disabled UI to make it clear)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: null, // disabled
                      icon: const Icon(Icons.photo_library, size: 20),
                      label: const Text('Gallery disabled'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: DatingColors.lightgrey,
                        side: BorderSide(color: DatingColors.surfaceGrey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ===== 2) Aadhar =====
              _sectionTitle('2. Capture Aadhar'),
              const SizedBox(height: 16),
              _previewBox(_aadharImage, fallbackIcon: Icons.badge_outlined, emptyText: 'No Aadhar captured'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _allowAadhar ? _captureAadhar : null,
                      icon: const Icon(Icons.camera_alt, size: 20),
                      label: const Text('Capture Aadhar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _allowAadhar ? DatingColors.everqpidColor : DatingColors.surfaceGrey,
                        foregroundColor: DatingColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _allowAadhar ? _selectAadharFromGallery : null,
                      icon: const Icon(Icons.photo_library, size: 20),
                      label: const Text('Gallery'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _allowAadhar
                            ? DatingColors.everqpidColor
                            : DatingColors.lightgrey,
                        side: BorderSide(
                          color: _allowAadhar
                              ? DatingColors.everqpidColor
                              : DatingColors.surfaceGrey,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ===== 3) PAN =====
              _sectionTitle('3. Upload PAN'),
              const SizedBox(height: 16),
              _previewBox(_panImage, fallbackIcon: Icons.credit_card, emptyText: 'No PAN captured'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _allowPan ? _capturePan : null,
                      icon: const Icon(Icons.camera_alt, size: 20),
                      label: const Text('Capture PAN'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _allowPan ? DatingColors.everqpidColor : DatingColors.surfaceGrey,
                        foregroundColor: DatingColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _allowPan ? _selectPanFromGallery : null,
                      icon: const Icon(Icons.photo_library, size: 20),
                      label: const Text('Gallery'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            _allowPan ? DatingColors.everqpidColor : DatingColors.lightgrey,
                        side: BorderSide(
                          color:
                              _allowPan ? DatingColors.everqpidColor : DatingColors.surfaceGrey,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ===== Submit =====
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _readyToSubmit ? _submitDocuments : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _readyToSubmit
                        ? DatingColors.primaryGreen
                        : DatingColors.lightgrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Submit Documents',
                    style: TextStyle(
                      color: Colors.white, // DatingColors.white
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Helpers
  Widget _sectionTitle(String text) => Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: DatingColors.black,
        ),
      );

  Widget _previewBox(File? file,
      {required IconData fallbackIcon, required String emptyText}) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: DatingColors.surfaceGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DatingColors.surfaceGrey),
      ),
      child: file != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(file, fit: BoxFit.cover),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(fallbackIcon, size: 48, color: DatingColors.lightgrey),
                const SizedBox(height: 8),
                Text(
                  emptyText,
                  style: TextStyle(
                    color: DatingColors.lightgrey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
    );
  }
}
