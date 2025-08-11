import 'package:dating/provider/loginProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating/provider/loader.dart';
import '../../../provider/moreabout/starsignprovider.dart';

class StarSignScreen extends ConsumerStatefulWidget {
  const StarSignScreen({super.key});

  @override
  ConsumerState<StarSignScreen> createState() => _StarSignScreenState();
}

class _StarSignScreenState extends ConsumerState<StarSignScreen> {
  int? selectedOptionId;
  String? selectedOptionName;

  @override
  void initState() {
    super.initState();
    // Fetch star signs when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(starSignProvider.notifier).getStarsign();
    });
  }



  @override
  Widget build(BuildContext context) {
    final starSignState = ref.watch(starSignProvider);
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Select Zodiac Sign',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildContent(starSignState, isLoading),
    );
  }

  Widget _buildContent(dynamic starSignState, bool isLoading) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Check if API call was successful
    if (starSignState.success != true || starSignState.data == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              starSignState.message ?? 'Failed to load zodiac signs',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(starSignProvider.notifier).getStarsign();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    final starSigns = starSignState.data;

    if (starSigns == null || starSigns.isEmpty) {
      return const Center(
        child: Text(
          'No zodiac signs available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: starSigns.length,
      itemBuilder: (context, index) {
        final starSign = starSigns[index];
        
        // Handle null values safely
        final id = starSign?.id;
        final name = starSign?.name;
        
        // Skip items with null essential data
        if (id == null || name == null || name.isEmpty) {
          return const SizedBox.shrink();
        }
        
        final isSelected = selectedOptionId == id;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            onTap: () async {
              // Match the religion screen pattern exactly
              try {
                setState(() {
                  selectedOptionId = id;
                  selectedOptionName = name;
                });

                print('About to update profile with:');
                print('- starsignId: $id');
                print('- All other parameters: null');
                
                // Add null safety check
                final loginNotifier = ref.read(loginProvider.notifier);
                if (loginNotifier == null) {
                  throw Exception('Login provider notifier is null');
                }

                await loginNotifier.updateProfile(
                  causeId: null,
                  image: null, 
                  modeid: null,
                  bio: null, 
                  modename: null, 
                  prompt: null,
                  qualityId: null,
                  starsignId: id
                );
                
                print('Starsign updated successfully');

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Starsign updated successfully!')),
                  );
                  Navigator.pop(context);
                }
                
              } catch (e) {
                print('Detailed error: $e');
                print('Error type: ${e.runtimeType}');
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to upload starsign: $e')),
                  );
                }
              }
            },
            title: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            trailing: isSelected 
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
            tileColor: isSelected ? Colors.green.withOpacity(0.1) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: isSelected ? Colors.green : Colors.grey.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
        );
      },
    );
  }
}