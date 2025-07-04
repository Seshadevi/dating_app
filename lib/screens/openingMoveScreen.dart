import 'dart:io';
import 'package:dating/provider/signupprocessProviders/defaultmessages.dart';
import 'package:dating/screens/addHeadlineScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OpeningMoveScreen extends ConsumerStatefulWidget {

  const OpeningMoveScreen({super.key});

  @override
  ConsumerState<OpeningMoveScreen> createState() => _OpeningMoveScreenState();
}

class _OpeningMoveScreenState extends ConsumerState<OpeningMoveScreen> {
   List<int> selectedIndexes = [];

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
   List<int>? selectedKidsIds;
   List<int>? selectedReligionIds;
   List<int>? selectedcausesIds;
   Map<int, String>? seletedprompts;

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
          selectedKidsIds=args['selectedKidsIds'] ?? [];
          selectedReligionIds= args['selectedReligionIds'] ?? [];
          selectedcausesIds = args['selectedCausesIds'] ?? [];
          seletedprompts = args['selectedPrompts'] ?? {};
          if (args['selectedmessagesIds'] != null) {
            selectedIndexes = List<int>.from(args['selectedmessagesIds']);
          }

      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch messages when screen loads
    Future.microtask(() => ref.read(defaultmessagesProvider.notifier).getdefaultmessages());
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final defaultMessages = ref.watch(defaultmessagesProvider);
    final prompts = defaultMessages.data?.map((e) => e.message ?? '').toList() ?? [];

    return Scaffold(
      
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            LinearProgressIndicator(
                value: 17/ 18,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xffB2D12E)),
              ),
              // const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                     Navigator.pushNamed(
                          context,
                          '/promptsScreen',
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
                            "selectedReligionIds":selectedReligionIds,
                            "selectedCausesIds":selectedcausesIds,
                            "selectedPrompts":seletedprompts,
                            'email':email,
                            'mobile':mobile
                          },);
                    },
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
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
                            "selectedGenderIds":selectedGenderIds,
                            "selectedoptionIds":selectedoptionIds,
                            "selectedheight":selectedheight,
                            "selectedinterestIds":selectedinterestsIds,
                            "selectedQualitiesIds":selectedQualitiesIds,
                            "selectedHabbits":selectedHabitIds,
                            "selectedKidsIds":selectedKidsIds,
                            "selectedReligionIds":selectedReligionIds,
                            "selectedCausesIds":selectedcausesIds,
                            "selectedPrompts":seletedprompts,
                            'email':email,
                            'mobile':mobile
                          },);
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 8),
              const Text(
                "What will opening Move Be?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // const SizedBox(height: 10),
            const Text(
              "Choose A First Message For All\nYour New Matches To Reply To.\nEasy!",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            // const SizedBox(height: 20),
            if (prompts.isEmpty)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: prompts.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedIndexes.contains(index);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedIndexes.remove(index);
                          } else if (selectedIndexes.length < 3) {
                            selectedIndexes.add(index);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F8E7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Color(0xffB2D12E): Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                prompts[index],
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              isSelected ? Icons.check_circle : Icons.circle_outlined,
                              color: isSelected ? Color(0xffB2D12E) : Colors.grey.shade700,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${selectedIndexes.length}/3 Selected",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 170),
                Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: screen.width * 0.125,
                    height: screen.width * 0.125,
                    decoration: BoxDecoration(
                      gradient: selectedIndexes.length == 3
                          ? const LinearGradient(
                              colors: [Color(0xffB2D12E), Color(0xff000000)],
                            )
                          : LinearGradient(
                              colors: [Colors.grey[400]!, Colors.grey[600]!],
                            ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white),
                      onPressed: () {
                        if (selectedIndexes.length == 3) {
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
                                    "selectedGenderIds":selectedGenderIds,
                                    "selectedoptionIds":selectedoptionIds,
                                    "selectedheight":selectedheight,
                                    "selectedinterestIds":selectedinterestsIds,
                                    "selectedQualitiesIds":selectedQualitiesIds,
                                    "selectedHabbits":selectedHabitIds,
                                    "selectedKidsIds":selectedKidsIds,
                                    "selectedReligionIds":selectedReligionIds,
                                    "selectedCausesIds":selectedcausesIds,
                                    "selectedPrompts":seletedprompts,
                                    "selectedmessagesIds":selectedIndexes,
                                    'email':email,
                                    'mobile':mobile
                                  },);
                              } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Please select at least three interests")),
                              );
                        }
                       
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
