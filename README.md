# latres_dari_ikram

Latihan responsi Shopedia - Praktikum Pemrograman Aplikasi Mobile (SI-D).

## Fitur wajib
- **Login** (SharedPreferences), **Home** (GridView + BottomNavigationBar), **Detail** (hero image, rating, tombol keranjang 2 kondisi), **Keranjang** (Hive), **Profil** (email, jumlah barang, logout)
- Fetch & parse API dipisah di `services/api_service.dart`

## Fitur opsional (poin tambahan)
- **Model**: `models/product.dart`, `models/cart_item.dart`
- **GetX**: `controllers/cart_controller.dart` (state keranjang reaktif, qty +/-, badge angka di ikon keranjang, total harga; tetap disimpan di Hive) dan `controllers/location_controller.dart`
- **Notification**: `services/notification_service.dart` - notifikasi lokal saat produk ditambahkan ke keranjang
- **LBS**: `services/location_service.dart` - di halaman Profil ambil lokasi saat ini (GPS), alamat, dan jarak ke toko

## Menjalankan
```
flutter create .
flutter pub get
```

### Setup Android (wajib untuk notifikasi & lokasi)
1. `android/app/src/main/AndroidManifest.xml`, tambahkan di atas `<application>`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```
2. `flutter_local_notifications` butuh core library desugaring. Di `android/app/build.gradle(.kts)`:
```kotlin
android {
    compileOptions {
        isCoreLibraryDesugaringEnabled = true   // Groovy: coreLibraryDesugaringEnabled true
    }
}
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```
(jika build error soal `minSdk`, set `minSdk = 21` atau lebih.)

### Setup iOS (opsional)
Tambahkan di `ios/Runner/Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Lokasi dipakai untuk menghitung jarak ke toko</string>
```

Lalu `flutter run`. Di emulator, set lokasi lewat Extended controls > Location.
