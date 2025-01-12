import 'package:charify/core/theme/app_colors.dart';
import 'package:charify/features/main/presentation/bloc/main_bloc.dart';
import 'package:charify/features/main/presentation/bloc/main_event.dart';
import 'package:charify/features/main/presentation/bloc/main_state.dart';
import 'package:charify/features/main/presentation/widget/application_list.dart';
import 'package:charify/features/main/presentation/widget/category_based_applications.dart';
import 'package:charify/features/main/presentation/widget/filters_controls.dart';
import 'package:charify/features/main/presentation/widget/user_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  static const String path = "/main";
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    context.read<MainBloc>().add(GetCategoriesEvent());

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<MainBloc>().add(LoadApplicationsEvent());
      print("endddddddddddddddddddd");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: BlocConsumer<MainBloc, MainState>(
          listener: (context, state) {
            if (state.status == MainStatus.successfullyFetchCategories) {
              context.read<MainBloc>().add(LoadApplicationsEvent());
            }
          },
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: UserHeader(),
                      ),
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: Container(
                          width: double.maxFinite,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const FiltersControls(),
                                const SizedBox(height: 20),
                                state.filterByCategory != null ||
                                        state.isUrgentFilter ||
                                        (state.searchFilter?.isNotEmpty ??
                                            false)
                                    ? const ApplicationList()
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const CategoryBasedApplications(),
                                          const SizedBox(height: 20),
                                          Text(
                                            "Recent",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                          const SizedBox(height: 16),
                                          const ApplicationList(),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
