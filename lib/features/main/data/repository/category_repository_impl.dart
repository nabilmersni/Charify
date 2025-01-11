import 'package:charify/core/model/either.dart';
import 'package:charify/core/model/failure.dart';
import 'package:charify/features/main/data/datasource/category_remote_datasource.dart';
import 'package:charify/features/main/domain/entity/category_entity.dart';
import 'package:charify/features/main/domain/repository/category_repository.dart';
import 'package:dio/dio.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDatasource categoryRemoteDatasource;

  CategoryRepositoryImpl({required this.categoryRemoteDatasource});

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await categoryRemoteDatasource.getCategories();
      return Right(value: categories);
    } on DioException catch (e) {
      return Left(
        value: CategoryFailure(
          errorMessage: e.response?.data['message'] ?? "Error occured",
        ),
      );
    }
  }
}
