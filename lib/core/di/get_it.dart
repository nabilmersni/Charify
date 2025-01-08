import 'package:charify/core/api/api_client.dart';
import 'package:charify/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:charify/features/auth/data/datasource/user_remote_datasource.dart';
import 'package:charify/features/auth/data/repository/auth_repository_impl.dart';
import 'package:charify/features/auth/data/repository/user_repository_impl.dart';
import 'package:charify/features/auth/domain/repository/auth_repository.dart';
import 'package:charify/features/auth/domain/repository/user_repository.dart';
import 'package:charify/features/auth/presentation/bloc/user_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

var getIt = GetIt.instance;

void setup() {
  registerGoogleSignIn();
  registerApiClient();
  registerDataSources();
  registerRepositories();
  registerBloc();
}

void registerGoogleSignIn() {
  getIt.registerSingleton(GoogleSignIn());
}

void registerApiClient() {
  getIt.registerSingleton(ApiClient());
}

void registerDataSources() {
  final dio = getIt<ApiClient>().getDio();
  final dioTokenInterceptor = getIt<ApiClient>().getDio(tokenInterceptor: true);
  getIt.registerSingleton(AuthRemoteDatasource(dio: dio));
  getIt.registerSingleton(UserRemoteDatasource(dio: dioTokenInterceptor));
}

void registerRepositories() {
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      authRemoteDatasource: getIt(),
      googleSignIn: getIt(),
    ),
  );

  getIt.registerSingleton<UserRepository>(
      UserRepositoryImpl(userRemoteDatasource: getIt()));
}

void registerBloc() {
  getIt.registerFactory(
    () => UserBloc(
      authRepository: getIt(),
      userRepository: getIt(),
    ),
  );
}
