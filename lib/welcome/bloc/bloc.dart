import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import 'event.dart';
import 'state.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  final AuthRepository authRepository;

  WelcomeBloc({required this.authRepository}) : super(WelcomeInitial()) {
    on<CheckAuthenticationStatus>((event, emit) async {
      emit(WelcomeLoading());

      final isAuthenticated = await authRepository.isUserAuthenticated();
      if (isAuthenticated) {
        emit(WelcomeAuthenticated());
      } else {
        emit(WelcomeUnauthenticated());
      }
    });
  }
}
