import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final AppRepository appRepository;

  UsersBloc({required this.appRepository}) : super(UsersInitial()) {
    appRepository.authStateStream.listen((data) {
      add(AuthChanged(error: data));
    }, onError: (error) {
      add(AuthChanged(error: error.toString()));
    });

    appRepository.usersStream.listen((data) {
      add(AuthChanged());
    }, onError: (error) {
      add(AuthChanged(error: error.toString()));
    });

    on<AuthChanged>((event, emit) async {
      if (event.error == null) {
        emit(UsersLoading());
        if (appRepository.authStatus != AuthStatus.authenticated ||
            appRepository.userInfo.phoneNumber.isEmpty) {
          emit(UsersNotAuthenticated());
        } else {
          try {
            final users = appRepository.users;
            final permissions = appRepository.userRole.permissions;
            emit(UsersAuthenticated(
              roleUser: appRepository.userRole,
              companies: appRepository.companies,
              branches: appRepository.branches,
              masterAdmins: appRepository.userRole is MasterAdmin
                  ? users.masterAdmins
                  : [],
              admins: permissions.canViewAdmins ? users.admins : [],
              companyManagers: permissions.canViewCompanyManagers
                  ? users.companyManagers
                  : [],
              branchManagers:
                  permissions.canViewBranchManagers ? users.branchManagers : [],
              employees: permissions.canViewEmployees ? users.employees : [],
              clients: permissions.canViewClients ? users.clients : [],
              noRoleUsers: appRepository.userRole is MasterAdmin ||
                      permissions.canUpdateAdmins ||
                      permissions.canUpdateCompanyManagers ||
                      permissions.canUpdateBranchManagers ||
                      permissions.canUpdateEmployees ||
                      permissions.canUpdateClients
                  ? users.noRoleUsers
                  : [],
              message: event.message,
            ));
          } catch (e) {
            emit(UsersAuthenticated(
              roleUser: appRepository.userRole,
              error: e.toString(),
            ));
          }
        }
      } else {
        emit(UsersNotAuthenticated(error: event.error));
      }
    });

    on<AddRequested>((event, emit) async {
      emit(UsersLoading());
      try {
        await appRepository.userRepository.addUserPermissions(
          userId: event.userId,
          permissions: event.permissions,
          companyId: event.companyId,
          branchId: event.branchId,
        );
        AppMessage? message;
        if (event.permissions.role == UserRole.admin) {
          message = AppMessage.adminAdded;
        } else if (event.permissions.role == UserRole.companyManager) {
          message = AppMessage.companyManagerAdded;
        } else if (event.permissions.role == UserRole.branchManager) {
          message = AppMessage.branchManagerAdded;
        } else if (event.permissions.role == UserRole.employee) {
          message = AppMessage.employeeAdded;
        } else if (event.permissions.role == UserRole.client) {
          message = AppMessage.clientAdded;
        }
        add(AuthChanged(message: message));
      } catch (e) {
        add(AuthChanged(error: e.toString()));
      }
    });

    on<ModifyRequested>((event, emit) async {
      emit(UsersLoading());
      try {
        await appRepository.userRepository.modifyUserPermissions(
          userId: event.userId,
          permissions: event.permissions,
          companyId: event.companyId,
          branchId: event.branchId,
        );
        AppMessage? message;
        if (event.permissions.role == UserRole.admin) {
          message = AppMessage.adminModified;
        } else if (event.permissions.role == UserRole.companyManager) {
          message = AppMessage.companyManagerModified;
        } else if (event.permissions.role == UserRole.branchManager) {
          message = AppMessage.branchManagerModified;
        } else if (event.permissions.role == UserRole.employee) {
          message = AppMessage.employeeModified;
        } else if (event.permissions.role == UserRole.client) {
          message = AppMessage.clientModified;
        }
        add(AuthChanged(message: message));
      } catch (e) {
        add(AuthChanged(error: e.toString()));
      }
    });

    on<DeleteRequested>((event, emit) async {
      emit(UsersLoading());
      try {
        await appRepository.userRepository.deleteUserPermissions(
          userId: event.userId,
          userRole: event.userRole,
        );
        AppMessage? message;
        if (event.userRole == UserRole.admin) {
          message = AppMessage.adminDeleted;
        } else if (event.userRole == UserRole.companyManager) {
          message = AppMessage.companyManagerDeleted;
        } else if (event.userRole == UserRole.branchManager) {
          message = AppMessage.branchManagerDeleted;
        } else if (event.userRole == UserRole.employee) {
          message = AppMessage.employeeDeleted;
        } else if (event.userRole == UserRole.client) {
          message = AppMessage.clientDeleted;
        }
        add(AuthChanged(message: message));
      } catch (e) {
        add(AuthChanged(error: e.toString()));
      }
    });
  }
}
