import 'package:charify/core/model/either.dart';
import 'package:charify/core/model/failure.dart';
import 'package:charify/features/main/data/datasource/application_remote_datasource.dart';
import 'package:charify/features/main/domain/entity/application_entity.dart';
import 'package:charify/features/main/domain/repository/application_repository.dart';
import 'package:dio/dio.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  final ApplicationRemoteDatasource applicationRemoteDatasource;

  ApplicationRepositoryImpl({required this.applicationRemoteDatasource});

  @override
  Future<Either<Failure, List<ApplicationEntity>>> getApplications({
    int? page,
    int? limit,
    String? categoryId,
    bool? urgent,
    String? search,
  }) async {
    try {
      final applications = await applicationRemoteDatasource.getApplications(
        page: page,
        limit: limit,
        categoryId: categoryId,
        urgent: urgent,
        search: search,
      );
      return Right(value: applications);
    } on DioException catch (e) {
      return Left(
        value: ApplicationFailure(
          errorMessage: e.response?.data['message'] ?? "An error occured",
        ),
      );
    }
  }
}
