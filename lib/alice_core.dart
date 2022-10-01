import 'dart:async';
import 'package:alica/alice_call_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AliceCore {
  final bool? showNotification;

  dynamic result;

  final bool showInspectorOnShake;

  final bool darkTheme;

  final String notificationIcon;

  final int maxCallsCount;

  final TextDirection? directionality;

  final bool? showShareButton;

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  GlobalKey<NavigatorState>? navigatorKey;
  Brightness _brightness = Brightness.light;
  bool _isInspectorOpened = false;

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
      _initializeNotificationsPlugin();
      _showLocalNotification();
    }
    _brightness = darkTheme ? Brightness.dark : Brightness.light;
  }

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
      BuildContext? context = navigatorKey?.currentContext;
      if(context != null){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>AliceCallDetailsScreen(result: result))
        );
      }
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
    return;
  }
}
