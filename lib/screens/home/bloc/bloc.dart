import 'package:fire_alarm_system/models/notification.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/utils/message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'event.dart';
import 'state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AppRepository appRepository;
  bool _openNotifications = false;
  bool _initialMessage = false;
  NotificationItem? _notificationReceived;

  HomeBloc({required this.appRepository}) : super(HomeInitial()) {
    Future<HomeState> getHomeState({AppMessage? message, String? error}) async {
      if (appRepository.authStatus == AuthStatus.notAuthenticated) {
        return HomeNotAuthenticated(message: message, error: error);
      } else if (appRepository.userRole == null) {
        return HomeLoading();
      } else {
        UserInfo userInfo = appRepository.userInfo;
        if (appRepository.authStatus == AuthStatus.authenticatedNotVerified ||
            userInfo.phoneNumber.isEmpty ||
            appRepository.userRole is NoRoleUser) {
          return HomeNotAuthorized(
            user: appRepository.userRole,
            isEmailVerified:
                appRepository.authStatus == AuthStatus.authenticated,
            message: message,
            error: error,
          );
        } else {
          RemoteMessage? initialMessage =
              await FirebaseMessaging.instance.getInitialMessage();
          if (initialMessage != null && _initialMessage == false) {
            _initialMessage = true;
            _openNotifications = true;
          }
          NotificationItem? notificationReceived = _notificationReceived;
          bool openNotifications = _openNotifications;
          _openNotifications = false;
          _notificationReceived = null;
          return HomeAuthenticated(
            user: appRepository.userRole,
            notifications: appRepository.notificationsRepository.notifications,
            openNotifications: openNotifications,
            notificationReceived: notificationReceived,
            message: message,
            error: error,
          );
        }
      }
    }

    appRepository.notificationsStream.listen((_) {
      add(AuthChanged(error: AuthChangeResult.noError));
    });

    appRepository.authStateStream.listen((status) {
      add(AuthChanged(error: status));
    }, onError: (error) {
      add(AuthChanged(error: AuthChangeResult.generalError));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _openNotifications = true;
      add(AuthChanged(error: AuthChangeResult.noError));
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _notificationReceived = NotificationItem(
        id: message.messageId ?? '',
        enTitle: message.notification?.title ?? '',
        enBody: message.notification?.body ?? '',
        arTitle: message.notification?.title ?? '',
        arBody: message.notification?.body ?? '',
        topics: [],
        data: message.data,
        createdAt: null,
      );
      add(AuthChanged(error: AuthChangeResult.noError));
    });

    on<AuthChanged>((event, emit) async {
      if (event.error == AuthChangeResult.noError) {
        emit(await getHomeState());
      } else {
        emit(HomeError(error: event.error!));
      }
    });

    on<GoogleLoginRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await appRepository.authRepository.signInWithGoogle();
      } catch (error) {
        emit(await getHomeState(error: error.toString()));
      }
    });

    on<ResendEmailRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await appRepository.authRepository.resendActivationEmail();
        emit(await getHomeState(
          message: AppMessage(id: AppMessageId.emailConfirmationSent),
        ));
      } catch (error) {
        emit(await getHomeState(error: error.toString()));
      }
    });

    on<RefreshRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await appRepository.authRepository.refreshUserAuth();
      } catch (error) {
        emit(await getHomeState(error: error.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await appRepository.authRepository.signOut();
      } catch (error) {
        emit(await getHomeState(error: error.toString()));
      }
    });

    on<ResetPasswordRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await appRepository.authRepository.sendPasswordResetEmail();
        emit(await getHomeState(
          message: AppMessage(id: AppMessageId.resetPasswordEmailSent),
        ));
      } catch (error) {
        emit(await getHomeState(error: error.toString()));
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await appRepository.authRepository.signIn(event.email, event.password);
      } catch (error) {
        emit(await getHomeState(error: error.toString()));
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await appRepository.authRepository.signUpWithEmailAndPassword(
            event.email, event.password, event.name);
      } catch (error) {
        emit(await getHomeState(error: error.toString()));
      }
    });

    on<UpdatePhoneNumberRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await appRepository.userRepository.updateInformation(
          name: event.name,
          phoneNumber: event.phoneNumber,
          countryCode: event.countryCode,
        );
        await appRepository.authRepository.refreshUserAuth();
        emit(await getHomeState());
      } catch (error) {
        emit(await getHomeState(error: error.toString()));
      }
    });
  }
}
