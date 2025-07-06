import 'package:fire_alarm_system/models/pin.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'event.dart';
import 'state.dart';
import 'dart:async';

class SystemBloc extends Bloc<SystemEvent, SystemState> {
  final AppRepository appRepository;
  int? branchCode;
  List<Master> _masters = [];
  Timer? _timer;

  SystemBloc({required this.appRepository}) : super(SystemInitial()) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      for (var master in _masters) {
        if (master.isActive &&
            DateTime.now().difference(master.lastSeen).inSeconds > 10) {
          master.isActive = false;
          add(DataChanged());
        } else if (!master.isActive &&
            DateTime.now().difference(master.lastSeen).inSeconds <= 10) {
          master.isActive = true;
          add(DataChanged());
        }
      }
    });

    appRepository.authStateStream.listen((data) {
      add(AuthChanged(error: data == "" ? null : data));
    }, onError: (error) {
      add(AuthChanged(error: error.toString()));
    });

    appRepository.branchesAndCompaniesStream.listen((event) {
      appRepository.systemRepository.cancelStream();
      _masters = [];
      add(BranchesChanged());
    });

    on<AuthChanged>((event, emit) async {
      if (event.error == null) {
        if (appRepository.authStatus == AuthStatus.authenticated) {
          appRepository.systemRepository.cancelStream();
          branchCode = null;
          _masters = [];
          emit(SystemAuthenticated(
            branches: appRepository.branches,
            companies: appRepository.companies,
            branchesChanged: true,
          ));
        } else {
          emit(SystemNotAuthenticated());
        }
      } else {
        emit(SystemNotAuthenticated(error: event.error!));
      }
    });

    on<DataChanged>((event, emit) async {
      _masters = appRepository.systemRepository.masters;
      for (var master in _masters) {
        if (master.isActive &&
            DateTime.now().difference(master.lastSeen).inSeconds > 10) {
          master.isActive = false;
        } else if (!master.isActive &&
            DateTime.now().difference(master.lastSeen).inSeconds <= 10) {
          master.isActive = true;
        }
      }
      emit(SystemAuthenticated(
        branches: appRepository.branches,
        companies: appRepository.companies,
        masters: _masters,
      ));
    });

    on<BranchesChanged>((event, emit) async {
      emit(SystemAuthenticated(
        branches: appRepository.branches,
        companies: appRepository.companies,
        branchesChanged: true,
      ));
    });

    on<RefreshRequested>((event, emit) async {
      emit(SystemLoading());
      branchCode = event.branchCode;
      try {
        appRepository.systemRepository.cancelStream();
        appRepository.systemRepository.startStream(branchCode!, (_) {
          add(DataChanged());
        });
      } catch (error) {
        emit(SystemAuthenticated(
          branches: appRepository.branches,
          companies: appRepository.companies,
          error: error.toString(),
        ));
      }
    });

    on<SendCommandRequested>((event, emit) async {
      try {
        await appRepository.systemRepository.sendCommand(
          branchCode: event.branchCode,
          masterId: event.masterId,
          clientId: event.clientId,
          pinIndex: event.pinIndex,
          request: event.request.index,
          pinConfig: event.pinConfig,
        );
      } catch (error) {
        emit(SystemAuthenticated(
          branches: appRepository.branches,
          companies: appRepository.companies,
          error: error.toString(),
        ));
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
