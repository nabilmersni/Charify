import 'package:charify/core/model/either.dart';
import 'package:charify/core/model/failure.dart';
import 'package:charify/features/main/data/datasource/payment_remote_datasource.dart';
import 'package:charify/features/main/domain/repository/payment_repository.dart';
import 'package:dio/dio.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDatasource paymentRemoteDatasource;

  PaymentRepositoryImpl({required this.paymentRemoteDatasource});

  @override
  Future<Either<Failure, String>> requestPaymentSecret({
    required double amount,
    required String applicationId,
  }) async {
    try {
      final paymentSecret = await paymentRemoteDatasource.requestPaymentSecret(
        amount: amount,
        applicationId: applicationId,
      );
      return Right(value: paymentSecret);
    } on DioException catch (e) {
      return Left(
        value: PaymentFailure(
          errorMessage: e.response?.data['message'] ?? "An error occured",
        ),
      );
    }
  }
}
