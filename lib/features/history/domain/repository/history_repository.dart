import 'package:charify/core/model/either.dart';
import 'package:charify/core/model/failure.dart';
import 'package:charify/features/main/domain/entity/donation_entity.dart';

abstract class HistoryRepository {
  Future<Either<Failure, List<DonationEntity>>> getDonationsHistory({
    int? page,
    int? limit,
  });
}
