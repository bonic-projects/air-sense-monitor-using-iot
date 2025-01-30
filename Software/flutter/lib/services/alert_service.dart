import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stacked/stacked.dart';

class AlertService with ListenableServiceMixin {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  DateTime? _lastNotificationTime;

  AlertService() {
    initialize();
  }
  Future<void> requestNotificationPermissions() async {
    final androidStatus = await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    print('Android Notification Permission: $androidStatus');
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidSettings,
    );

    // Initialize the plugin
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Notification tapped: ${response.payload}');
      },
    );

    // Create the notification channel for Android
    await _createNotificationChannel();

    _isInitialized = true;
  }

  Future<void> _createNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      'aqi_alert_channel', // Channel ID
      'AQI Alerts', // Channel name
      description: 'Alerts for dangerous air quality levels',
      importance: Importance.high,
      enableLights: true,
      enableVibration: true,
      playSound: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }
  Future<void> showAQIAlert(double aqi) async {
    if (!_isInitialized) {
      print('AlertService not initialized');
      return;
    }

    // Only show notification every 30 minutes
    if (_lastNotificationTime != null &&
        DateTime.now().difference(_lastNotificationTime!) < const Duration(minutes: 30)) {
      return;
    }

    _lastNotificationTime = DateTime.now();

    final androidDetails = AndroidNotificationDetails(
      'aqi_alert_channel',
      'AQI Alerts',
      channelDescription: 'Alerts for dangerous air quality levels',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
      enableLights: true,
      color: const Color.fromARGB(255, 255, 0, 0),
      ledColor: const Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 1000,
      ledOffMs: 500,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
    );

    try {
      await _notifications.show(
        0,
        'Dangerous Air Quality Alert!',
        'Current AQI is ${aqi.toStringAsFixed(1)}. Take necessary precautions.',
        NotificationDetails(
          android: androidDetails,
        ),
        payload: 'aqi_alert_${aqi.toStringAsFixed(1)}',
      );
      print('Notification sent successfully');
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  Future<void> setupBackgroundService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: 'aqi_alert_channel',
        initialNotificationTitle: 'AQI Background Service',
        initialNotificationContent: 'Monitoring Air Quality',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onBackground: onIosBackground,
      ),
    );
  }

  @pragma('vm:entry-point')
  void onStart(ServiceInstance service) async {
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground')?.listen((event) {
        service.setAsForegroundService();
      });

      // Periodic AQI check logic
      Timer.periodic(Duration(minutes: 15), (timer) {
        // Implement your AQI fetch logic here
        // Show notification if conditions met
      });
    }
  }

  @pragma('vm:entry-point')
  Future<bool> onIosBackground(ServiceInstance service) async {
    return true;
  }
}
