import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../models/cart_item.dart';
import '../widgets/qty_stepper.dart';
import 'detail_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final green = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Keranjang',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: Obx(() {
        if (cart.items.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 56, color: Colors.grey),
                SizedBox(height: 8),
                Text('Keranjang masih kosong'),
              ],
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: cart.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, i) =>
                    _CartRow(item: cart.items[i], cart: cart),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total (${cart.totalQty} barang)',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '\$${cart.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _CartRow extends StatelessWidget {
  final CartItem item;
  final CartController cart;
  const _CartRow({required this.item, required this.cart});

  @override
  Widget build(BuildContext context) {
    final p = item.product;
    final green = Theme.of(context).colorScheme.primary;
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => Get.to(() => DetailPage(productId: p.id)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: Image.network(
                  p.image,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) =>
                      const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${p.price}',
                      style: TextStyle(
                        color: green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    QtyStepper(
                      compact: true,
                      qty: item.qty,
                      onMinus: () => cart.decrease(p.id),
                      onPlus: () => cart.increase(p.id),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  cart.remove(p.id);
                  Get.snackbar(
                    'Keranjang',
                    'Dihapus dari keranjang',
                    duration: const Duration(seconds: 1),
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
