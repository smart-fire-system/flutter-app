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
              masterAdmins: users.masterAdmins,
              admins: users.admins,
              companyManagers: users.companyManagers,
              branchManagers: users.branchManagers,
              employees: users.employees,
              clients: users.clients,
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
        UserRole? oldRole =
            appRepository.userRepository.getUserRole(event.userId);
        if (event.permissions.role == UserRole.masterAdmin) {
          if (oldRole == UserRole.masterAdmin) {
            message = AppMessage(id: AppMessageId.masterAdminModified);
          } else {
            message = AppMessage(id: AppMessageId.masterAdminAdded);
          }
        } else if (event.permissions.role == UserRole.admin) {
          if (oldRole == UserRole.admin) {
            message = AppMessage(id: AppMessageId.adminModified);
          } else {
            message = AppMessage(id: AppMessageId.adminAdded);
          }
        } else if (event.permissions.role == UserRole.companyManager) {
          if (oldRole == UserRole.companyManager) {
            message = AppMessage(id: AppMessageId.companyManagerModified);
          } else {
            message = AppMessage(id: AppMessageId.companyManagerAdded);
          }
        } else if (event.permissions.role == UserRole.branchManager) {
          if (oldRole == UserRole.branchManager) {
            message = AppMessage(id: AppMessageId.branchManagerModified);
          } else {
            message = AppMessage(id: AppMessageId.branchManagerAdded);
          }
        } else if (event.permissions.role == UserRole.employee) {
          if (oldRole == UserRole.employee) {
            message = AppMessage(id: AppMessageId.employeeModified);
          } else {
            message = AppMessage(id: AppMessageId.employeeAdded);
          }
        } else if (event.permissions.role == UserRole.client) {
          if (oldRole == UserRole.client) {
            message = AppMessage(id: AppMessageId.clientModified);
          } else {
            message = AppMessage(id: AppMessageId.clientAdded);
          }
        } else {
          if (oldRole == UserRole.masterAdmin) {
            message = AppMessage(id: AppMessageId.masterAdminDeleted);
          } else if (oldRole == UserRole.admin) {
            message = AppMessage(id: AppMessageId.adminDeleted);
          } else if (oldRole == UserRole.companyManager) {
            message = AppMessage(id: AppMessageId.companyManagerDeleted);
          } else if (oldRole == UserRole.branchManager) {
            message = AppMessage(id: AppMessageId.branchManagerDeleted);
          } else if (oldRole == UserRole.employee) {
            message = AppMessage(id: AppMessageId.employeeDeleted);
          } else if (oldRole == UserRole.client) {
            message = AppMessage(id: AppMessageId.clientDeleted);
          }
        }
        add(AuthChanged(message: message));
      } catch (e) {
        add(AuthChanged(error: e.toString()));
      }
    });
  }
}
