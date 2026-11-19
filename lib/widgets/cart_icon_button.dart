import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../pages/cart_page.dart';

/// Ikon keranjang dengan badge angka total barang (reactive via GetX).
class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    return IconButton(
      onPressed: () => Get.to(() => const CartPage()),
      icon: Obx(() {
        final n = cart.totalQty;
        return Badge(
          isLabelVisible: n > 0,
          label: Text('$n'),
          child: const Icon(Icons.shopping_cart_outlined),
        );
      }),
    );
  }
}
