import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final AppRepository appRepository;

  NotificationsBloc({required this.appRepository})
      : super(NotificationsInitial()) {
    appRepository.authStateStream.listen((status) {
      add(Refresh());
    });
    appRepository.notificationsStream.listen((_) {
      add(Refresh());
    });
    on<Refresh>((event, emit) async {
      if (!appRepository.isUserReady()) {
        emit(NotificationsNotAuthenticated());
      } else {
        emit(NotificationsAuthenticated(
          user: appRepository.userRole,
          notifications: appRepository.notificationsRepository.notifications,
          isNotificationGranted: await appRepository.notificationsRepository
              .isNotificationPermissionGranted(),
          isSubscribed: await appRepository.notificationsRepository
              .isSubscribedToUserTopics(),
        ));
      }
    });
    add(Refresh());
    on<RequestNotificationPermission>((event, emit) async {
      emit(NotificationsLoading());
      await appRepository.notificationsRepository
          .requestNotificationPermission();
      add(Refresh());
    });
    on<SubscribeToUserTopics>((event, emit) async {
      emit(NotificationsLoading());
      await appRepository.notificationsRepository.subscribeToUserTopics();
      add(Refresh());
    });
    on<UnsubscribeFromUserTopics>((event, emit) async {
      emit(NotificationsLoading());
      await appRepository.notificationsRepository.unsubscribeFromUserTopics();
      add(Refresh());
    });
  }
}
