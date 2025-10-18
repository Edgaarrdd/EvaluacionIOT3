import 'package:flutter/material.dart';
import '../models/enums.dart'; // Importa el enum desde aquí

class FiltrosChips extends StatelessWidget {
  final FilterType currentFilter;
  final void Function(FilterType) onFilterSelected;

  const FiltrosChips({
    super.key,
    required this.currentFilter,
    required this.onFilterSelected,
  });
// filtros como chips seleccionables
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          FilterChip(
            label: const Text('Todas'),
            selected: currentFilter == FilterType.all,
            onSelected: (_) => onFilterSelected(FilterType.all),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Pendientes'),
            selected: currentFilter == FilterType.pending,
            onSelected: (_) => onFilterSelected(FilterType.pending),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Completas'),
            selected: currentFilter == FilterType.completed,
            onSelected: (_) => onFilterSelected(FilterType.completed),
          ),
        ],
      ),
    );
  }
}
