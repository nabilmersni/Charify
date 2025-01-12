import 'package:charify/core/theme/app_colors.dart';
import 'package:charify/features/main/presentation/bloc/main_bloc.dart';
import 'package:charify/features/main/presentation/bloc/main_event.dart';
import 'package:charify/features/main/presentation/bloc/main_state.dart';
import 'package:charify/features/main/presentation/widget/application_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBasedApplications extends StatelessWidget {
  const CategoryBasedApplications({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.applicationsByCategory?.keys.length ?? 0,
          itemBuilder: (context, index) {
            final category =
                state.applicationsByCategory?.keys.elementAt(index);
            final applications = state.applicationsByCategory?[category];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${category?.name}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<MainBloc>().add(
                              ToggleFilterByCategoryEvent(
                                  categoryEntity: category),
                            );
                      },
                      child: Text(
                        'All',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${category?.description}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.text.withOpacity(0.7),
                      ),
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: applications?.length ?? 0,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final application = (applications ?? []).elementAt(index);
                    return ApplicationWidget(applicationEntity: application);
                  },
                ),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 16);
          },
        );
      },
    );
  }
}
