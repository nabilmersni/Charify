import 'package:charify/core/model/either.dart';
import 'package:charify/core/model/failure.dart';

abstract class PaymentRepository {
  Future<Either<Failure, String>> requestPaymentSecret({
    required double amount,
    required String applicationId,
  });
}
