import 'package:charify/core/model/either.dart';
import 'package:charify/core/model/failure.dart';
import 'package:charify/features/auth/data/datasource/user_remote_datasource.dart';
import 'package:charify/features/auth/domain/entity/user_entity.dart';
import 'package:charify/features/auth/domain/repository/user_repository.dart';
import 'package:dio/dio.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource userRemoteDatasource;

  UserRepositoryImpl({required this.userRemoteDatasource});

  @override
  Future<Either<Failure, UserEntity>> getUser() async {
    try {
      final user = await userRemoteDatasource.getUser();

      return Right(value: user);
    } on DioException catch (e) {
      return Left(
        value: AuthFailure(
            errorMessage:
                e.response?.data['message'] ?? 'Unexpected error occurred'),
      );
    }
  }
}
