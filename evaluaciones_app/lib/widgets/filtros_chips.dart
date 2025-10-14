import 'package:flutter/material.dart';

enum FilterType {
  all,
  pending,
  completed
}

// Widget para los chips de filtro con animaciones
class FiltrosChips extends StatelessWidget {
  final FilterType currentFilter;
  final void Function(FilterType) onFilterSelected;

  const FiltrosChips({
    super.key,
    required this.currentFilter,
    required this.onFilterSelected,
  });
// Construir el widget con animaciones
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        spacing: 8.0,
        children: FilterType.values.map((filter) {
          return ChoiceChip(
            label: Text(filter.name.toUpperCase()),
            selected: currentFilter == filter,
            onSelected: (selected) {
              if (selected) {
                onFilterSelected(filter);
              }
            },
          );
        }).toList(),
      ),
    );
  }
}
