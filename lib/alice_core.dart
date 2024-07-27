import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'alice_call_details_screen.dart';

class AliceCore {
  final bool? showNotification;

  dynamic result;

  final bool showInspectorOnShake;

  final bool darkTheme;

  final String notificationIcon;

  final int maxCallsCount;

  final TextDirection? directionality;

  final bool? showShareButton;

  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  GlobalKey<NavigatorState>? navigatorKey;
  Brightness _brightness = Brightness.light;
  bool _isInspectorOpened = false;

  final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();

  StreamSubscription? _callsSubscription;

  AliceCore(
    this.navigatorKey, {
    this.showNotification,
    required this.showInspectorOnShake,
    required this.darkTheme,
    required this.notificationIcon,
    required this.maxCallsCount,
    this.directionality,
    required this.result,
    this.showShareButton,
  }) {
    if (showNotification ?? false) {
      _requestPermissions();
      configureSelectNotificationSubject();
      initializeNotificationsPlugin();
      _showLocalNotification();
    }
    _brightness = darkTheme ? Brightness.dark : Brightness.light;
  }

  void dispose() {
    _callsSubscription?.cancel();
    selectNotificationStream.close();
  }

  Brightness get brightness => _brightness;

  void initializeNotificationsPlugin() {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
      notificationCategories: [],
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        selectNotificationStream.add(response.payload);
      },
    );
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    }
  }

  void configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      navigateToCallListScreen();
    });
  }

  void navigateToCallListScreen() {
    if (!_isInspectorOpened) {
      _isInspectorOpened = true;
      BuildContext? context = navigatorKey?.currentContext;
      if (context != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AliceCallDetailsScreen(result: result)));
      }
    }
  }

  String _getNotificationMessage() {
    String notificationMessageString = '';

    notificationMessageString = result.data.toString();

    return notificationMessageString;
  }

  Future<void> _showLocalNotification() async {

    final String? message = _getNotificationMessage();
    
    const channelId = "Alice ${message.hashCode}";
    const channelName = "Alice ${message.hashCode}";
    const channelDescription = "Alice ${message.hashCode}";

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channelId, channelName,
            channelDescription: channelDescription);

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    
    await _flutterLocalNotificationsPlugin.show(
        message.hashCode, "", message, notificationDetails);
  }
}
