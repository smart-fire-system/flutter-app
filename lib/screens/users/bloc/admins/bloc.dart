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

  AdminsBloc({required this.authRepository}) : super(AdminsInitial()) {
    on<ResetState>((event, emit) {
      emit(AdminsInitial());
    });
    on<AuthRequested>((event, emit) async {
      emit(AdminsLoading());
      await authRepository.refreshUserAuth();
      if (authRepository.userAuth.authStatus == AuthStatus.notAuthenticated) {
        emit(AdminsNotAuthenticated());
      }
      if (authRepository.userAuth.authStatus ==
              AuthStatus.authenticatedNotVerified ||
          authRepository.userAuth.user?.role == null ||
          authRepository.userAuth.user?.role != UserRole.admin) {
        emit(AdminsNotAuthorized());
      } else {
        UserRepository userRepository =
            UserRepository(authRepository: authRepository);
        try {
          List<Admin> admins = await userRepository.getAdminsList();
          emit(AdminsAuthenticated(user: authRepository.userAuth, admins: admins));
        } catch (e) {
          emit(AdminsError(error: e.toString()));
        }
      }
    });

    on<ModifyRequested>((event, emit) async {
      emit(AdminsLoading());
      try {
        UserRepository userRepository =
            UserRepository(authRepository: authRepository);
        await userRepository.changeAccessRole(event.id, event.newRole);
        emit(AdminModifed());
      } catch (e) {
        emit(AdminModifed(error: e.toString()));
      }
    });
    on<DeleteRequested>((event, emit) async {
      emit(AdminsLoading());
      try {
        UserRepository userRepository =
            UserRepository(authRepository: authRepository);
        await userRepository.deleteUser(event.id);
        emit(AdminDeleted());
      } catch (e) {
        emit(AdminDeleted(error: e.toString()));
      }
    });
    on<NoRoleListRequested>((event, emit) async {
      emit(AdminsLoading());
      try {
        List<User> users = [];
        UserRepository userRepository =
            UserRepository(authRepository: authRepository);
        users = await userRepository.getNoRoleList();
        emit(NoRoleListLoaded(users: users));
      } catch (e) {
        emit(AdminDeleted(error: e.toString()));
      }
    });
  }
}
