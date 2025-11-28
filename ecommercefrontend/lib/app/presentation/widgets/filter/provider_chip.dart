import 'package:flutter/material.dart';

class ProviderChip extends StatelessWidget {
  final String value;
  final String label;
  final Color accentColor;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const ProviderChip({
    super.key,
    required this.value,
    required this.label,
    required this.accentColor,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withOpacity(0.1) : Colors.grey[100],
          border: Border.all(
            color: isSelected ? accentColor : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? accentColor : Colors.grey[400],
            ),
            const SizedBox(width: 12),
            if (icon != null)
              Icon(
                icon,
                color: isSelected ? accentColor : Colors.grey[600],
                size: 20,
              ),
            if (icon != null) const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? accentColor : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
