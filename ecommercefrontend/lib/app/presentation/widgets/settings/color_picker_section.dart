import 'package:flutter/material.dart';

class ColorPickerSection extends StatelessWidget {
  final String label;
  final Color currentColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPickerSection({
    super.key,
    required this.label,
    required this.currentColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: currentColor,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cor Hex: #${currentColor.value.toRadixString(16).toUpperCase().padLeft(8, '0')}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      _showColorPicker(context, currentColor, onColorChanged);
                    },
                    child: const Text('Escolher Cor'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showColorPicker(
    BuildContext context,
    Color initialColor,
    Function(Color) onColorChanged,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        Color selectedColor = initialColor;
        return AlertDialog(
          title: const Text('Escolher Cor'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 8,
                  children:
                      [
                            const Color(0xFF1976D2), // Azul
                            const Color(0xFFFF6D00), // Laranja
                            const Color(0xFF4CAF50), // Verde
                            const Color(0xFFE91E63), // Rosa
                            const Color(0xFF9C27B0), // Roxo
                            const Color(0xFF00BCD4), // Ciano
                            const Color(0xFFFFC107), // Âmbar
                            const Color(0xFFFF5722), // Vermelho
                          ]
                          .map(
                            (color) => GestureDetector(
                              onTap: () {
                                selectedColor = color;
                                Navigator.pop(context);
                                onColorChanged(color);
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: color,
                                  border: Border.all(
                                    color: selectedColor == color
                                        ? Colors.black
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
