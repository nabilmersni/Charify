import 'package:charify/features/auth/domain/repository/auth_repository.dart';
import 'package:charify/features/auth/presentation/bloc/user_event.dart';
import 'package:charify/features/auth/presentation/bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AuthRepository authRepository;

  UserBloc({required this.authRepository}) : super(UserState.initial()) {
    on<SignInWithGoogleEvent>(onSignInWithGoogleEvent);
  }

  void onSignInWithGoogleEvent(
    SignInWithGoogleEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.loading));
    final result = await authRepository.signInWithGoogle();
    result.fold(
      (l) => emit(
        state.copyWith(
          status: UserStatus.error,
          errorMessage: l.errorMessage,
        ),
      ),
      (r) => emit(state.copyWith(status: UserStatus.success, userEntity: r)),
    );
  }
}
