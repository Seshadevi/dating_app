import 'dart:io';
import 'package:dating/screens/openingMoveScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoUploadScreen extends StatefulWidget {

  const PhotoUploadScreen({super.key, });

  @override
  State<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
   List<File?> selectedImages = List.filled(6, null);

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
   List<int>? selectedIndexes;

    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    print("inside profile");
    if (args != null ) { // Prevent overwriting selected products
      setState(() {
          email= args['email'] ??'';
          mobile = args['mobile'] ?? '';
          latitude = args['latitude'] ?? 0.0;
          longitude = args['longitude'] ?? 0.0;
          dateofbirth = args['dateofbirth'] ?? '';
          userName = args['userName'] ?? '';
          selectedgender = args['selectgender'] ?? '';
          showonprofile = args['showonprofile'] ?? false;
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
          selectedIndexes=args['selectedmessagesIds']?? [];
          if (args['selectedImages'] != null) {
              selectedImages = (args['selectedImages'] as List<File?>);
            }

      });
      print("latitude:$latitude");
      print("longitude:$longitude");
      print("dateofbirth:$dateofbirth");
      print("userName:$userName");
      print("selectedgender:$selectedgender");
      print("showonProfile:$showonprofile");
      print("email:$email");
      print("mobile:$mobile");
    }
  }


  Future<void> _pickImage(int index) async {
    final picker = ImagePicker();
    final XFile? pickedImage = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (context) => _buildPickerSheet(picker),
    );

    if (pickedImage != null) {
      setState(() {
        selectedImages[index] = File(pickedImage.path);
      });
    }
  }

  Widget _buildPickerSheet(ImagePicker picker) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take Photo'),
            onTap: () async {
              final image = await picker.pickImage(source: ImageSource.camera);
              Navigator.pop(context, image);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Choose from Gallery'),
            onTap: () async {
              final image = await picker.pickImage(source: ImageSource.gallery);
              Navigator.pop(context, image);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    int imageCount = selectedImages.where((img) => img != null).length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: 18 / 18,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 147, 179, 3)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: (){
                        if(modename == "DATE"){
                              Navigator.pushNamed(
                                        context,
                                        '/defaultmessagesScreen',
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
                          
                        }
                        else if(modename == "BFF" || modename == "BIZZ"){
                               Navigator.pushNamed(
                                        context,
                                        '/modescreen',
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
                                    },);
                          
                        }
                    },
                  ),
                  // const Spacer(),
                  // GestureDetector(
                  //   onTap: () {
                  //     // Skip navigation
                  //   },
                  //   child: const Text(
                  //     'Skip',
                  //     style: TextStyle(
                  //       color: Colors.grey,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "Time To Put A Face To The Name",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "You Do You! Add At Least 4 Photos, Whether It’s You With Your Pet, Eating Your Fave Food, Or In A Place You Love.",
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(6, (index) {
                  return GestureDetector(
                    onTap: () => _pickImage(index),
                    child: Container(
                      width: 90,
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.greenAccent,
                          width: 2,
                        ),
                      ),
                      child: selectedImages[index] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                selectedImages[index]!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.add, size: 32),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              /// Changed section starts here
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Want To Make Sure You Really Shine?",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Go to photo tips
                  },
                  child: const Text(
                    "Check Out Our Photo Tips",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              /// Changed section ends here

              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$imageCount/4 Selected',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: screen.width * 0.125,
                      height: screen.width * 0.125,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xffB2D12E), Color(0xff000000)],
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios,
                            color: Colors.white),
                        onPressed: () {
                          if (imageCount >= 4) {
                           Navigator.pushNamed(
                                        context,
                                        '/addheadlinescreen',
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
                                          "selectedImages":selectedImages,
                                          'email':email,
                                          'mobile':mobile
                                        },);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Please upload at least 4 photos."),
                                      ),
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
      ),
    );
  }
}
