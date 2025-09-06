import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/signupprocessProviders/kidsProvider.dart';
import 'package:dating/screens/importantLife.dart';
import 'package:dating/screens/lifeStryle_habits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FamilyPlanScreen extends ConsumerStatefulWidget {
  

  const FamilyPlanScreen({
    super.key,
    
  });

  @override
  ConsumerState<FamilyPlanScreen> createState() => _FamilyPlanScreenState();
}

class _FamilyPlanScreenState extends ConsumerState<FamilyPlanScreen> {
  List<int> selectedKidsIds = [];

   String? email;
   String? mobile;
   double? latitude;
   double? longitude;
   String? dateofbirth;
   String? userName;
   String? selectedgender;
   bool? showonprofile;
   int? modeid;
   String? modename;
   List<String>? selectedGenderIds;
   List<int>? selectedoptionIds;
   int? selectedheight;
   List<int>? selectedinterestsIds;
   List<int>? selectedQualitiesIds;
   List<int>? selectedHabitIds;

    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null ) { // Prevent overwriting selected products
      setState(() {
          email= args['email'] ??'';
          mobile = args['mobile'] ?? '';
          latitude = args['latitude'] ?? 0.0;
          longitude = args['longitude'] ?? 0.0;
          dateofbirth = args['dateofbirth'] ?? '';
          userName = args['userName'] ?? '';
          selectedgender = args['selectgender'] ?? '';
          showonprofile = args['showonprofile'] ?? true;
          modeid=args['modeid'] ?? 0;
          modename =args['modename'] ?? '';
          selectedGenderIds=args['selectedGenderIds'] ?? [];
          selectedoptionIds=args['selectedoptionIds'] ?? [];
          selectedheight=args['selectedheight'] ?? 154;
          selectedinterestsIds=args['selectedinterestIds'] ?? [];
          selectedQualitiesIds=args['selectedQualitiesIds'] ?? [];
          selectedHabitIds=args['selectedHabbits'] ?? [];
          if (args['selectedKidsIds'] != null) {
            selectedKidsIds = List<int>.from(args['selectedKidsIds']);
          }

      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(kidsProvider.notifier).getKids());
  }

  void toggleSelect(int id) {
  setState(() {
    if (selectedKidsIds.contains(id)) {
      selectedKidsIds.remove(id);
    } else {
      
      if (selectedKidsIds.length < 2) {
          selectedKidsIds.add(id);
        }
    }
  });
}
 


  Widget optionButton(String text, int id, double size, double fontSize) {
    bool isSelected = selectedKidsIds.contains(id);
    return GestureDetector(
      onTap: () => toggleSelect(id),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [DatingColors.primaryGreen, DatingColors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [DatingColors.surfaceGrey, DatingColors.lightyellow,],
                ),
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: DatingColors.black,
              blurRadius: 10,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(size * 0.07),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: isSelected ? DatingColors.white : DatingColors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final bubbleSize = screen.width * 0.3;
    final bubbleFont = screen.width * 0.035;
    final kidsState = ref.watch(kidsProvider);

    return Scaffold(
      backgroundColor: DatingColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screen.width * 0.05),
                child: ListView(
                  children: [
                    LinearProgressIndicator(
                      value: 13 / 18,
                      backgroundColor:DatingColors.lightgrey,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          DatingColors.primaryGreen),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () {
                             Navigator.pushNamed(
                                        context,
                                        '/habbitsScreen',
                                        arguments: {
                                          'latitude': latitude,
                                          'longitude': longitude,
                                          'dateofbirth':dateofbirth,
                                          'userName':userName,
                                          'selectgender':selectedgender,
                                          "showonprofile":showonprofile,
                                          "modeid":modeid,
                                          "modename":modename,
                                          "selectedGenderIds":selectedGenderIds,
                                          "selectedoptionIds":selectedoptionIds,
                                          "selectedheight":selectedheight,
                                          "selectedinterestIds":selectedinterestsIds,
                                          "selectedQualitiesIds":selectedQualitiesIds,
                                          "selectedHabbits":selectedHabitIds,
                                          'email':email,
                                          'mobile':mobile
                                        },
                                    );
                          },
                        ),
                         const SizedBox(width: 8),
                        const Text(
                            "Family Plans?",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    Text(
                      "Let’s get deeper. Feel free to skip if you'd prefer not to say.",
                      style: TextStyle(
                        color: DatingColors.darkGrey,
                        fontSize: screen.width * 0.038,
                      ),
                    ),
                    // Text(
                    //   "Have Kids",
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: screen.width * 0.045,
                    //   ),
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   children: [
                    //     optionButton("Have Kids +", -1, bubbleSize, bubbleFont),
                    //     optionButton(
                    //         "Don’t Have\nKids ++", -2, bubbleSize, bubbleFont),
                    //   ],
                    // ),
                    SizedBox(height: screen.height * 0.08),
                    Text(
                      "Kids",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screen.width * 0.059,
                      ),
                    ),
                     SizedBox(height: screen.height * 0.06),
                    if (kidsState.data == null || kidsState.data!.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else
                      Wrap(
                        alignment: WrapAlignment.spaceAround,
                        spacing: screen.width * 0.02,
                        runSpacing: screen.height * 0.019,
                        children: kidsState.data!.map((kid) {
                          return optionButton(kid.kids ?? '', kid.id ?? 0,
                              bubbleSize, bubbleFont);
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            // Bottom section - Fixed
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color:DatingColors.white,
                boxShadow: [
                  BoxShadow(
                    color: DatingColors.black,
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                         Navigator.pushNamed(
                                        context,
                                        '/religionScreen',
                                        arguments: {
                                          'latitude': latitude,
                                          'longitude': longitude,
                                          'dateofbirth':dateofbirth,
                                          'userName':userName,
                                          'selectgender':selectedgender,
                                          "showonprofile":showonprofile,
                                          "modeid":modeid,
                                          "modename":modename,
                                          "selectedGenderIds":selectedGenderIds,
                                          "selectedoptionIds":selectedoptionIds,
                                          "selectedheight":selectedheight,
                                          "selectedinterestIds":selectedinterestsIds,
                                          "selectedQualitiesIds":selectedQualitiesIds,
                                          "selectedHabbits":selectedHabitIds,
                                          'email':email,
                                          'mobile':mobile
                                        },
                                    );
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 16,
                          color: DatingColors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${selectedKidsIds.length}/1 Selected',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Gradient button
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: selectedKidsIds.length == 1
                                ? const LinearGradient(
                                    colors: [DatingColors.primaryGreen, DatingColors.black],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )
                                : null,
                            color: selectedKidsIds.length != 1
                                ? DatingColors.lightGreen
                                : null,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: DatingColors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              if (selectedKidsIds.isNotEmpty) {
                                Navigator.pushNamed(
                                        context,
                                        '/religionScreen',
                                        arguments: {
                                          'latitude': latitude,
                                          'longitude': longitude,
                                          'dateofbirth':dateofbirth,
                                          'userName':userName,
                                          'selectgender':selectedgender,
                                          "showonprofile":showonprofile,
                                          "modeid":modeid,
                                          "modename":modename,
                                          "selectedGenderIds":selectedGenderIds,
                                          "selectedoptionIds":selectedoptionIds,
                                          "selectedheight":selectedheight,
                                          "selectedinterestIds":selectedinterestsIds,
                                          "selectedQualitiesIds":selectedQualitiesIds,
                                          "selectedHabbits":selectedHabitIds,
                                          "selectedKidsIds":selectedKidsIds,
                                          'email':email,
                                          'mobile':mobile
                                        },
                                    );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please select at least one option")),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






