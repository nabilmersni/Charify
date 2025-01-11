import 'package:charify/core/ui/widgets/default_checkbox.dart';
import 'package:charify/features/main/presentation/bloc/main_bloc.dart';
import 'package:charify/features/main/presentation/bloc/main_event.dart';
import 'package:charify/features/main/presentation/bloc/main_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterDialog extends StatelessWidget {
  const FilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Clear",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    itemCount: state.categories?.length ?? 0,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final category = state.categories?[index];

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('${category?.name}'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        trailing: DefaultCheckbox(
                          value: state.filterByCategory == category,
                          onChanged: (value) {
                            context.read<MainBloc>().add(
                                  ToggleFilterByCategoryEvent(
                                    categoryEntity: category!,
                                  ),
                                );
                          },
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
