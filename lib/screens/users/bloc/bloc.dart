import 'package:fire_alarm_system/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/repositories/user_repository.dart';
import 'event.dart';
import 'state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  UsersBloc({required this.authRepository})
      : userRepository = UserRepository(authRepository: authRepository),
        super(UsersInitial()) {
    authRepository.authStateChanges.listen((data) {
      add(AuthChanged(error: data == "" ? null : data));
    }, onError: (error) {
      add(AuthChanged(error: error.toString()));
    });

    on<AuthChanged>((event, emit) async {
      if (event.error == null) {
        emit(UsersLoading());
        if (authRepository.userAuth.authStatus != AuthStatus.authenticated ||
            authRepository.userAuth.user!.phoneNumber.isEmpty) {
          emit(UsersNotAuthenticated());
        } else {
          try {
            UsersAndBranches usersAndBranches =
                await userRepository.getUsersAndBranches();
            emit(UsersAuthenticated(
              user: authRepository.userAuth.user!,
              companies: usersAndBranches.companies,
              branches: usersAndBranches.branches,
              admins: usersAndBranches.admins,
              companyManagers: usersAndBranches.companyManagers,
              branchManagers: usersAndBranches.branchManagers,
              employees: usersAndBranches.employees,
              clients: usersAndBranches.clients,
              noRoleUsers: usersAndBranches.noRoleUsers,
              message: event.message,
            ));
          } catch (e) {
            emit(UsersAuthenticated(
              user: authRepository.userAuth.user!,
              error: e.toString(),
            ));
          }
        }
      } else {
        emit(UsersNotAuthenticated(error: event.error));
      }
    });

    on<ModifyRequested>((event, emit) async {
      emit(UsersLoading());
      try {
        await userRepository.changeAccessRole(
            event.id, event.oldRole, event.newRole);
        add(AuthChanged(message: UsersMessage.userModified));
      } catch (e) {
        add(AuthChanged(error: e.toString()));
      }
    });
  }
}
