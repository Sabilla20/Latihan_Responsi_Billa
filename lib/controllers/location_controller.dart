import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../services/location_service.dart';

/// State lokasi pengguna dengan GetX.
class LocationController extends GetxController {
  final position = Rxn<Position>();
  final address = ''.obs;
  final distanceKm = RxnDouble();
  final isLoading = false.obs;
  final error = RxnString();

  Future<void> refreshLocation() async {
    isLoading.value = true;
    error.value = null;
    try {
      final pos = await LocationService.getCurrentPosition();
      position.value = pos;
      distanceKm.value = LocationService.distanceToStoreKm(pos);
      address.value = await LocationService.addressFrom(pos);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
