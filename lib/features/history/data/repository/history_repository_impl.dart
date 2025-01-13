import 'package:charify/core/model/either.dart';
import 'package:charify/core/model/failure.dart';
import 'package:charify/features/history/data/datasource/history_remote_datasource.dart';
import 'package:charify/features/history/domain/repository/history_repository.dart';
import 'package:charify/features/main/domain/entity/donation_entity.dart';
import 'package:dio/dio.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDatasource historyRemoteDatasource;

  HistoryRepositoryImpl({required this.historyRemoteDatasource});

  @override
  Future<Either<Failure, List<DonationEntity>>> getDonationsHistory(
      {int? page, int? limit}) async {
    try {
      final history = await historyRemoteDatasource.getDonationsHistory(
        limit: limit,
        page: page,
      );

      return Right(value: history);
    } on DioException catch (e) {
      return Left(
        value: HistoryFailure(
          errorMessage: e.response?.data['message'] ?? "An error occured",
        ),
      );
    }
  }
}
