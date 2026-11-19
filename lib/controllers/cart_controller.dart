import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/notification_service.dart';

/// State keranjang dengan GetX (reactive) + persistensi ke Hive.
class CartController extends GetxController {
  static const String boxName = 'cart_box';

  final items = <CartItem>[].obs;

  Box get _box => Hive.box(boxName);

  @override
  void onInit() {
    super.onInit();
    items.assignAll(
      _box.values.map((e) => CartItem.fromMap(e as Map)).toList(),
    );
  }

  /// Total jumlah semua barang (dipakai untuk badge & profil).
  int get totalQty => items.fold(0, (sum, e) => sum + e.qty);

  double get totalPrice => items.fold(0.0, (sum, e) => sum + e.subtotal);

  int qtyOf(int productId) {
    final i = items.indexWhere((e) => e.product.id == productId);
    return i == -1 ? 0 : items[i].qty;
  }

  Future<void> add(Product product) async {
    final i = items.indexWhere((e) => e.product.id == product.id);
    if (i == -1) {
      final item = CartItem(product: product, qty: 1);
      items.add(item);
      await _box.put(product.id, item.toMap());
      NotificationService.show(
        id: product.id,
        title: 'Ditambahkan ke keranjang',
        body: product.title,
      );
    } else {
      await increase(product.id);
    }
  }

  Future<void> increase(int productId) async {
    final i = items.indexWhere((e) => e.product.id == productId);
    if (i == -1) return;
    final updated = items[i].copyWith(qty: items[i].qty + 1);
    items[i] = updated;
    await _box.put(productId, updated.toMap());
  }

  /// Kurangi 1; kalau tinggal 1 maka item dihapus dari keranjang.
  Future<void> decrease(int productId) async {
    final i = items.indexWhere((e) => e.product.id == productId);
    if (i == -1) return;
    if (items[i].qty <= 1) {
      await remove(productId);
      return;
    }
    final updated = items[i].copyWith(qty: items[i].qty - 1);
    items[i] = updated;
    await _box.put(productId, updated.toMap());
  }

  Future<void> remove(int productId) async {
    items.removeWhere((e) => e.product.id == productId);
    await _box.delete(productId);
  }

  Future<void> clear() async {
    items.clear();
    await _box.clear();
  }
}
