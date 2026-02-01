import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:fire_alarm_system/utils/message.dart';
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
      if (!appRepository.isUserReady()) {
        emit(NotificationsNotAuthenticated());
      } else {
        emit(NotificationsAuthenticated(
          user: appRepository.userRole,
          notifications: [],
          hasMore: false,
          isLoadingNotifications: true,
          isNotificationsEnabled: null,
        ));
        await appRepository.notificationsRepository.readNotifications();
        emit(NotificationsAuthenticated(
          user: appRepository.userRole,
          notifications: appRepository.notificationsRepository.notifications,
          hasMore: appRepository.notificationsRepository.hasMore,
          isNotificationsEnabled: await appRepository.notificationsRepository
              .isNotificationsEnabled(),
        ));
      }
    });

    on<LoadNextNotifications>((event, emit) async {
      if (!appRepository.isUserReady()) {
        emit(NotificationsNotAuthenticated());
      } else {
        emit(NotificationsAuthenticated(
          user: appRepository.userRole,
          notifications: appRepository.notificationsRepository.notifications,
          isNotificationsEnabled: await appRepository.notificationsRepository
              .isNotificationsEnabled(),
          hasMore: appRepository.notificationsRepository.hasMore,
          isLoadingNext: true,
        ));
        await appRepository.notificationsRepository.readNextNotifications();
        emit(NotificationsAuthenticated(
          user: appRepository.userRole,
          notifications: appRepository.notificationsRepository.notifications,
          isNotificationsEnabled: await appRepository.notificationsRepository
              .isNotificationsEnabled(),
          hasMore: appRepository.notificationsRepository.hasMore,
        ));
      }
    });

    add(Refresh());

    on<EnableNotifications>((event, emit) async {
      emit(NotificationsAuthenticated(
        user: appRepository.userRole,
        notifications: appRepository.notificationsRepository.notifications,
        isNotificationsEnabled: false,
        hasMore: appRepository.notificationsRepository.hasMore,
        isLoadingEnableOrDisable: true,
      ));
      bool? isGranted = await appRepository.notificationsRepository
          .isNotificationPermissionGranted();
      if (isGranted != true) {
        await appRepository.notificationsRepository
            .requestNotificationPermission();
        isGranted = await appRepository.notificationsRepository
            .isNotificationPermissionGranted();
        if (isGranted != true) {
          emit(NotificationsAuthenticated(
            user: appRepository.userRole,
            notifications: appRepository.notificationsRepository.notifications,
            isNotificationsEnabled: false,
            hasMore: appRepository.notificationsRepository.hasMore,
            message: AppMessage(id: AppMessageId.notificationsPermissionDenied),
          ));
          return;
        }
      }
      final result =
          await appRepository.notificationsRepository.subscribeToUserTopics();
      emit(NotificationsAuthenticated(
        user: appRepository.userRole,
        notifications: appRepository.notificationsRepository.notifications,
        isNotificationsEnabled: await appRepository.notificationsRepository
            .isNotificationsEnabled(),
        hasMore: appRepository.notificationsRepository.hasMore,
        message: result
            ? AppMessage(id: AppMessageId.notificationsEnabled)
            : AppMessage(id: AppMessageId.unknownError),
      ));
    });

    on<DisableNotifications>((event, emit) async {
      emit(NotificationsAuthenticated(
        user: appRepository.userRole,
        notifications: appRepository.notificationsRepository.notifications,
        isNotificationsEnabled: true,
        hasMore: appRepository.notificationsRepository.hasMore,
        isLoadingEnableOrDisable: true,
      ));
      final result = await appRepository.notificationsRepository
          .unsubscribeFromUserTopics();
      emit(NotificationsAuthenticated(
        user: appRepository.userRole,
        notifications: appRepository.notificationsRepository.notifications,
        isNotificationsEnabled: await appRepository.notificationsRepository
            .isNotificationsEnabled(),
        hasMore: appRepository.notificationsRepository.hasMore,
        message: result
            ? AppMessage(id: AppMessageId.notificationsDisabled)
            : AppMessage(id: AppMessageId.unknownError),
      ));
    });
  }
}
