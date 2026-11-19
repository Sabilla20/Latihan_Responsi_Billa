import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Tombol  −  angka  +  untuk mengubah jumlah barang.
class QtyStepper extends StatelessWidget {
  final int qty;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final bool compact;

  const QtyStepper({
    super.key,
    required this.qty,
    required this.onMinus,
    required this.onPlus,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final green = Get.theme.colorScheme.primary;
    final size = compact ? 26.0 : 34.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _btn(Icons.remove, onMinus, size, green),
        SizedBox(
          width: compact ? 30 : 40,
          child: Text(
            '$qty',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: compact ? 13 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _btn(Icons.add, onPlus, size, green),
      ],
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap, double size, Color color) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color),
        ),
        child: Icon(icon, size: size * 0.55, color: color),
      ),
    );
  }
}
