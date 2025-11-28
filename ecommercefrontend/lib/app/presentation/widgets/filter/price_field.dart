import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PriceField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final Color? accentColor;

  const PriceField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\,?\d{0,2}')),
      ],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: 'R\$ ',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: accentColor ?? Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}
