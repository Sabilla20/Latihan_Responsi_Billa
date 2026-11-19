import 'product.dart';

/// Satu baris di keranjang: produk + jumlahnya.
class CartItem {
  final Product product;
  final int qty;

  CartItem({required this.product, required this.qty});

  double get subtotal => product.price * qty;

  CartItem copyWith({int? qty}) =>
      CartItem(product: product, qty: qty ?? this.qty);

  Map<String, dynamic> toMap() => {'product': product.toMap(), 'qty': qty};

  factory CartItem.fromMap(Map<dynamic, dynamic> map) => CartItem(
        product: Product.fromMap(map['product'] as Map),
        qty: map['qty'] as int,
      );
}
