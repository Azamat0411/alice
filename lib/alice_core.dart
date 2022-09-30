import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AliceCore {
  final bool? showNotification;

  void Function()? onTap;

  dynamic result;

  /// Should inspector be opened on device shake (works only with physical
  /// with sensors)
  final bool showInspectorOnShake;

  /// Should inspector use dark theme
  final bool darkTheme;

  /// Icon url for notification
  final String notificationIcon;

  ///Max number of calls that are stored in memory. When count is reached, FIFO
  ///method queue will be used to remove elements.
  final int maxCallsCount;

  ///Directionality of app. If null then directionality of context will be used.
  final TextDirection? directionality;

  ///Flag used to show/hide share button
  final bool? showShareButton;

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  GlobalKey<NavigatorState>? navigatorKey;
  Brightness _brightness = Brightness.light;
  bool _isInspectorOpened = false;

  StreamSubscription? _callsSubscription;

  /// Creates alice core instance
  AliceCore(
    this.navigatorKey, {
    this.showNotification,
    this.onTap,
    required this.showInspectorOnShake,
    required this.darkTheme,
    required this.notificationIcon,
    required this.maxCallsCount,
    this.directionality,
    required this.result,
    this.showShareButton,
  }) {
    if (showNotification ?? false) {
      _initializeNotificationsPlugin();
      _showLocalNotification();
    }
    _brightness = darkTheme ? Brightness.dark : Brightness.light;
  }

  /// Dispose subjects and subscriptions
  void dispose() {
    _callsSubscription?.cancel();
  }

  Brightness get brightness => _brightness;

  void _initializeNotificationsPlugin() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationSettingsAndroid =
        AndroidInitializationSettings(notificationIcon);

    const initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: _onSelectedNotification,
    );
  }

  Future<void> _onSelectedNotification(String? payload) async {
    assert(payload != null, "payload can't be null");
    navigateToCallListScreen();
    return;
  }

  void navigateToCallListScreen() {
    if (!_isInspectorOpened) {
      _isInspectorOpened = true;
      onTap;
      // NavigationPages().pushNamed("/alice", arguments: result);
    }
  }

  String _getNotificationMessage() {
    String notificationMessageString = '';

    notificationMessageString = result.data.toString();

    return notificationMessageString;
  }

  Future _showLocalNotification() async {
    const channelId = "Alice";
    const channelName = "Alice";
    const channelDescription = "Alice";
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      enableVibration: true,
      playSound: true,
      largeIcon: DrawableResourceAndroidBitmap(notificationIcon),
    );
    const iOSPlatformChannelSpecifics =
        IOSNotificationDetails(presentSound: false);
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    final String? message = _getNotificationMessage();
    await _flutterLocalNotificationsPlugin.show(
      0,
      "",
      message,
      platformChannelSpecifics,
    );
    // _notificationMessageShown = message;
    // _notificationProcessing = false;
    return;
  }
}

// class NavigationService {
//   static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
//   static Future<dynamic> pushNamed(String routeName, arguments) {
//     return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
//   }
// }
