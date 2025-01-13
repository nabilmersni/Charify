import 'package:charify/core/api/api_client.dart';
import 'package:charify/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:charify/features/auth/data/datasource/user_remote_datasource.dart';
import 'package:charify/features/auth/data/repository/auth_repository_impl.dart';
import 'package:charify/features/auth/data/repository/user_repository_impl.dart';
import 'package:charify/features/auth/domain/repository/auth_repository.dart';
import 'package:charify/features/auth/domain/repository/user_repository.dart';
import 'package:charify/features/auth/presentation/bloc/user_bloc.dart';
import 'package:charify/features/history/data/datasource/history_remote_datasource.dart';
import 'package:charify/features/history/data/repository/history_repository_impl.dart';
import 'package:charify/features/history/domain/repository/history_repository.dart';
import 'package:charify/features/history/presentation/bloc/history_bloc.dart';
import 'package:charify/features/main/data/datasource/application_remote_datasource.dart';
import 'package:charify/features/main/data/datasource/category_remote_datasource.dart';
import 'package:charify/features/main/data/datasource/payment_remote_datasource.dart';
import 'package:charify/features/main/data/repository/application_repository_impl.dart';
import 'package:charify/features/main/data/repository/category_repository_impl.dart';
import 'package:charify/features/main/data/repository/payment_repository_impl.dart';
import 'package:charify/features/main/domain/repository/application_repository.dart';
import 'package:charify/features/main/domain/repository/category_repository.dart';
import 'package:charify/features/main/domain/repository/payment_repository.dart';
import 'package:charify/features/main/presentation/bloc/main_bloc.dart';
import 'package:charify/features/main/presentation/bloc/payment_bloc.dart';
import 'package:charify/features/main/presentation/bloc/single_application_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

var getIt = GetIt.instance;

void setup() {
  initStripe();
  registerGoogleSignIn();
  registerApiClient();
  registerDataSources();
  registerRepositories();
  registerBloc();
}

void initStripe() {
  Stripe.publishableKey =
      "pk_test_51PwkQYByUCYEdTTeHgaaK94Mg2sVX5ojR6b2SvbnXuTzsgGco1kHN6Cti1hHSXwPwsm3okECqmJVTd6fhI4X1RMF00ohFnDL4z";
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

  getIt.registerSingleton(PaymentRemoteDatasource(dio: dioTokenInterceptor));
  getIt.registerSingleton(HistoryRemoteDatasource(dio: dioTokenInterceptor));
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

  getIt.registerSingleton<PaymentRepository>(
    PaymentRepositoryImpl(paymentRemoteDatasource: getIt()),
  );

  getIt.registerSingleton<HistoryRepository>(
    HistoryRepositoryImpl(historyRemoteDatasource: getIt()),
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

  getIt.registerFactory(
    () => PaymentBloc(paymentRepository: getIt()),
  );

  getIt.registerFactory(
    () => HistoryBloc(historyRepository: getIt()),
  );
}
