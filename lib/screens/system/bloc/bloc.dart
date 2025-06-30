import 'package:fire_alarm_system/models/pin.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:fire_alarm_system/repositories/system_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'event.dart';
import 'state.dart';

class SystemBloc extends Bloc<SystemEvent, SystemState> {
  final AppRepository appRepository;
  int? branchCode;
  List<Master> masters = [];
  SystemRepository systemRepository = SystemRepository();

  SystemBloc({required this.appRepository}) : super(SystemInitial()) {
    appRepository.authStateStream.listen((data) {
      add(AuthChanged(error: data == "" ? null : data));
    }, onError: (error) {
      add(AuthChanged(error: error.toString()));
    });

    on<MasterDataChanged>((event, emit) async {
      emit(SystemAuthenticated(masters: event.masters));
    });

    on<AuthChanged>((event, emit) async {
      if (event.error == null) {
        if (appRepository.authStatus == AuthStatus.notAuthenticated) {
          emit(SystemNotAuthenticated());
        } else {
          if (branchCode == null) {
            masters = [];
          } else {
            try {
              masters = await systemRepository.getMasters(branchCode!);
            } catch (error) {
              emit(SystemAuthenticated(error: error.toString()));
            }
          }
          emit(SystemAuthenticated(masters: masters));
        }
      } else {
        emit(SystemNotAuthenticated(error: event.error!));
      }
    });

    on<RefreshRequested>((event, emit) async {
      emit(SystemLoading());
      branchCode = event.branchCode;
      try {
        systemRepository.startStream(branchCode!, (newData) {
          add(MasterDataChanged(masters: newData));
        });
        masters = await systemRepository.getMasters(branchCode!);
        List<DateTime> lastSeen =
            await systemRepository.getLastSeen(branchCode!);
        for (int i = 0; i < masters.length; i++) {
          masters[i].lastSeen = lastSeen[i];
        }
        emit(SystemAuthenticated(masters: masters));
      } catch (error) {
        emit(SystemAuthenticated(error: error.toString()));
      }
    });

    on<LastSeenRequested>((event, emit) async {
      try {
        List<DateTime> lastSeen =
            await systemRepository.getLastSeen(branchCode!);
        for (int i = 0; i < lastSeen.length; i++) {
          masters[i].lastSeen = lastSeen[i];
        }
        emit(SystemAuthenticated(masters: masters));
      } catch (error) {
        emit(SystemAuthenticated(error: error.toString()));
      }
    });

    on<SendCommandRequested>((event, emit) async {
      try {
        await systemRepository.sendCommand(
          branchCode: event.branchCode,
          masterId: event.masterId,
          clientId: event.clientId,
          pinIndex: event.pinIndex,
          request: event.request.index,
          pinConfig: event.pinConfig,
        );
      } catch (error) {
        emit(SystemAuthenticated(error: error.toString()));
      }
    });
  }
}
