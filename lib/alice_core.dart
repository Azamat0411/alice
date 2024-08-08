import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
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
      navigateToCallListScreen(payload ?? '');
    });
  }

  void navigateToCallListScreen(String payload) {
    BuildContext? context = navigatorKey?.currentContext;
    if (context != null) {
      final decodedJson = jsonDecode(payload);
      final r = Response(
        data: decodedJson['data'],
        statusCode: decodedJson['statusCode'],
        requestOptions: RequestOptions(
          baseUrl: decodedJson['baseUrl'],
          path: decodedJson['endPoint']??'',
          method: decodedJson['method'],
          headers: decodedJson['header'],
          queryParameters: decodedJson['queryParameters'],
        ),
      );
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AliceCallDetailsScreen(result: r)));
    }
  }

  String _getNotificationMessage() {
    String notificationMessageString = '';

    notificationMessageString = result.data.toString();

    return notificationMessageString;
  }

  Future<void> _showLocalNotification() async {
    final String message = _getNotificationMessage();

    String channelId = "Alice ${message.hashCode}";
    String channelName = "Alice ${message.hashCode}";
    String channelDescription = "Alice ${message.hashCode}";

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channelId, channelName,
            channelDescription: channelDescription);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    final response = DioResponse.fromJson(result as Response);

    final encodeResponse = jsonEncode(response.toJson());

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      "",
      message,
      notificationDetails,
      payload: encodeResponse,
    );
  }
}

class DioResponse {
  int? statusCode;
  String? method;
  String? baseUrl;
  String? endpoint;
  Map<String, dynamic>? header;
  dynamic data;
  Map<String, dynamic>? queryParameters;

  DioResponse.fromJson(Response response) {
    statusCode = response.statusCode;
    method = response.requestOptions.method;
    baseUrl = response.requestOptions.baseUrl;
    endpoint = response.requestOptions.path;
    header = response.requestOptions.headers;
    data = response.data;
    queryParameters = response.requestOptions.queryParameters;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['method'] = method;
    data['baseUrl'] = baseUrl;
    data['endPoint'] = endpoint;
    data['header'] = header;
    data['data'] = this.data;
    data['queryParameters'] = queryParameters;
    return data;
  }
}
