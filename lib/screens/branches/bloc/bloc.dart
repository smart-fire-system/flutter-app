import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/repositories/user_repository.dart';
import 'package:fire_alarm_system/repositories/branch_repository.dart';
import 'event.dart';
import 'state.dart';

class BranchesBloc extends Bloc<BranchesEvent, BranchesState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final BranchRepository branchRepository;
  String? createdId;

  BranchesBloc({required this.authRepository})
      : userRepository = UserRepository(authRepository: authRepository),
        branchRepository = BranchRepository(),
        createdId = null,
        super(BranchesInitial()) {
    authRepository.authStateChanges.listen((data) {
      add(AuthChanged(error: data == "" ? null : data));
    }, onError: (error) {
      add(AuthChanged(error: error.toString()));
    });

    on<AuthChanged>((event, emit) async {
      UserInfo userInfo = authRepository.userRole.info as UserInfo;
      if (authRepository.authStatus != AuthStatus.authenticated ||
          userInfo.phoneNumber.isEmpty ||
          authRepository.userRole is NoRoleUser) {
        emit(BranchesNotAuthenticated(error: event.error));
        return;
      }
      emit(BranchesLoading());
      try {
        dynamic user = authRepository.userRole;
        List<Branch> branches = [];
        List<Company> companies = [];
        if (user is MasterAdmin || user is Admin) {
          final data = await branchRepository.getAllBranchedAndCompanies();
          branches = data['branches'] as List<Branch>;
          companies = data['companies'] as List<Company>;
        } else if (user is CompanyManager) {
          branches = List.from(user.branches);
          companies = [user.company];
        } else {
          branches = [user.branch];
          companies = [user.company];
        }
        emit(BranchesAuthenticated(
          user: authRepository.userRole,
          branches: branches,
          companies: companies,
          createdId: createdId,
          message: event.message,
          error: event.error,
        ));
      } catch (e) {
        emit(BranchesAuthenticated(
          user: authRepository.userRole,
          error: event.error ?? e.toString(),
        ));
      }
    });

    on<BranchModifyRequested>((event, emit) async {
      emit(BranchesLoading());
      try {
        await branchRepository.modifyBranch(event.branch);
        add(AuthChanged(message: BranchesMessage.branchModified));
      } catch (e) {
        add(AuthChanged(error: e.toString()));
      }
    });

    on<BranchAddRequested>((event, emit) async {
      emit(BranchesLoading());
      try {
        createdId = await branchRepository.addBranch(event.branch);
        add(AuthChanged(message: BranchesMessage.branchAdded));
      } catch (e) {
        add(AuthChanged(error: e.toString()));
      }
    });

    on<BranchDeleteRequested>((event, emit) async {
      emit(BranchesLoading());
      try {
        await branchRepository.deleteBranch(event.id);
        add(AuthChanged(message: BranchesMessage.branchDeleted));
      } catch (e) {
        add(AuthChanged(error: e.toString()));
      }
    });

    on<CompanyModifyRequested>((event, emit) async {
      emit(BranchesLoading());
      try {
        await branchRepository.modifyCompany(event.company, event.logoFile);
        add(AuthChanged(message: BranchesMessage.companyModified));
      } catch (e) {
        add(AuthChanged(error: e.toString()));
      }
    });

    on<CompanyAddRequested>((event, emit) async {
      emit(BranchesLoading());
      try {
        createdId = await branchRepository.addCompany(
          event.company,
          event.logoFile,
        );
        add(AuthChanged(message: BranchesMessage.companyAdded));
      } catch (e) {
        add(AuthChanged(error: e.toString()));
      }
    });

    on<CompanyDeleteRequested>((event, emit) async {
      emit(BranchesLoading());
      try {
        await branchRepository.deleteCompany(event.id, event.branches);
        add(AuthChanged(message: BranchesMessage.companyDeleted));
      } catch (e) {
        add(AuthChanged(error: e.toString()));
      }
    });
  }
}
