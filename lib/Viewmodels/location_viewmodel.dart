import 'package:flutter_riverpod/flutter_riverpod.dart';

final locationViewModelProvider = Provider<LocationViewModel>((ref) {
  return LocationViewModel();
});

class LocationViewModel {
  void requestLocationPermission() {
    // Implement location permission logic or call repository
    print("Requesting location permission...");
  }

  void skipLocation() {
    // Handle 'Not Now' tap, maybe navigate or log event
    print("User skipped location.");
  }
}
