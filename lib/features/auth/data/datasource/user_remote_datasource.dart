import 'package:charify/features/auth/domain/entity/user_entity.dart';
import 'package:dio/dio.dart';

class UserRemoteDatasource {
  final Dio dio;

  UserRemoteDatasource({required this.dio});

  Future<UserEntity> getUser() async {
    final request = await dio.get("auth/me");

    return UserEntity.fromJson(request.data);
  }
}
