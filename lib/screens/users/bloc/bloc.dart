import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final AppRepository appRepository;
  AppMessage? message;

  UsersBloc({required this.appRepository}) : super(UsersInitial()) {
    on<Refresh>((event, emit) async {
      if (event.error == null && appRepository.isUserReady()) {
        emit(UsersLoading());
        emit(UsersAuthenticated(
          roleUser: appRepository.userRole,
          companies: appRepository.companies,
          branches: appRepository.branches,
          masterAdmins: appRepository.masterAdmins,
          admins: appRepository.admins,
          companyManagers: appRepository.companyManagers,
          branchManagers: appRepository.branchManagers,
          employees: appRepository.employees,
          clients: appRepository.clients,
          noRoleUsers: appRepository.userRole is MasterAdmin ||
                  appRepository.permissions.canUpdateAdmins ||
                  appRepository.permissions.canUpdateCompanyManagers ||
                  appRepository.permissions.canUpdateBranchManagers ||
                  appRepository.permissions.canUpdateEmployees ||
                  appRepository.permissions.canUpdateClients
              ? appRepository.noRoleUsers
              : [],
          message: message,
        ));
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
      } catch (e) {
        add(Refresh(error: e.toString()));
      }
    });

    add(Refresh());

    appRepository.authStateStream.listen((data) {
      add(Refresh());
    }, onError: (error) {
      add(Refresh(error: error.toString()));
    });

    appRepository.branchesAndCompaniesStream.listen((_) {
      add(Refresh());
    }, onError: (error) {
      add(Refresh(error: error.toString()));
    });

    appRepository.usersStream.listen((_) {
      add(Refresh());
    }, onError: (error) {
      add(Refresh(error: error.toString()));
    });
  }
}
