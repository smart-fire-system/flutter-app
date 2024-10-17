import 'package:fire_alarm_system/models/admin.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/repositories/user_repository.dart';
import 'event.dart';
import 'state.dart';

class AdminsBloc extends Bloc<AdminsEvent, AdminsState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  AdminsBloc({required this.authRepository})
      : userRepository = UserRepository(authRepository: authRepository),
        super(AdminsInitial()) {
    authRepository.authStateChanges.listen((data) {
      add(AuthChanged(error: data == "" ? null : data));
    }, onError: (error) {
      add(AuthChanged(error: error.toString()));
    });

    on<AuthChanged>((event, emit) async {
      if (event.error == null) {
        emit(AdminsLoading());
        if (authRepository.userAuth.authStatus != AuthStatus.authenticated ||
            authRepository.userAuth.user!.phoneNumber.isEmpty ||
            authRepository.userAuth.user!.role != UserRole.admin) {
          emit(AdminsNotAuthenticated());
        } else {
          try {
            List<Admin> admins = await userRepository.getAdminsList();
            List<User> users = await userRepository.getNoRoleList();
            emit(AdminsAuthenticated(
              user: authRepository.userAuth.user!,
              admins: admins,
              users: users,
              message: event.message,
            ));
          } catch (e) {
            emit(AdminsAuthenticated(
              user: authRepository.userAuth.user!,
              admins: [],
              users: [],
              error: e.toString(),
            ));
          }
        }
      } else {
        emit(AdminsNotAuthenticated(error: event.error));
      }
    });

    on<ModifyRequested>((event, emit) async {
      emit(AdminsLoading());
      try {
        await userRepository.changeAccessRole(
            event.id, event.oldRole, event.newRole);
        add(AuthChanged(message: AdminMessage.userModified));
      } catch (e) {
        add(AuthChanged(error: e.toString()));
      }
    });
  }
}
