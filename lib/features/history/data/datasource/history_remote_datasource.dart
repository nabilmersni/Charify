import 'package:charify/features/main/domain/entity/donation_entity.dart';
import 'package:dio/dio.dart';

class HistoryRemoteDatasource {
  final Dio dio;

  HistoryRemoteDatasource({required this.dio});

  Future<List<DonationEntity>> getDonationsHistory({
    int? page,
    int? limit,
  }) async {
    final result = await dio.get('donations/');

    return (result.data['donations'] as List)
        .map(
          (e) => DonationEntity.fromJson(e),
        )
        .toList();
  }
}
