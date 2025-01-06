import 'package:charify/core/model/either.dart';
import 'package:charify/core/model/failure.dart';
import 'package:charify/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:charify/features/auth/domain/entity/user_entity.dart';
import 'package:charify/features/auth/domain/repository/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;
  final GoogleSignIn googleSignIn;

  AuthRepositoryImpl({
    required this.authRemoteDatasource,
    required this.googleSignIn,
  });

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final firebaseCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final token = await firebaseCredential.user?.getIdToken();

      if (token != null) {
        return Right(value: await authRemoteDatasource.signInWithGoogle(token));
      } else {
        return Left(value: AuthFailure(errorMessage: "Auth failure"));
      }
    } on DioException catch (e) {
      return Left(
          value: AuthFailure(errorMessage: e.response?.data['message']));
    }
  }
}
