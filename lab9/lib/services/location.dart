import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude;
  double? longitude;

  // We use Future because getting GPS data takes time (asynchronous)
  Future<void> getCurrentLocation() async {
    try {
      // 1. Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      // 2. Request permission from the user
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      // 3. Get the actual position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);

      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print('Error getting location: $e');
    }
  }
}