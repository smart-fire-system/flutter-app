import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';

class BranchesBloc extends Bloc<BranchesEvent, BranchesState> {
  final AppRepository appRepository;
  String? createdId;
  BranchesMessage? message;

  BranchesBloc({required this.appRepository})
      : createdId = null,
        super(BranchesInitial()) {
    on<Refresh>((event, emit) async {
      if (!appRepository.isUserReady()) {
        emit(BranchesNotAuthenticated());
        return;
      }
      emit(BranchesAuthenticated(
        user: appRepository.userRole,
        branches: appRepository.branches,
        companies: appRepository.companies,
        createdId: createdId,
        message: message,
        error: event.error,
      ));
      message = null;
    });

    on<BranchModifyRequested>((event, emit) async {
      emit(BranchesLoading());
      try {
        await appRepository.branchRepository.modifyBranch(event.branch);
        message = BranchesMessage.branchModified;
      } catch (e) {
        add(Refresh(error: e.toString()));
      }
    });

    on<BranchAddRequested>((event, emit) async {
      emit(BranchesLoading());
      try {
        createdId =
            await appRepository.branchRepository.addBranch(event.branch);
        message = BranchesMessage.branchAdded;
      } catch (e) {
        add(Refresh(error: e.toString()));
      }
    });

    on<BranchDeleteRequested>((event, emit) async {
      emit(BranchesLoading());
      try {
        await appRepository.branchRepository.deleteBranch(event.id);
        message = BranchesMessage.branchDeleted;
      } catch (e) {
        add(Refresh(error: e.toString()));
      }
    });

    on<CompanyModifyRequested>((event, emit) async {
      emit(BranchesLoading());
      try {
        await appRepository.branchRepository
            .modifyCompany(event.company, event.logoFile);
        message = BranchesMessage.companyModified;
      } catch (e) {
        add(Refresh(error: e.toString()));
      }
    });

    on<CompanyAddRequested>((event, emit) async {
      emit(BranchesLoading());
      try {
        createdId = await appRepository.branchRepository.addCompany(
          event.company,
          event.logoFile,
        );
        message = BranchesMessage.companyAdded;
      } catch (e) {
        add(Refresh(error: e.toString()));
      }
    });

    on<CompanyDeleteRequested>((event, emit) async {
      emit(BranchesLoading());
      try {
        await appRepository.branchRepository
            .deleteCompany(event.id, event.branches);
        message = BranchesMessage.companyDeleted;
      } catch (e) {
        add(Refresh(error: e.toString()));
      }
    });

    add(Refresh());

    appRepository.authStateStream.listen((status) {
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
