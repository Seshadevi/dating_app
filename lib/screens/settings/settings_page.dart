import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loader.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/logout_notitifier.dart';
import 'package:dating/provider/settings/travelprovider.dart';
import 'package:dating/provider/signupprocessProviders/modeProvider.dart';
import 'package:dating/provider/snooze/post_snooze_provider.dart';
import 'package:dating/screens/feedback/feedback_screen.dart';
import 'package:dating/screens/notifications/notifications.dart';
import 'package:dating/screens/profile_screens/profile_screen.dart';
import 'package:dating/screens/settings/contactand_faq.dart';
import 'package:dating/screens/settings/privacusetting_screen.dart';
import 'package:dating/screens/settings/typesOfconnections.dart';
import 'package:dating/screens/settings/videoAutoPlayScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;
import 'dart:async';

import '../../model/signupprocessmodels/modeModel.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _currentLocationName = "Loading location...";
  bool _isLoadingLocation = false;
  double? _currentLat;
  double? _currentLng;
  bool _autoSpotlight = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserLocationData();
    });
  }

  void _loadUserLocationData() {
    final userdata = ref.read(loginProvider);
    final user =
        userdata.data?.isNotEmpty == true ? userdata.data![0].user : null;

    print('User location data: ${user?.location}');

    if (user?.location?.latitude != null && user?.location?.longitude != null) {
      _currentLat = double.tryParse(user?.location?.latitude.toString() ?? '');
      _currentLng = double.tryParse(user?.location?.longitude.toString() ?? '');

      print('Parsed coordinates: lat: $_currentLat, lng: $_currentLng');

      if (_currentLat != null && _currentLng != null) {
        _getAddressFromCoordinates(_currentLat!, _currentLng!);
      } else {
        setState(() {
          _currentLocationName = "Location not set";
        });
      }
    } else {
      setState(() {
        _currentLocationName = "Location not set";
      });
    }
  }

  Future<void> _getAddressFromCoordinates(double lat, double lng) async {
    if (!mounted) return;

    try {
      setState(() {
        _isLoadingLocation = true;
      });

      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng)
          .timeout(const Duration(seconds: 10));

      if (placemarks.isNotEmpty && mounted) {
        String address = _formatAddress(placemarks.first);
        setState(() {
          _currentLocationName = address;
        });
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
      if (mounted) {
        setState(() {
          _currentLocationName = "Unable to get location name";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  String _formatAddress(Placemark placemark) {
    List<String?> addressComponents = [
      placemark.locality,
      placemark.administrativeArea,
      placemark.country,
    ].where((component) => component != null && component.isNotEmpty).toList();

    return addressComponents.isNotEmpty
        ? addressComponents.join(', ')
        : "Selected location";
  }

  Future<void> _updateCurrentLocation() async {
    if (!mounted) return;

    setState(() {
      _isLoadingLocation = true;
      _currentLocationName = "Getting current location...";
    });

    final loc.Location location = loc.Location();

    try {
      // Check location service
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          if (mounted) {
            _showErrorSnackBar("Location service is disabled");
            setState(() {
              _isLoadingLocation = false;
              _currentLocationName = "Location service disabled";
            });
          }
          return;
        }
      }

      // Check permissions
      loc.PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          if (mounted) {
            _showErrorSnackBar("Location permission denied");
            setState(() {
              _isLoadingLocation = false;
              _currentLocationName = "Location permission denied";
            });
          }
          return;
        }
      }

      // Get location
      loc.LocationData locationData =
          await location.getLocation().timeout(const Duration(seconds: 15));

      if (locationData.latitude == null || locationData.longitude == null) {
        if (mounted) {
          _showErrorSnackBar("Unable to get current location");
          setState(() {
            _isLoadingLocation = false;
            _currentLocationName = "Unable to get location";
          });
        }
        return;
      }

      _currentLat = locationData.latitude?.toDouble();
      _currentLng = locationData.longitude?.toDouble();

      // Get address
      await _getAddressFromCoordinates(_currentLat!, _currentLng!);

      // Update user's location in backend/provider
      // You can implement this method in your loginProvider
      await ref
          .read(loginProvider.notifier)
          .updateProfile(currentLat: _currentLat, currentLng: _currentLng);

      if (mounted) {
        _showSuccessSnackBar("Location updated successfully");
      }
    } catch (e) {
      debugPrint('Error getting current location: $e');
      if (mounted) {
        _showErrorSnackBar("Error getting location. Please try again.");
        setState(() {
          _currentLocationName = "Error getting location";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: DatingColors.errorRed,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: DatingColors.primaryGreen,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userdata = ref.watch(loginProvider);
    final user =
        userdata.data?.isNotEmpty == true ? userdata.data![0].user : null;

    // print('mode............${user?.mode?.first.value}');
    // print('modeid............${user?.mode?.first.id}');
    print('religion............${user?.email}');
    print('location............${user?.location}');

    return WillPopScope(
      onWillPop: () async {
      // Handle device back button press
      Navigator.pushNamedAndRemoveUntil(
        context, 
        '/custombottomnav', 
        (route) => false
      );
      return false; // Prevent default back behavior
    },
      child: Scaffold(
        backgroundColor: DatingColors.white,
        appBar: AppBar(
          title:
              const Text("Settings", style: TextStyle(color: DatingColors.brown)),
          centerTitle: true,
          backgroundColor: DatingColors.white,
          elevation: 0,
          leading: IconButton(
              icon:
                  const Icon(Icons.arrow_back, color: DatingColors.everqpidColor),
              onPressed: () {
                Navigator.pushNamed(context, '/custombottomnav');
              }),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              // Email section with dynamic content
              _emailTile(user?.email),
              const SizedBox(height: 16),
      
              // Type of Connection
              GestureDetector(
                onTap: () {
                  final loginModel = ref.watch(loginProvider);
                  final user = loginModel.data!.first.user;
                  final userModeValue = user?.mode;
      
                  final modeList = ref.watch(modesProvider).data ?? [];
      
                  final matchedMode = modeList.firstWhere(
                    (mode) => mode.value == userModeValue,
                    orElse: () => Data(id: 0, value: 'Not set'),
                  );
      
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Typeofconnection(
                        selectedModeId: matchedMode.id ?? 0,
                        selectedModeName: matchedMode.value ?? 'Not set',
                      ),
                    ),
                  );
                },
                child: _tileWithTextArrow(
                    "Type Of Connection",
                    (user?.mode != null && user!.mode!.isNotEmpty)
                        ? user.mode!.first.value.toString()
                        : "Date"),
              ),
              const SizedBox(height: 16),
      
              // Snooze Mode
              // Snooze Mode
              _tileWithSwitch("Snooze Mode", ref.watch(postSnoozeProvider),
                  (val) async {
                try {
                  await ref.read(postSnoozeProvider.notifier).toggleSnooze(val);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            val ? "Snooze Activated" : "Snooze Deactivated")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to update snooze")),
                  );
                }
              }),
      
              const SizedBox(height: 8),
              const Text(
                'Hide Your Profile Temporarily, in All Modes You Wont Loss Any Connections And Chats',
                style: TextStyle(fontSize: 12, color: DatingColors.mediumGrey),
              ),
              const SizedBox(height: 16),
      
              _tileWithSwitch(
                  "Incognito Mode For Date", ref.watch(postIncogintoeProvider),
                  (val) async {
                try {
                  await ref
                      .read(postIncogintoeProvider.notifier)
                      .toggleIncognito(val);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(val
                            ? "Incognito Mode For Date Activated"
                            : "Incognito Mode For Date Deactivated")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text("Failed to update Incognito Mode For Date")),
                  );
                }
              }),
      
              // _tileWithSwitch("Incognito Mode For Date", _incognitoMode, (val) {
              //   setState(() => _incognitoMode = val);
              // }),
              const SizedBox(height: 8),
              const Text(
                'Only People Youve Swiped Right on Already Or Swipe Right On Later Will See You Profile. If You Turn On Incognito Mode For Date This Wont Apply Bizz or BFF',
                style: TextStyle(fontSize: 12, color: DatingColors.mediumGrey),
              ),
              const SizedBox(height: 16),
      
              // Auto Spotlight
              _tileWithSwitch("Auto - Spotlight", _autoSpotlight, (val) {
                setState(() => _autoSpotlight = val);
              }),
              const SizedBox(height: 8),
              const Text(
                'Well Use Spotlight Automatically TO Boost Your Profile When Most People See It.',
                style: TextStyle(fontSize: 12, color: DatingColors.mediumGrey),
              ),
              const SizedBox(height: 16),
      
              // Location Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Location',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
      
              // Enhanced Current Location with button
              _tileWithLocationButton(
                  "Current Location",
                  _isLoadingLocation
                      ? "Getting location..."
                      : _currentLocationName),
              const SizedBox(height: 8),
      
              const Text(
                'Tap the location icon to update your current location',
                style: TextStyle(fontSize: 12, color: DatingColors.mediumGrey),
              ),
      
              const SizedBox(height: 16),
      
              // Travel
             travelToggleTile(context, ref, "Travel"),
      const SizedBox(height: 8),
      const Text(
        'Change Your Location To Connect With People In Other Locations',
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
      // const SizedBox(height: 8),
      // const Text(
      //   'Change Your Location To Connect With People In Other Locations',
      //   style: TextStyle(fontSize: 12, color: Colors.grey),
      // ),
      
              const SizedBox(height: 16),
      
              // Settings Options
              _simpleArrowTile("Video Autoplay Settings", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VideoAutoplayScreen()),
                );
              }),
      
              _simpleArrowTile("Notification Setting", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NotificationsScreen()),
                );
              }),
      
              _simpleArrowTile("Payment Setting", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Feedbackpage()),
                );
              }),
      
              _simpleArrowTile("Content And FAQ", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Contactandfaq()),
                );
              }),
      
              _simpleArrowTile("Security And Privacy", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Privacysetting()),
                );
              }),
      
              const SizedBox(height: 16),
      
              // Logout Button
              GestureDetector(
                onTap: () => _showLogoutDialog(context),
                child: _button(
                    "Log Out", DatingColors.everqpidColor, DatingColors.white),
              ),
              const SizedBox(height: 10),
      
              // Delete Account Button
              GestureDetector(
                  onTap: () => _showDeleteAccountDialog(context),
                  child: _button("Delete Account", DatingColors.errorRed,
                      DatingColors.white)),
              const SizedBox(height: 20),
      
              // App Info
              const Text(
                "Ever Qpid",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                "Version 1.0.0.\nCreated With Love.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Enhanced location tile with button
  Widget _tileWithLocationButton(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DatingColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DatingColors.lightpink),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: DatingColors.mediumGrey,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _isLoadingLocation ? null : _updateCurrentLocation,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _isLoadingLocation
                    ? DatingColors.mediumGrey.withOpacity(0.3)
                    : DatingColors.lightpink.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _isLoadingLocation
                      ? DatingColors.mediumGrey
                      : DatingColors.lightpink,
                  width: 1.5,
                ),
              ),
              child: _isLoadingLocation
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          DatingColors.mediumGrey,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.my_location,
                      color: DatingColors.lightpink,
                      size: 22,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Email tile with dynamic content
  Widget _emailTile(String? userEmail) {
    bool hasEmail = userEmail != null && userEmail.isNotEmpty;

    return GestureDetector(
      onTap: () {
        _showEmailDialog(context, userEmail);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: DatingColors.white,
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: DatingColors.lightpink),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasEmail ? "Email Address" : "Add Your Email",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasEmail
                        ? userEmail
                        : "Sign Up to Be Notified With Important Event Type Updates",
                    style: TextStyle(
                      fontSize: hasEmail ? 14 : 12,
                      color: hasEmail
                          ? DatingColors.brown
                          : DatingColors.mediumGrey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              hasEmail ? Icons.edit : Icons.add,
              color: DatingColors.primaryGreen,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // Method to show email add/edit dialog
  void _showEmailDialog(BuildContext context, String? currentEmail) {
    final TextEditingController emailController = TextEditingController();
    if (currentEmail != null && currentEmail.isNotEmpty) {
      emailController.text = currentEmail;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            currentEmail != null && currentEmail.isNotEmpty
                ? "Edit Email Address"
                : "Add Email Address",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email Address",
                  hintText: "Enter your email address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                String email = emailController.text.trim();
                if (_isValidEmail(email)) {
                  _updateUserEmail(email);

                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        currentEmail != null && currentEmail.isNotEmpty
                            ? 'Email updated successfully'
                            : 'Email added successfully',
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid email address'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: DatingColors.primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                currentEmail != null && currentEmail.isNotEmpty
                    ? "Update"
                    : "Add",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Email validation method
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Method to update user email
  void _updateUserEmail(String email) async {
    final loginNotifier = ref.read(loginProvider.notifier);
    await loginNotifier.updateProfile(
      causeId: null,
      image: null,
      modeid: null,
      bio: null,
      modename: null,
      prompt: null,
      qualityId: null,
      email: email,
    );
    print('Updating email to: $email');
  }

  void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismiss on outside tap
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: DatingColors.primaryGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Are you sure you want to logout?",
                style: TextStyle(
                  color: DatingColors.brown,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: DatingColors.brown),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: DatingColors.brown,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Logout Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _performLogout(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DatingColors.errorRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Log Out",
                        style: TextStyle(
                          color: DatingColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: DatingColors.primaryGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Ready To Say Good Bye?",
                  style: TextStyle(
                    color: DatingColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  "No Problem, But We'd Love To Know Why You're Leaving Us.",
                  style: TextStyle(
                    color: DatingColors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _feedbackButton("FOUND SOMEONE", () {
                  _performDeleteAccount(context);
                }),
                const SizedBox(height: 12),
                _feedbackButton("BILLING PROBLEMS", () {
                  _performDeleteAccount(context);
                }),
                const SizedBox(height: 12),
                _feedbackButton("DIDN'T HAVE A GREAT EXPERIENCE", () {
                  _performDeleteAccount(context);
                }),
                const SizedBox(height: 12),
                _feedbackButton("OTHER", () {
                  _performDeleteAccount(context);
                }),
                const SizedBox(height: 12),
                _feedbackButton("CANCEL", () {
                  Navigator.of(context).pop();
                }),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _feedbackButton(String text, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: DatingColors.white,
          ),
          child: Text(text),
        ),
      ],
    );
  }

  void _performLogout(BuildContext context) {
    ref.read(logoutProvider.notifier).logout(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully')),
    );
  }

  void _performDeleteAccount(BuildContext context) {
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account deletion initiated')),
    );
  }

  Widget _tileWithTextArrow(String title, String value) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: DatingColors.lightpinks,
      title: Text(title),
      trailing: Text(value),
    );
  }

  Widget _tileWithSwitch(
      String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DatingColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DatingColors.lightpink),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: DatingColors.primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _tileWithText(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DatingColors.middlepink,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DatingColors.primaryGreen),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: const TextStyle(color: DatingColors.mediumGrey),
          ),
        ],
      ),
    );
  }

  // Add this method to your _SettingsScreenState class:
  Widget travelToggleTile(BuildContext context, WidgetRef ref, String title) {
  final travelState = ref.watch(travelProvider);
  final isLoading = ref.watch(loadingProvider);
  final userdata = ref.watch(loginProvider);
  final user = userdata.data?.isNotEmpty == true ? userdata.data![0].user : null;

  // get user location
  final currentLat = user?.location?.latitude != null
      ? double.tryParse(user!.location!.latitude.toString())
      : _currentLat;
  final currentLng = user?.location?.longitude != null
      ? double.tryParse(user!.location!.longitude.toString())
      : _currentLng;

  final isTravelOn = travelState.travelMode == 1;

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isTravelOn ?DatingColors.lightpink : Colors.grey,
        width: 2,
      ),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: isTravelOn ? Colors.white: Colors.grey,
          child: const Icon(Icons.travel_explore, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isTravelOn ?DatingColors.lightpinks : Colors.black,
            ),
          ),
        ),
        if (isLoading)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else
          Switch(
            value: isTravelOn,
            onChanged: (val) async {
              if (currentLat != null && currentLng != null) {
                try {
                  await ref.read(travelProvider.notifier).addTravel(
                        val,
                        currentLat,
                        currentLng,
                      );

                  // ✅ Success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          val ? "Travel mode enabled" : "Travel mode disabled"),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Location not available. Update first.")),
                );
              }
            },
            activeColor: const Color.fromARGB(255, 227, 114, 186),
          ),
      ],
    ),
  );
}

  Widget _simpleArrowTile(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: DatingColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: DatingColors.middlepink),
        ),
        child: Row(
          children: [
            Expanded(child: Text(title)),
            const Icon(Icons.arrow_forward_ios, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _button(String text, Color bgColor, Color textColor) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DatingColors.primaryGreen),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
