import 'package:flutter/material.dart';

class CheckoutOptionBox extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool selected;

  const CheckoutOptionBox({
    super.key,
    required this.icon,
    required this.text,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selected ? const Color(0xffe9ddff) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selected ? const Color(0xff7b61ff) : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xff7b61ff)),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
