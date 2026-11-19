import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/cart_icon_button.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _api = ApiService();
  late Future<List<Product>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchProducts();
  }

  void _reload() => setState(() => _future = _api.fetchProducts());

  @override
  Widget build(BuildContext context) {
    final green = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopedia',
          style: TextStyle(
            color: green,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [CartIconButton()],
      ),
      body: FutureBuilder<List<Product>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
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

          final products = snapshot.data ?? [];
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.68,
            ),
            itemCount: products.length,
            itemBuilder: (context, i) => _ProductCard(product: products[i]),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPage(productId: product.id),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  loadingBuilder: (c, child, p) => p == null
                      ? child
                      : const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                  errorBuilder: (c, e, s) =>
                      const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        '${product.rating}',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
