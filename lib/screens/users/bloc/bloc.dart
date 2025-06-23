import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/branch_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/message.dart';
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
        if (authRepository.authStatus != AuthStatus.authenticated ||
            authRepository.userInfo.phoneNumber.isEmpty) {
          emit(UsersNotAuthenticated());
        } else {
          try {
            final branchesData =
                await BranchRepository().getAllBranchesAndCompanies();
            List<Branch> branches = branchesData['branches'] as List<Branch>;
            List<Company> companies =
                branchesData['companies'] as List<Company>;
            Users users =
                await userRepository.getAllUsers(branches, companies);
            emit(UsersAuthenticated(
              roleUser: authRepository.userRole,
              companies: companies,
              branches: branches,
              masterAdmins: users.masterAdmins,
              admins: users.admins,
              companyManagers: users.companyManagers,
              branchManagers: users.branchManagers,
              employees: users.employees,
              clients: users.clients,
              noRoleUsers: users.noRoleUsers,
              message: event.message,
            ));
          } catch (e) {
            emit(UsersAuthenticated(
              roleUser: authRepository.userRole,
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
        await userRepository.addUserPermissions(
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
        await userRepository.modifyUserPermissions(
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
        await userRepository.deleteUserPermissions(
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
