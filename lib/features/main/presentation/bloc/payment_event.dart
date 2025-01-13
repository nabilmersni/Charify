abstract class PaymentEvent {}

class RequestPaymentSecretEvent extends PaymentEvent {
  final double amount;
  final String applicationId;

  RequestPaymentSecretEvent({
    required this.amount,
    required this.applicationId,
  });
}
