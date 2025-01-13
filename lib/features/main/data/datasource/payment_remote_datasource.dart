import 'package:dio/dio.dart';

class PaymentRemoteDatasource {
  final Dio dio;

  PaymentRemoteDatasource({required this.dio});

  Future<String> requestPaymentSecret({
    required double amount,
    required String applicationId,
  }) async {
    final request = await dio.post(
      'payments/create-payment-intent',
      data: {
        'amount': amount,
        'applicationId': applicationId,
      },
    );

    return request.data['clientSecret'];
  }
}
