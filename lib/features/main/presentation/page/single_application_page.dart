import 'package:cached_network_image/cached_network_image.dart';
import 'package:charify/core/di/get_it.dart';
import 'package:charify/core/theme/app_colors.dart';
import 'package:charify/core/ui/widgets/default_button.dart';
import 'package:charify/core/utils/date_utils.dart';
import 'package:charify/core/utils/int_utils.dart';
import 'package:charify/core/utils/url_utils.dart';
import 'package:charify/features/main/presentation/bloc/single_application_bloc.dart';
import 'package:charify/features/main/presentation/bloc/single_application_event.dart';
import 'package:charify/features/main/presentation/bloc/single_application_state.dart';
import 'package:charify/features/main/presentation/page/payment_page.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SingleApplicationPage extends StatefulWidget {
  static String path(String id) => '/application/$id';
  final String applicationId;
  const SingleApplicationPage({
    super.key,
    required this.applicationId,
  });

  @override
  State<SingleApplicationPage> createState() => _SingleApplicationPageState();
}

class _SingleApplicationPageState extends State<SingleApplicationPage> {
  int currentImageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SingleApplicationBloc>()
        ..add(GetSingleApplicationEvent(applicationId: widget.applicationId)),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<SingleApplicationBloc, SingleApplicationState>(
            builder: (context, state) {
              if (state.status == SingleApplicationStatus.success) {
                final application = state.applicationEntity;
                return SizedBox.expand(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Positioned.fill(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    height: 300,
                                    child: PageView(
                                      children: application?.images
                                              .map(
                                                (e) => CachedNetworkImage(
                                                  imageUrl:
                                                      UrlUtils.buildImageURL(e),
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                              .toList() ??
                                          [],
                                      onPageChanged: (value) {
                                        setState(() {
                                          currentImageIndex = value;
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: IconButton(
                                      onPressed: () {
                                        context.pop();
                                      },
                                      icon: const Icon(CupertinoIcons.back),
                                      color: AppColors.text,
                                      style: IconButton.styleFrom(
                                          backgroundColor: AppColors.surface),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 5),
                              if ((application?.images.length ?? 0) > 1)
                                DotsIndicator(
                                  dotsCount: application?.images.length ?? 1,
                                  position: currentImageIndex,
                                ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${application?.title}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                        ),
                                        Text(
                                          '${application?.donorCount}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.text
                                                    .withOpacity(0.7),
                                              ),
                                        ),
                                        const SizedBox(width: 5),
                                        Icon(
                                          CupertinoIcons.person_2_fill,
                                          color:
                                              AppColors.text.withOpacity(0.7),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${application?.description}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color:
                                                AppColors.text.withOpacity(0.8),
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    LinearProgressIndicator(
                                      color: AppColors.primary,
                                      backgroundColor: AppColors.onSurface,
                                      borderRadius: BorderRadius.circular(20),
                                      value:
                                          (application?.collectedPercentage ??
                                                  0) /
                                              100,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${application?.collectedAmount?.formatNumber()}\$',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.text
                                                    .withOpacity(0.7),
                                              ),
                                        ),
                                        Text(
                                          '${application?.amount.formatNumber()}\$',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.text
                                                    .withOpacity(0.7),
                                              ),
                                        ),
                                      ],
                                    ),
                                    if (application?.userDonations.isNotEmpty ??
                                        false)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 12),
                                          Text(
                                            "My Donations",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall,
                                          ),
                                          const SizedBox(height: 8),
                                          ListView.separated(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: application
                                                    ?.userDonations.length ??
                                                0,
                                            separatorBuilder:
                                                (BuildContext context,
                                                        int index) =>
                                                    const SizedBox(height: 12),
                                            itemBuilder: (context, index) {
                                              final donation = application
                                                  ?.userDonations[index];

                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    DateFormat('dd MMM, yyy')
                                                        .format(
                                                      donation?.date ??
                                                          DateTime.now(),
                                                    ),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color: AppColors.text
                                                              .withOpacity(0.8),
                                                        ),
                                                  ),
                                                  Text(
                                                      '\$${donation?.amount.toStringAsFixed(2)}'),
                                                ],
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 120),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${application?.deadline.timeLeft()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.text.withOpacity(0.8),
                                  ),
                            ),
                            const SizedBox(height: 12),
                            DefaultButton(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              onPressed: () {
                                context
                                    .push(
                                  PaymentPage.path(widget.applicationId),
                                )
                                    .then(
                                  (v) {
                                    // ignore: use_build_context_synchronously
                                    context.read<SingleApplicationBloc>().add(
                                          GetSingleApplicationEvent(
                                            applicationId: widget.applicationId,
                                          ),
                                        );
                                  },
                                );
                              },
                              text: "Donate",
                              // textColor: AppColors.text,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            },
          ),
        ),
      ),
    );
  }
}
