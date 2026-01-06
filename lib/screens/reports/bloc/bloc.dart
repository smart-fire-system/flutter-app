import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:fire_alarm_system/screens/reports/bloc/reports_tempelate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  ReportsMessage? message;
  final AppRepository appRepository;

  ReportsBloc({required this.appRepository}) : super(ReportsInitial()) {
    on<Refresh>((event, emit) {
      if (event.error == null && appRepository.isUserReady()) {
        emit(ReportsAuthenticated(
          contractItems: ReportsTemplate.getContractItems(
              appRepository.reportsRepository.contractCategories ?? []),
          visitReports: appRepository.reportsRepository.visitReports,
          emergencyVisits: appRepository.reportsRepository.emergencyVisits,
          contractCategories:
              appRepository.reportsRepository.contractCategories,
          contractComponents:
              appRepository.reportsRepository.contractComponents,
          contracts: appRepository.reportsRepository.contracts,
          user: appRepository.userRole,
          employees: appRepository.employees,
          clients: appRepository.clients,
          message: message,
          error: event.error,
        ));
      } else {
        emit(ReportsNotAuthenticated(error: event.error));
      }
    });
    add(Refresh());

    appRepository.reportsRepository.refreshStream.listen((_) {
      add(Refresh());
    }, onError: (error) {
      add(Refresh(error: error.toString()));
    });

    on<SaveContractComponentsRequested>((event, emit) async {
      emit(ReportsLoading());
      await appRepository.reportsRepository
          .saveContractComponents(event.component);
      message = ReportsMessage.contractComponentsSaved;
    });

    on<SaveContractRequested>((event, emit) async {
      emit(ReportsLoading());
      await appRepository.reportsRepository.saveContract(event.contract);
      message = ReportsMessage.contractSaved;
    });

    on<SaveVisitReportRequested>((event, emit) async {
      emit(ReportsLoading());
      await appRepository.reportsRepository.saveVisitReport(event.visitReport);
      message = ReportsMessage.visitReportSaved;
    });

    on<SignContractRequested>((event, emit) async {
      emit(ReportsLoading());
      await appRepository.reportsRepository
          .signContract(user: appRepository.userRole, contract: event.contract);
      message = ReportsMessage.contractSigned;
    });

    on<SignVisitReportRequested>((event, emit) async {
      emit(ReportsLoading());
      await appRepository.reportsRepository.signVisitReport(
          user: appRepository.userRole, visitReport: event.visitReport);
      message = ReportsMessage.visitReportSigned;
    });

    on<FirstPartyInformationUpateRequested>((event, emit) async {
      if (appRepository.userRole is BranchManager) {
        emit(ReportsLoading());
        await appRepository.reportsRepository
            .setFirstPartyInformation(event.firstParty);
        message = ReportsMessage.firstPartyInformationUpdated;
      } else {
        add(Refresh(error: 'unauthorized'));
      }
    });

    on<SharedWithUpdateRequested>((event, emit) async {
      emit(ReportsLoading());
      await appRepository.reportsRepository
          .setSharedWith(event.contractId, event.sharedWith);
      message = ReportsMessage.sharedWithUpdated;
    });

    on<RequestEmergencyVisitRequested>((event, emit) async {
      emit(ReportsLoading());
      await appRepository.reportsRepository.requestEmergencyVisit(
          contractId: event.contractId, description: event.description);
      message = ReportsMessage.emergencyVisitRequested;
    });

    on<AddEmergencyVisitCommentRequested>((event, emit) async {
      try {
        await appRepository.reportsRepository.addEmergencyVisitComment(
          emergencyVisitId: event.emergencyVisitId,
          comment: event.comment,
        );
      } catch (e) {
        add(Refresh(error: e.toString()));
      }
    });
  }
}
