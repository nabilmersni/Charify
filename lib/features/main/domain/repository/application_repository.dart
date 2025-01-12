import 'package:charify/core/model/either.dart';
import 'package:charify/core/model/failure.dart';
import 'package:charify/features/main/domain/entity/application_entity.dart';

abstract class ApplicationRepository {
  Future<Either<Failure, List<ApplicationEntity>>> getApplications({
    int? page,
    int? limit,
    String? categoryId,
    bool? urgent,
    String? search,
  });

  Future<Either<Failure, ApplicationEntity>> getApplicationById(
      String applicationId);
}
