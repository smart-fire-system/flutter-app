import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
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

  BranchesBloc({required this.authRepository})
      : userRepository = UserRepository(authRepository: authRepository),
        branchRepository = BranchRepository(),
        super(BranchesInitial()) {
    authRepository.authStateChanges.listen((data) {
      add(AuthChanged(error: data == "" ? null : data));
    }, onError: (error) {
      add(AuthChanged(error: error.toString()));
    });

    on<AuthChanged>((event, emit) async {
      if (event.error == null) {
        emit(BranchesLoading());
        if (authRepository.userAuth.authStatus != AuthStatus.authenticated ||
            authRepository.userAuth.user!.phoneNumber.isEmpty ||
            authRepository.userAuth.user!.role != UserRole.admin) {
          emit(BranchesNotAuthenticated());
        } else {
          try {
            final data = await branchRepository.getBranchesList();
            List<Branch> branches = data['branches'] as List<Branch>;
            List<Company> companies = data['companies'] as List<Company>;
            emit(BranchesAuthenticated(
              branches: branches,
              companies: companies,
              message: event.message,
              canViewBranches: true,
              canEditBranches: true,
              canAddBranches: true,
              canDeleteBranches: true,
              canViewCompanies: true,
              canEditCompanies: true,
              canAddCompanies: true,
              canDeleteCompanies: true,
            ));
          } catch (e) {
            emit(BranchesAuthenticated(
              branches: [],
              companies: [],
              error: e.toString(),
            ));
          }
        }
      } else {
        emit(BranchesNotAuthenticated(error: event.error));
      }
    });

    on<ModifyRequested>((event, emit) async {
      emit(BranchesLoading());
      try {
        await branchRepository.modifyBranch(event.branch);
        add(AuthChanged(message: BranchesMessage.branchModified));
      } catch (e) {
        add(AuthChanged(error: e.toString()));
      }
    });

    on<AddRequested>((event, emit) async {
      emit(BranchesLoading());
      try {
        await branchRepository.addBranch(event.branch);
        add(AuthChanged(message: BranchesMessage.branchAdded));
      } catch (e) {
        add(AuthChanged(error: e.toString()));
      }
    });

    on<DeleteRequested>((event, emit) async {
      emit(BranchesLoading());
      try {
        await branchRepository.deleteBranch(event.id);
        add(AuthChanged(message: BranchesMessage.branchDeleted));
      } catch (e) {
        add(AuthChanged(error: e.toString()));
      }
    });
  }
}
