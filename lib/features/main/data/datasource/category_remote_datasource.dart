import 'package:charify/features/main/domain/entity/category_entity.dart';
import 'package:dio/dio.dart';

class CategoryRemoteDatasource {
  final Dio dio;

  CategoryRemoteDatasource({required this.dio});

  Future<List<CategoryEntity>> getCategories() async {
    final request = await dio.get("categories/");

    return (request.data as List)
        .map((e) => CategoryEntity.fromJson(e))
        .toList();
  }
}
