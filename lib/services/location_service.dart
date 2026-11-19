import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Location Based Service (opsional di soal).
class LocationService {
  // Lokasi toko Shopedia (contoh): sekitar kampus UPN "Veteran" Yogyakarta.
  static const String storeName = 'Toko Shopedia (UPN Veteran Yogyakarta)';
  static const double storeLat = -7.7607;
  static const double storeLng = 110.4118;

  /// Ambil posisi saat ini; melempar pesan error yang ramah pengguna.
  static Future<Position> getCurrentPosition() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw 'Layanan lokasi (GPS) belum aktif';
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw 'Izin lokasi ditolak';
    }
    if (permission == LocationPermission.deniedForever) {
      throw 'Izin lokasi ditolak permanen, aktifkan lewat pengaturan';
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Koordinat -> alamat. Jika gagal, kembalikan teks koordinat.
  static Future<String> addressFrom(Position p) async {
    try {
      final marks =
          await Geocoding().placemarkFromCoordinates(p.latitude, p.longitude);
      if (marks.isNotEmpty) {
        final m = marks.first;
        final parts = <String>[
          if (m.street?.trim().isNotEmpty == true) m.street!,
          if (m.subLocality?.trim().isNotEmpty == true) m.subLocality!,
          if (m.locality?.trim().isNotEmpty == true) m.locality!,
          if (m.administrativeArea?.trim().isNotEmpty == true)
            m.administrativeArea!,
        ];
        if (parts.isNotEmpty) return parts.join(', ');
      }
    } catch (_) {}
    return '${p.latitude.toStringAsFixed(5)}, ${p.longitude.toStringAsFixed(5)}';
  }

  /// Jarak lurus ke toko (km).
  static double distanceToStoreKm(Position p) =>
      Geolocator.distanceBetween(p.latitude, p.longitude, storeLat, storeLng) /
      1000;
}
