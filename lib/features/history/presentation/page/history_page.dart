import 'package:charify/core/theme/app_colors.dart';
import 'package:charify/core/utils/date_utils.dart';
import 'package:charify/features/history/presentation/bloc/history_bloc.dart';
import 'package:charify/features/history/presentation/bloc/history_event.dart';
import 'package:charify/features/history/presentation/bloc/history_state.dart';
import 'package:charify/features/main/domain/entity/donation_entity.dart';
import 'package:charify/features/main/presentation/page/single_application_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  static const String path = '/history';
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(onScrollListener);
  }

  void onScrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<HistoryBloc>().add(LoadDonationsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(CupertinoIcons.back),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            return SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.donations?.length ?? 0,
                      itemBuilder: (context, index) {
                        final DonationEntity donation =
                            (state.donations ?? [])[index];
                        bool isSameDate = false;
                        final DateTime date = donation.date;
                        if (index == 0) {
                          isSameDate = false;
                        } else {
                          final DateTime prevDate =
                              (state.donations ?? [])[index - 1].date;
                          isSameDate = date.isSameDate(prevDate);
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isSameDate)
                              Text(
                                DateFormat('dd MMM, yyyy').format(date),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.text.withOpacity(0.7),
                                    ),
                              ),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: () {
                                context.push(
                                  SingleApplicationPage.path(
                                    donation.application?.id ?? '',
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          '${donation.application?.title}'),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      '\$${donation.amount}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
