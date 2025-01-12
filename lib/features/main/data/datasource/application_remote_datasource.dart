import 'package:charify/core/utils/map_utils.dart';
import 'package:charify/features/main/domain/entity/application_entity.dart';
import 'package:dio/dio.dart';

class ApplicationRemoteDatasource {
  final Dio dio;

  ApplicationRemoteDatasource({required this.dio});

  Future<List<ApplicationEntity>> getApplications({
    int? page,
    int? limit,
    String? categoryId,
    bool? urgent,
    String? search,
  }) async {
    final request = await dio.get(
      "applications/",
      queryParameters: {
        'page': page,
        'limit': limit,
        'category': categoryId,
        'urgent': urgent,
        'search': search,
      }.withoutNulls(),
    );

    return (request.data['applications'] as List)
        .map((e) => ApplicationEntity.fromJson(e))
        .toList();
  }
}
