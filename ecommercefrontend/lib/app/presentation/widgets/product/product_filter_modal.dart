import 'package:flutter/material.dart';
import '../../../data/models/product/product_filters.dart';
import '../filter/provider_chip.dart';
import '../filter/price_field.dart';

class ProductFilterModal extends StatefulWidget {
  final ProductFilters currentFilters;
  final Color? accentColor;

  const ProductFilterModal({
    super.key,
    required this.currentFilters,
    this.accentColor,
  });

  @override
  State<ProductFilterModal> createState() => _ProductFilterModalState();
}

class _ProductFilterModalState extends State<ProductFilterModal> {
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;
  String? _selectedProvider;

  @override
  void initState() {
    super.initState();
    _selectedProvider = widget.currentFilters.provider;
    _minPriceController = TextEditingController(
      text: widget.currentFilters.minPrice?.toStringAsFixed(2) ?? '',
    );
    _maxPriceController = TextEditingController(
      text: widget.currentFilters.maxPrice?.toStringAsFixed(2) ?? '',
    );
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final minPrice = _minPriceController.text.isEmpty
        ? null
        : double.tryParse(_minPriceController.text.replaceAll(',', '.'));
    final maxPrice = _maxPriceController.text.isEmpty
        ? null
        : double.tryParse(_maxPriceController.text.replaceAll(',', '.'));

    final filters = ProductFilters(
      provider: _selectedProvider,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );

    // Clear fields after applying so modal is clean next time
    setState(() {
      _selectedProvider = null;
      _minPriceController.clear();
      _maxPriceController.clear();
    });

    Navigator.of(context).pop(filters);
  }

  void _clearFilters() {
    setState(() {
      _selectedProvider = null;
      _minPriceController.clear();
      _maxPriceController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.accentColor ?? Theme.of(context).primaryColor;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.filter_list, color: color, size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      'Filtros Avançados',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Provider Filter
            const Text(
              'Fornecedor',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            ProviderChip(
              value: 'brazilian_provider',
              label: 'Fornecedor Brasileiro',
              accentColor: color,
              isSelected: _selectedProvider == 'brazilian_provider',
              icon: Icons.store,
              onTap: () {
                setState(() {
                  _selectedProvider = _selectedProvider == 'brazilian_provider'
                      ? null
                      : 'brazilian_provider';
                });
              },
            ),
            const SizedBox(height: 8),
            ProviderChip(
              value: 'european_provider',
              label: 'Fornecedor Europeu',
              accentColor: color,
              isSelected: _selectedProvider == 'european_provider',
              icon: Icons.flight,
              onTap: () {
                setState(() {
                  _selectedProvider = _selectedProvider == 'european_provider'
                      ? null
                      : 'european_provider';
                });
              },
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Price Range Filter
            const Text(
              'Faixa de Preço',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: PriceField(
                    controller: _minPriceController,
                    label: 'Preço Mínimo',
                    hint: 'R\$ 0,00',
                    accentColor: color,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PriceField(
                    controller: _maxPriceController,
                    label: 'Preço Máximo',
                    hint: 'R\$ 999,99',
                    accentColor: color,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearFilters,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey[400]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Limpar Filtros'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Aplicar Filtros'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
