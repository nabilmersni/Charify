import 'package:charify/core/api/api_client.dart';
import 'package:charify/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:charify/features/auth/data/datasource/user_remote_datasource.dart';
import 'package:charify/features/auth/data/repository/auth_repository_impl.dart';
import 'package:charify/features/auth/data/repository/user_repository_impl.dart';
import 'package:charify/features/auth/domain/repository/auth_repository.dart';
import 'package:charify/features/auth/domain/repository/user_repository.dart';
import 'package:charify/features/auth/presentation/bloc/user_bloc.dart';
import 'package:charify/features/main/data/datasource/application_remote_datasource.dart';
import 'package:charify/features/main/data/datasource/category_remote_datasource.dart';
import 'package:charify/features/main/data/repository/application_repository_impl.dart';
import 'package:charify/features/main/data/repository/category_repository_impl.dart';
import 'package:charify/features/main/domain/repository/application_repository.dart';
import 'package:charify/features/main/domain/repository/category_repository.dart';
import 'package:charify/features/main/presentation/bloc/main_bloc.dart';
import 'package:charify/features/main/presentation/bloc/single_application_bloc.dart';
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

  getIt.registerSingleton(CategoryRemoteDatasource(dio: dioTokenInterceptor));
  getIt
      .registerSingleton(ApplicationRemoteDatasource(dio: dioTokenInterceptor));
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

  getIt.registerSingleton<CategoryRepository>(
    CategoryRepositoryImpl(categoryRemoteDatasource: getIt()),
  );

  getIt.registerSingleton<ApplicationRepository>(
    ApplicationRepositoryImpl(applicationRemoteDatasource: getIt()),
  );
}

void registerBloc() {
  getIt.registerFactory(
    () => UserBloc(
      authRepository: getIt(),
      userRepository: getIt(),
    ),
  );

  getIt.registerFactory(
    () => MainBloc(
      applicationRepository: getIt(),
      categoryRepository: getIt(),
    ),
  );

  getIt.registerFactory(
    () => SingleApplicationBloc(applicationRepository: getIt()),
  );
}
