import 'package:charify/core/di/get_it.dart';
import 'package:charify/core/ui/widgets/default_button.dart';
import 'package:charify/core/ui/widgets/default_text_field.dart';
import 'package:charify/features/auth/presentation/bloc/user_bloc.dart';
import 'package:charify/features/auth/presentation/bloc/user_event.dart';
import 'package:charify/features/history/presentation/bloc/history_bloc.dart';
import 'package:charify/features/history/presentation/bloc/history_event.dart';
import 'package:charify/features/main/presentation/bloc/main_bloc.dart';
import 'package:charify/features/main/presentation/bloc/main_event.dart';
import 'package:charify/features/main/presentation/bloc/payment_bloc.dart';
import 'package:charify/features/main/presentation/bloc/payment_event.dart';
import 'package:charify/features/main/presentation/bloc/payment_state.dart';
import 'package:charify/features/main/presentation/bloc/single_application_bloc.dart';
import 'package:charify/features/main/presentation/bloc/single_application_event.dart';
import 'package:charify/features/main/presentation/bloc/single_application_state.dart';
import 'package:charify/features/main/presentation/widget/thank_you_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PaymentPage extends StatefulWidget {
  static String path(String applicationId) => "/payment/$applicationId";
  final String applicationId;
  const PaymentPage({super.key, required this.applicationId});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  double donationAmount = 10;
  double get commission => donationAmount * 0.05;

  double get totalAmount => donationAmount + commission;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SingleApplicationBloc>()
        ..add(GetSingleApplicationEvent(applicationId: widget.applicationId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Donate',
            style: Theme.of(context).textTheme.headlineSmall,
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
          child: BlocListener<PaymentBloc, PaymentState>(
            listener: (context, state) {
              if (state.status == PaymentStatus.success) {
                context.read<UserBloc>().add(GetUserEvent());
                context.read<HistoryBloc>().add(
                      LoadDonationsEvent(refresh: true),
                    );
                context
                    .read<MainBloc>()
                    .add(LoadApplicationsEvent(refresh: true));
                context.pop();
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const ThankYouBottomSheet(),
                );
              }
            },
            child: BlocBuilder<SingleApplicationBloc, SingleApplicationState>(
              builder: (context, state) {
                final application = state.applicationEntity;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Support ${application?.title}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Enter your donation amount',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      DefaultTextField(
                        onChange: (value) {
                          setState(() {
                            donationAmount = double.tryParse(value) ?? 0;
                          });
                        },
                        initialValue: donationAmount.toString(),
                        hintText: "Donation amount",
                        prefixText: '\$ ',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Donation: ',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '\$${donationAmount.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Comission (5%): ',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '\$${commission.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const Divider(
                        height: 30,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total: ',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '\$${totalAmount.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const Spacer(),
                      DefaultButton(
                        onPressed: () {
                          if (donationAmount > 0) {
                            context.read<PaymentBloc>().add(
                                  RequestPaymentSecretEvent(
                                    amount: donationAmount,
                                    applicationId: widget.applicationId,
                                  ),
                                );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please enter a valid amount"),
                              ),
                            );
                          }
                        },
                        text: "Donate ${totalAmount.toStringAsFixed(2)}\$",
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
