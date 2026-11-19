import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/cart_controller.dart';
import '../controllers/location_controller.dart';
import '../services/location_service.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _email = '-';

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _email = prefs.getString('email') ?? '-');
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.setBool('isLoggedIn', false);

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Profil',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey.shade700,
                  child: const Icon(Icons.person, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _email,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Obx(() => Text(
                            'Jumlah Barang di Keranjang: ${Get.find<CartController>().totalQty}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _LocationCard(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: FilledButton(
                onPressed: _logout,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.shade500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu lokasi (LBS): posisi saat ini, alamat, dan jarak ke toko.
class _LocationCard extends StatelessWidget {
  const _LocationCard();

  @override
  Widget build(BuildContext context) {
    final loc = Get.find<LocationController>();
    final green = Theme.of(context).colorScheme.primary;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(() {
        final pos = loc.position.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, size: 18, color: green),
                const SizedBox(width: 6),
                const Text(
                  'Lokasi Saya',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const Spacer(),
                if (loc.isLoading.value)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  InkWell(
                    onTap: loc.refreshLocation,
                    child: Icon(Icons.my_location, size: 20, color: green),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (loc.error.value != null)
              Text(
                loc.error.value!,
                style: const TextStyle(fontSize: 11, color: Colors.red),
              )
            else if (pos == null)
              const Text(
                'Ketuk ikon di kanan untuk mengambil lokasi',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              )
            else ...[
              Text(loc.address.value, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 2),
              Text(
                '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              Text(
                'Jarak ke ${LocationService.storeName}: '
                '${loc.distanceKm.value?.toStringAsFixed(2)} km',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: green,
                ),
              ),
            ],
          ],
        );
      }),
    );
  }
}
