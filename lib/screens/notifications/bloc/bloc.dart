import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final AppRepository appRepository;

  NotificationsBloc({required this.appRepository})
      : super(NotificationsInitial()) {
    appRepository.appStream.listen((status) {
      add(Refresh());
    });
    on<Refresh>((event, emit) async {
      emit(NotificationsLoading());
      if (!appRepository.isUserReady()) {
        emit(NotificationsNotAuthenticated());
      } else {
        await appRepository.notificationsRepository.readNotifications();
        emit(NotificationsAuthenticated(
          user: appRepository.userRole,
          notifications: appRepository.notificationsRepository.notifications,
          isNotificationGranted: await appRepository.notificationsRepository
              .isNotificationPermissionGranted(),
          isSubscribed: await appRepository.notificationsRepository
              .isSubscribedToUserTopics(),
          hasMore: appRepository.notificationsRepository.hasMore,
        ));
      }
    });
    on<LoadNextNotifications>((event, emit) async {
      if (!appRepository.isUserReady()) {
        emit(NotificationsNotAuthenticated());
      } else {
        final current = state;
        if (current is NotificationsAuthenticated) {
          emit(NotificationsLoadingNext(
            user: current.user,
            notifications: current.notifications,
            isNotificationGranted: current.isNotificationGranted,
            isSubscribed: current.isSubscribed,
            hasMore: current.hasMore,
          ));
        }
        await appRepository.notificationsRepository.readNextNotifications();
        emit(NotificationsAuthenticated(
          user: appRepository.userRole,
          notifications: appRepository.notificationsRepository.notifications,
          isNotificationGranted: await appRepository.notificationsRepository
              .isNotificationPermissionGranted(),
          isSubscribed: await appRepository.notificationsRepository
              .isSubscribedToUserTopics(),
          hasMore: appRepository.notificationsRepository.hasMore,
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
