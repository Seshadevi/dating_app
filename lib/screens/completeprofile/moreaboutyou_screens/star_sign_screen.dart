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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(starSignProvider.notifier).getStarsign();
    });
  }

  Future<void> _selectStarSign(int id, String name) async {
    setState(() {
      selectedOptionId = id;
      selectedOptionName = name;
    });

    try {
      await ref.read(loginProvider.notifier).updateProfile(
        causeId: null,
        image: null,
        modeid: null,
        bio: null,
        modename: null,
        prompt: null,
        qualityId: null,
        starsignId: id,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name updated successfully!')),
        );
        Navigator.pop(context, selectedOptionName);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update starsign: $e')),
        );
      }
    }
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildOptions(starSignState),
    );
  }

  Widget _buildOptions(dynamic starSignState) {
    if (starSignState.success != true || starSignState.data == null) {
      return Center(
        child: ElevatedButton(
          onPressed: () => ref.read(starSignProvider.notifier).getStarsign(),
          child: const Text('Try Again'),
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          ...starSigns.map<Widget>((starSign) {
            final id = starSign?.id;
            final name = starSign?.name ?? '';
            if (id == null || name.isEmpty) return const SizedBox.shrink();

            final isSelected = selectedOptionId == id;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: GestureDetector(
                onTap: () => _selectStarSign(id, name),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xFFB2D12E), Color(0xFF2B2B2B)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : const Color(0xFFB2D12E),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
