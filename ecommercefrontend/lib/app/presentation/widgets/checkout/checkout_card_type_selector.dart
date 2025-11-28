import 'package:flutter/material.dart';

class CheckoutCardTypeSelector extends StatelessWidget {
  final String label;
  final bool selected;

  const CheckoutCardTypeSelector({
    super.key,
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selected ? const Color(0xff7b61ff) : Colors.grey.shade300,
          width: selected ? 2 : 1,
        ),
        color: selected ? const Color(0xffe9ddff) : Colors.white,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? const Color(0xff7b61ff) : Colors.black,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
