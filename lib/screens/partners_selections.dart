import 'package:dating/provider/signupprocessProviders/lookingProvider.dart';
import 'package:dating/screens/height_selection_screen.dart';
import 'package:dating/screens/meet_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class InrtoPartneroption extends ConsumerStatefulWidget {

  const InrtoPartneroption({super.key});

  @override
  ConsumerState<InrtoPartneroption> createState() => InrtoPartneroptionState();
}

class InrtoPartneroptionState extends ConsumerState<InrtoPartneroption> {

   List<String>? selectedGenderIds;
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
   List<int> selectedOptionIds = [];

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
          showonprofile = args['showonprofile'] ?? true;
          modeid=args['modeid'] ?? 0;
          modename =args['modename'] ?? '';
          selectedGenderIds=args['selectedGenderIds'] ?? [];
          selectedOptionIds=args['selectedoptionIds'] ?? [];

      });
    }
  }
  @override
  void initState() {
    super.initState();
    ref.read(lookingProvider.notifier).getLookingFor();
  }

 


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final lookingData = ref.watch(lookingProvider).data ?? [];

    return 
    Scaffold(
      backgroundColor: Colors.white,
      body:
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          // Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 16),
          //       child: 
                LinearProgressIndicator(
                  value: 8 / 18,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 147, 179, 3)),
                ),
              // ),
              const SizedBox(height: 15),
              // Back button and title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: 
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
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
                                      "selectedGenderIds":selectedGenderIds,
                                      'email':email,
                                      'mobile':mobile
                                    },
                                );
                      }),
                    const SizedBox(width: 8),
                    const Text(
                      "And What Are You Hoping \n To Find?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
               SizedBox(height: screenHeight * 0.020),
          Container(
            height: screenHeight * 0.2,
            width: screenWidth,
            child: Stack(
              //clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -20,
                  top: 0,
                  child: Image.asset(
                    'assets/Heart.png',
                    height: 175,
                    width: 175,
                    fit: BoxFit.contain,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Text(
                        textAlign: TextAlign.start,
                        'It\'s Your Dating Journey, So\nChoose 1 Or 2 Options That Feel\nRight For You.',
                        style: TextStyle(
                          letterSpacing: 0.4,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.015),

          // Options list with padding
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child:
               lookingData.isEmpty
                ? Center(child: CircularProgressIndicator())
                :ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: lookingData.length,
                itemBuilder: (context, index) {
                  final item = lookingData[index];
                final isSelected = selectedOptionIds.contains(item.id);


                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: GestureDetector(
                      onTap: () {
                          setState(() {
                            if (selectedOptionIds.contains(item.id)) {
                              selectedOptionIds.remove(item.id);
                            } else {
                              if (selectedOptionIds.length < 2) {
                                selectedOptionIds.add(item.id!);
                              }
                            }
                          });
                        },

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                             item.value ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: isSelected
                                  ? Color(0xff92AB26)
                                  : Colors.black87,
                            ),
                          ),
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? Color(0xff92AB26)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? Color(0xff92AB26)
                                    : Colors.grey[400]!,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Icon(
                                    Icons.check,
                                    size: 18,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Footer with eye icon (with padding)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.visibility_outlined,
                  size: 24,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'This Will Show On Your Profile To Help Everyone Find What They\'re Looking For.',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Bottom counter and next button (with padding)
          Padding(
            padding:
                const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedOptionIds.length}/2 Selected',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
              ],
            ),
          ),
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
                      colors: [Color(0xffB2D12E), Color(0xff000000)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onPressed: () {
                      if (selectedOptionIds.length < 3) {
                        print("✅ Proceeding with:");
                        print("mobile:$mobile");
                        print("Email: $email");
                        print("Lat: $latitude, Long: $longitude");
                        print("Username: $userName");
                        print("DOB: $dateofbirth");
                        print("Gender: $selectedgender");
                        print("Show Gender: $showonprofile");
                        // print("Selected Mode: ${showmode.value} (ID: ${showmode.id})");
                        print("Selected options: ${selectedOptionIds.toList()}");
                      
                    
                    //     // Navigator.push(...) your next screen here
                        Navigator.pushNamed(
                                    context,
                                    '/heightscreen',
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
                                      "selectedoptionIds":selectedOptionIds,
                                      'email':email,
                                      'mobile':mobile
                                    },
                                );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please select 2 options"))
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
    );
  }
}