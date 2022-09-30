import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'alice_core.dart';

class Alice {
  /// Should user be notified with notification if there's new request catched
  /// by Alice
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

  ///Directionality of app. Directionality of the app will be used if set to null.
  final TextDirection? directionality;

  ///Flag used to show/hide share button
  final bool? showShareButton;

  GlobalKey<NavigatorState>? _navigatorKey;

  /// Creates alice instance.
  Alice({
    GlobalKey<NavigatorState>? navigatorKey,
    this.showNotification,
    this.onTap,
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
      onTap: onTap,
      showNotification: showNotification,
      showInspectorOnShake: showInspectorOnShake,
      darkTheme: darkTheme,
      notificationIcon: notificationIcon,
      maxCallsCount: maxCallsCount,
      directionality: directionality,
      showShareButton: showShareButton,
    );
  }

  /// Get currently used navigation key
  GlobalKey<NavigatorState>? getNavigatorKey() {
    return _navigatorKey;
  }

  /// Handle request from HttpClient
  // void onHttpClientRequest(HttpClientRequest request, {dynamic body}) {
  //   _httpClientAdapter.onRequest(request, body: body);
  // }

  /// Handle response from HttpClient
  // void onHttpClientResponse(
  //   HttpClientResponse response,
  //   HttpClientRequest request, {
  //   dynamic body,
  // }) {
  //   _httpClientAdapter.onResponse(response, request, body: body);
  // }

  /// Handle both request and response from http package
  // void onHttpResponse(http.Response response, {dynamic body}) {
  //   _httpAdapter.onResponse(response, body: body);
  // }

  /// Opens Http calls inspector. This will navigate user to the new fullscreen
  /// page where all listened http calls can be viewed.
  // void showInspector() {
  //   _aliceCore.navigateToCallListScreen();
  // }

  /// Get chopper interceptor. This should be added to Chopper instance.
  // List<ResponseInterceptor> getChopperInterceptor() {
  //   return [AliceChopperInterceptor(_aliceCore)];
  // }

  /// Handle generic http call. Can be used to any http client.
  // void addHttpCall(AliceHttpCall aliceHttpCall) {
  //   assert(aliceHttpCall.request != null, "Http call request can't be null");
  //   assert(aliceHttpCall.response != null, "Http call response can't be null");
  //   _aliceCore.addCall(aliceHttpCall);
  // }
}

