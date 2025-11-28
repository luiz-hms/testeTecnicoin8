mixin Validations {
  String? isNotEmpty(String? value, [String? message]) {
    if (value!.isEmpty) return message ?? 'esse campo é obrigatório';
    return null;
  }

  String? combine(List<String? Function()> validators) {
    for (final func in validators) {
      final validation = func();
      if (validation != null) return validation;
    }
    return null;
  }

  String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Número do cartão é obrigatório';
    }
    // Remove espaços para validação
    final cleanValue = value.replaceAll(' ', '');
    if (cleanValue.length != 16) {
      return 'Número do cartão deve ter 16 dígitos';
    }
    if (!RegExp(r'^\d+$').hasMatch(cleanValue)) {
      return 'Apenas números são permitidos';
    }
    return null;
  }

  String? validateExpirationDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Data de validade é obrigatória';
    }

    // Remove a barra para validação
    final cleanValue = value.replaceAll('/', '');

    if (cleanValue.length != 4) {
      return 'Formato: MM/AA (Ex: 09/25)';
    }

    if (!RegExp(r'^\d+$').hasMatch(cleanValue)) {
      return 'Apenas números são permitidos';
    }

    // Valida o mês
    final month = int.tryParse(cleanValue.substring(0, 2));
    if (month == null || month < 1 || month > 12) {
      return 'Mês inválido (use 01-12)';
    }

    // Valida o ano
    final year = int.tryParse(cleanValue.substring(2, 4));
    if (year == null) {
      return 'Ano inválido';
    }

    // Verifica se o cartão não está expirado
    final now = DateTime.now();
    final currentYear = now.year % 100; // Últimos 2 dígitos do ano atual
    final currentMonth = now.month;

    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return 'Cartão expirado';
    }

    return null;
  }

  String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV é obrigatório';
    }
    if (value.length != 3) {
      return 'CVV deve ter 3 dígitos';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Apenas números são permitidos';
    }
    return null;
  }
}
