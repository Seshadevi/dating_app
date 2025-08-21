import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/screens/introMail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating/provider/signupprocessProviders/modeProvider.dart';
import 'package:dating/screens/meet_selection.dart';
import '../model/signupprocessmodels/modeModel.dart';
import 'package:collection/collection.dart';

class IntroDatecategory extends ConsumerStatefulWidget {

  const IntroDatecategory({super.key});

  @override
  ConsumerState<IntroDatecategory> createState() => _IntroDatecategoryState();
}

class _IntroDatecategoryState extends ConsumerState<IntroDatecategory> {
   Data? selectedMode;
   String? mobile;
   double? latitude;
   double? longitude;
   String? dateofbirth;
   String? userName;
   String? selectedgender;
   bool? showonprofile;
   String? email;
   int? modeid;
   String? modename;

@override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null ) { // Prevent overwriting selected products
      setState(() {
          email= args['email'] ??'';
          mobile = args['mobile'] ?? '';
          latitude = args['latitude'] ?? 0.0 ;
          longitude = args['longitude'] ?? 0.0 ;
          dateofbirth = args['dateofbirth'] ?? '';
          userName = args['userName'] ?? '';
          selectedgender = args['selectgender'] ?? '';
          showonprofile = args['showonprofile'] ?? true ;
          if (args.containsKey('modeid') && args['modeid'] != null) {
            modeid = args['modeid'];
          }
          if (args.containsKey('modename') && args['modename'] != null && args['modename'].toString().isNotEmpty) {
            modename = args['modename'];
          }

        
      });
      // If mode list is already loaded, try selecting the matching mode
        final modes = ref.read(modesProvider).data ?? [];
        selectedMode = modes.firstWhereOrNull((mode) => mode.id == modeid);
        }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(modesProvider.notifier).getModes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final modeModel = ref.watch(modesProvider);
    final modes = modeModel.data ?? [];
    final isLoading = modeModel.data == null || modeModel.data!.isEmpty;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 40),
              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LinearProgressIndicator(
                  value: 6 / 18,
                  backgroundColor: DatingColors.lightgrey,
                  valueColor: const AlwaysStoppedAnimation<Color>(DatingColors.primaryGreen),
                ),
              ),
              const SizedBox(height: 3),
              // Back button and title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      iconSize: 30,
                      onPressed: () {
                         Navigator.pushNamed(
                                    context,
                                    '/emailscreen',
                                    arguments: {
                                      'latitude': latitude,
                                      'longitude': longitude,
                                      'dateofbirth':dateofbirth,
                                      'userName':userName,
                                      'selectgender':selectedgender,
                                      "showonprofile":showonprofile,
                                      'email':email,
                                      'mobile':mobile
                                    },
                                );
                      }
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "What Brings You Here?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Looking for Love or Friendship",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Mode list
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: modes.length,
                        itemBuilder: (context, index) {
                          final mode = modes[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildModeOption(mode),
                          );
                        },
                      ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Icon(Icons.remove_red_eye_outlined, color: DatingColors.lightgrey),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "You’ll only be shown to people in the same mode as you.",
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
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 24, bottom: 24),
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: screenWidth * 0.125,
                      height: screenWidth * 0.125,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [DatingColors.primaryGreen, DatingColors.black],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, color: DatingColors.white),
                        onPressed: () {
                          if (selectedMode != null && modeid == 4) {
                             print("modeid:$modeid");
                              print("modename:$modename");
                             Navigator.pushNamed(
                                    context,
                                    '/intromeetgender',
                                    arguments: {
                                      'latitude': latitude,
                                      'longitude': longitude,
                                      'dateofbirth':dateofbirth,
                                      'userName':userName,
                                      'selectgender':selectedgender,
                                      "showonprofile":showonprofile,
                                      "modeid":modeid,
                                      "modename":modename,
                                      'email':email,
                                      'mobile':mobile
                                    },
                                );
                            
                          } 
                          else if(selectedMode != null && (modeid == 5||modeid == 6)) {
                              print("modeid: $modeid (type: ${modeid.runtimeType})");
                              print("modename: $modename (type: ${modename.runtimeType})");
                              print("latitude: $latitude (type: ${latitude.runtimeType})");
                              print("longitude: $longitude (type: ${longitude.runtimeType})");
                              print("dateofbirth: $dateofbirth (type: ${dateofbirth.runtimeType})");
                              print("userName: $userName (type: ${userName.runtimeType})");
                              print("selectedgender: $selectedgender (type: ${selectedgender.runtimeType})");
                              print("showonProfile: $showonprofile (type: ${showonprofile.runtimeType})");
                              print("email: $email (type: ${email.runtimeType})");
                              print("mobile: $mobile (type: ${mobile.runtimeType})");

                             Navigator.pushNamed(
                                    context,
                                    '/photosScreen',
                                    arguments: {
                                      'latitude': latitude,
                                      'longitude': longitude,
                                      'dateofbirth':dateofbirth,
                                      'userName':userName,
                                      'selectgender':selectedgender,
                                      "showonprofile":showonprofile,
                                      "modeid":modeid,
                                      "modename":modename,
                                      'email':email,
                                      'mobile':mobile
                                    },
                                );
                            
                          } 
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please select a mode")),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeOption(Data mode) {
    final isSelected = selectedMode?.id == mode.id;
    final textColor = isSelected ? DatingColors.white : DatingColors.black;

    return InkWell(
      onTap: () => setState(() {selectedMode = mode; modeid=mode.id; modename=mode.value;}),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          gradient: isSelected
      ? LinearGradient(
          colors: [DatingColors.darkGreen, DatingColors.brown],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : LinearGradient(
          colors: [DatingColors.lightGreen, DatingColors.lightGreen],
        ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            width: 2,
            color: isSelected ? DatingColors.white : DatingColors.darkGreen,
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
                  mode.value ?? '',
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
                          ? DatingColors.white
                          : DatingColors.darkGreen,
                      width: 2,
                    ),
                    color: isSelected
                        ? DatingColors.primaryGreen
                        : DatingColors.white,
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: DatingColors.white,
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              getModeDescription(mode.value ?? ''),
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

  String getModeDescription(String mode) {
    switch (mode.toLowerCase()) {
      case 'date':
        return "Find a relationship, something casual, or anything in-between";
      case 'bff':
        return "Make new friends and find your community";
      case 'bizz':
        return "Network professionally and make career moves";
      default:
        return "Explore this mode";
    }
  }
}
