import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'alice_core.dart';

class Alice {

  final bool? showNotification;

  dynamic result;

  final bool showInspectorOnShake;

  final bool darkTheme;

  final String notificationIcon;

  final int maxCallsCount;

  final TextDirection? directionality;

  final bool? showShareButton;

  GlobalKey<NavigatorState>? _navigatorKey;

  Alice({
    GlobalKey<NavigatorState>? navigatorKey,
    this.showNotification,
    this.showInspectorOnShake = false,
    this.darkTheme = false,
    this.notificationIcon = "@mipmap/ic_launcher",
    this.maxCallsCount = 1000,
    this.directionality,
    this.result,
    this.showShareButton = true,
  }) {
    _navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();
    AliceCore(
      _navigatorKey,
      result: result,
      showNotification: showNotification,
      showInspectorOnShake: showInspectorOnShake,
      darkTheme: darkTheme,
      notificationIcon: notificationIcon,
      maxCallsCount: maxCallsCount,
      directionality: directionality,
      showShareButton: showShareButton,
    );
  }

  GlobalKey<NavigatorState>? getNavigatorKey() {
    return _navigatorKey;
  }
}

