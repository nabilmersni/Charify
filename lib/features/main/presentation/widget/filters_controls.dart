import 'package:charify/core/ui/widgets/default_text_field.dart';
import 'package:charify/features/main/presentation/widget/filter_dialog.dart';
import 'package:flutter/material.dart';

class FiltersControls extends StatelessWidget {
  const FiltersControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: DefaultTextField(
            hintText: 'Search',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return const FilterDialog();
              },
            );
          },
          icon: const Icon(Icons.filter_list_alt),
        )
      ],
    );
  }
}
