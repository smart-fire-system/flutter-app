import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'event.dart';
import 'state.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  final AuthRepository authRepository;

  WelcomeBloc({required this.authRepository}) : super(WelcomeInitial()) {
    authRepository.authStateChanges.listen((data) {
      add(AuthChanged(error: data == "" ? null : data));
    }, onError: (error) {
      add(AuthChanged(error: error.toString()));
    });

    on<AuthChanged>((event, emit) {
      if (event.error == null) {
        if (authRepository.userAuth.authStatus == AuthStatus.notAuthenticated) {
          emit(WelcomeNotAuthenticated());
        } else {
          emit(WelcomeAuthenticated());
        }
      } else {
        emit(WelcomeNotAuthenticated());
      }
    });
  }
}
