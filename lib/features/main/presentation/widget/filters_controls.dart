import 'package:charify/core/ui/widgets/default_text_field.dart';
import 'package:charify/features/main/presentation/bloc/main_bloc.dart';
import 'package:charify/features/main/presentation/bloc/main_event.dart';
import 'package:charify/features/main/presentation/bloc/main_state.dart';
import 'package:charify/features/main/presentation/widget/filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FiltersControls extends StatelessWidget {
  const FiltersControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: DefaultTextField(
                onChange: (value) {
                  context.read<MainBloc>().add(
                        SetSearchFilterEvent(search: value),
                      );
                },
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(width: 12),
            Badge(
              padding: EdgeInsets.zero,
              isLabelVisible:
                  state.isUrgentFilter || (state.filterByCategory != null),
              smallSize: 8,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return const FilterDialog();
                    },
                  );
                },
                icon: const Icon(Icons.filter_list_alt),
                style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              ),
            )
          ],
        );
      },
    );
  }
}
