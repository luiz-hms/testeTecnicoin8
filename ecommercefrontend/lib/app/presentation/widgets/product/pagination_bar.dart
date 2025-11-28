import 'package:flutter/material.dart';

class PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final Color? accentColor;

  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? Theme.of(context).primaryColor;

    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // First page button
          _buildIconButton(
            icon: Icons.first_page,
            onPressed: currentPage > 1 ? () => onPageChanged(1) : null,
            tooltip: 'Primeira página',
          ),

          const SizedBox(width: 8),

          // Previous page button
          _buildIconButton(
            icon: Icons.chevron_left,
            onPressed: currentPage > 1
                ? () => onPageChanged(currentPage - 1)
                : null,
            tooltip: 'Página anterior',
          ),

          const SizedBox(width: 16),

          // Page numbers
          ..._buildPageNumbers(color),

          const SizedBox(width: 16),

          // Next page button
          _buildIconButton(
            icon: Icons.chevron_right,
            onPressed: currentPage < totalPages
                ? () => onPageChanged(currentPage + 1)
                : null,
            tooltip: 'Próxima página',
          ),

          const SizedBox(width: 8),

          // Last page button
          _buildIconButton(
            icon: Icons.last_page,
            onPressed: currentPage < totalPages
                ? () => onPageChanged(totalPages)
                : null,
            tooltip: 'Última página',
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      tooltip: tooltip,
      color: onPressed != null ? Colors.black87 : Colors.grey[400],
      disabledColor: Colors.grey[300],
    );
  }

  List<Widget> _buildPageNumbers(Color accentColor) {
    List<Widget> pages = [];

    // Logic to show: [1] ... [current-1] [current] [current+1] ... [total]
    for (int i = 1; i <= totalPages; i++) {
      // Always show first page, last page, and pages around current
      final showPage =
          i == 1 ||
          i == totalPages ||
          (i >= currentPage - 1 && i <= currentPage + 1);

      if (showPage) {
        pages.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _buildPageButton(i, accentColor),
          ),
        );
      } else if (i == currentPage - 2 || i == currentPage + 2) {
        // Add ellipsis for gaps
        pages.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
        );
      }
    }

    return pages;
  }

  Widget _buildPageButton(int pageNumber, Color accentColor) {
    final isActive = pageNumber == currentPage;

    return ElevatedButton(
      onPressed: isActive ? null : () => onPageChanged(pageNumber),
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? accentColor : Colors.white,
        foregroundColor: isActive ? Colors.white : Colors.black87,
        disabledBackgroundColor: accentColor,
        disabledForegroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isActive ? accentColor : Colors.grey[300]!,
            width: 1,
          ),
        ),
        elevation: isActive ? 2 : 0,
      ),
      child: Text(
        '$pageNumber',
        style: TextStyle(
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
