import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../controllers/cart_controller.dart';
import '../widgets/cart_icon_button.dart';
import '../widgets/qty_stepper.dart';

class DetailPage extends StatefulWidget {
  final int productId;
  const DetailPage({super.key, required this.productId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _api = ApiService();
  late Future<Product> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchProductDetail(widget.productId);
  }

  void _reload() =>
      setState(() => _future = _api.fetchProductDetail(widget.productId));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: const [CartIconButton()],
      ),
      body: FutureBuilder<Product>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 8),
                  Text('${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: _reload,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          return _DetailBody(product: snapshot.data!);
        },
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  final Product product;
  const _DetailBody({required this.product});

  @override
  Widget build(BuildContext context) {
    final green = Theme.of(context).colorScheme.primary;
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              // Hero image
              Container(
                color: Colors.white,
                height: 320,
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  loadingBuilder: (c, child, p) => p == null
                      ? child
                      : const Center(child: CircularProgressIndicator()),
                  errorBuilder: (c, e, s) =>
                      const Icon(Icons.broken_image, size: 48),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '\$${product.price}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${product.rating}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.ratingCount})',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Deskripsi Produk',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.description,
                      style: const TextStyle(fontSize: 13, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(12),
            // Reactive: berubah otomatis mengikuti isi keranjang (GetX).
            child: Obx(() {
              final cart = Get.find<CartController>();
              final qty = cart.qtyOf(product.id);
              if (qty == 0) {
                return SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: () {
                      cart.add(product);
                      Get.snackbar(
                        'Keranjang',
                        'Ditambahkan ke keranjang',
                        duration: const Duration(seconds: 1),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text('Masukkan ke Keranjang'),
                  ),
                );
              }
              return Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: green),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$qty di keranjang',
                      style: TextStyle(
                        color: green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    QtyStepper(
                      qty: qty,
                      onMinus: () => cart.decrease(product.id),
                      onPlus: () => cart.increase(product.id),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
