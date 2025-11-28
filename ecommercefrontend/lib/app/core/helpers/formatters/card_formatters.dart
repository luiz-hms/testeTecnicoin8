import 'package:flutter/services.dart';

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');

    // Limita a 16 dígitos
    if (text.length > 16) {
      return oldValue;
    }

    // Permite apenas números
    if (text.isNotEmpty && !RegExp(r'^\d+$').hasMatch(text)) {
      return oldValue;
    }

    // Adiciona espaço a cada 4 dígitos
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ExpirationDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');

    // Limita a 4 dígitos (MMAA)
    if (text.length > 4) {
      return oldValue;
    }

    // Permite apenas números
    if (text.isNotEmpty && !RegExp(r'^\d+$').hasMatch(text)) {
      return oldValue;
    }

    // Adiciona barra após 2 dígitos
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class CVVFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Limita a 3 dígitos
    if (text.length > 3) {
      return oldValue;
    }

    // Permite apenas números
    if (text.isNotEmpty && !RegExp(r'^\d+$').hasMatch(text)) {
      return oldValue;
    }

    return newValue;
  }
}
