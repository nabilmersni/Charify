import 'package:charify/features/main/domain/repository/payment_repository.dart';
import 'package:charify/features/main/presentation/bloc/payment_event.dart';
import 'package:charify/features/main/presentation/bloc/payment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;

  PaymentBloc({
    required this.paymentRepository,
  }) : super(PaymentState.initial()) {
    on<RequestPaymentSecretEvent>(onRequestPaymentSecretEvent);
  }

  void onRequestPaymentSecretEvent(
      RequestPaymentSecretEvent event, Emitter<PaymentState> emit) async {
    emit(state.copyWith(status: PaymentStatus.loading));
    final result = await paymentRepository.requestPaymentSecret(
        amount: event.amount, applicationId: event.applicationId);

    await result.fold(
      (l) {
        emit(
          state.copyWith(
            status: PaymentStatus.error,
            errorMessage: l.errorMessage,
          ),
        );
      },
      (r) async {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: r,
            merchantDisplayName: "Charify",
          ),
        );

        try {
          await Stripe.instance.presentPaymentSheet();
          emit(
            state.copyWith(status: PaymentStatus.success),
          );
        } catch (e) {
          emit(
            state.copyWith(
              status: PaymentStatus.error,
              errorMessage: "Payment Fail",
            ),
          );
        }
      },
    );
  }
}
