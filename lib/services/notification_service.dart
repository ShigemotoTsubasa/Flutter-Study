import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:first_app/models/task_models.dart';
import 'dart:io' show Platform;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  // 通知の初期化（修正版）
  static Future<void> initialize() async {
    debugPrint("=== NotificationService.initialize() 開始 ===");
    if (_initialized) {
      debugPrint("既に初期化済みです");
      return;
    }

    try {
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));
      debugPrint("タイムゾーンを日本に設定しました");

      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initializationSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('通知がタップされました: ${response.payload}');
        },
      );

      if (Platform.isAndroid) {
        final androidImplementation = _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

        if (androidImplementation != null) {
          final granted = await androidImplementation
              .requestNotificationsPermission();
          if (granted == true) {
            debugPrint("Android通知権限が許可されました");
          } else {
            debugPrint("Android通知権限が拒否されました");
          }
        }
      }

      // 2. 正確なアラームの権限をリクエスト (Android 12以降で重要)
      if (Platform.isAndroid) {
        if (await Permission.scheduleExactAlarm.isDenied) {
          final status = await Permission.scheduleExactAlarm.request();
          if (status.isGranted) {
            debugPrint("正確なアラームの権限が許可されました");
          } else {
            debugPrint("正確なアラームの権限が拒否されました");
          }
        } else {
          debugPrint("既に正確なアラームの権限が許可されています");
        }
      }

      _initialized = true;
      debugPrint("=== NotificationService 初期化完了 ===");
    } catch (e) {
      debugPrint("NotificationService 初期化エラー: $e");
      rethrow;
    }
  }

  // 即座に通知を表示（修正版）
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      debugPrint("=== 即座通知の送信開始 ===");
      debugPrint("ID: $id, Title: $title, Body: $body");

      // Android用の通知詳細設定（修正版）
      const androidDetails = AndroidNotificationDetails(
        'task_channel',
        'Task Notifications',
        channelDescription: 'タスクの開始・終了時間の通知',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      debugPrint("=== 即座通知の送信完了 ===");
    } catch (e) {
      debugPrint("即座通知の送信に失敗: $e");
      rethrow;
    }
  }

  // スケジュール通知を設定（修正版）
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    try {
      debugPrint("=== スケジュール通知の設定開始 ===");
      debugPrint("ID: $id, Title: $title");
      debugPrint("スケジュール時間: $scheduledTime");

      // Android用の通知詳細設定（修正版）
      const androidDetails = AndroidNotificationDetails(
        'task_schedule_channel',
        'Task Schedule Notifications',
        channelDescription: 'スケジュールされたタスク通知',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final tz.TZDateTime scheduledTZ = tz.TZDateTime.from(
        scheduledTime,
        tz.local,
      );

      final now = tz.TZDateTime.now(tz.local);
      debugPrint("現在の時刻: $now");
      debugPrint("スケジュール時刻(TZ): $scheduledTZ");

      // 現在時刻より未来の場合のみスケジュール
      if (scheduledTZ.isAfter(now)) {
        await _notifications.zonedSchedule(
          id,
          title,
          body,
          scheduledTZ,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: payload,
        );

        debugPrint('✅ 通知をスケジュールしました: $title at $scheduledTZ');
      } else {
        debugPrint('⚠️ 過去の時間のため通知をスケジュールしませんでした: $scheduledTime');
      }
    } catch (e) {
      debugPrint("❌ スケジュール通知の設定に失敗: $e");
      rethrow;
    }
  }

  int _generateTaskNotificationId(
    String taskId, {
    bool isEndNotification = false,
  }) {
    // taskIdの最後の部分（ミリ秒）を使用してIDを生成
    final timestamp = DateTime.parse(taskId).millisecondsSinceEpoch;
    final baseId = timestamp % 1000000; // 6桁に制限
    return isEndNotification ? baseId + 1 : baseId;
  }

  // タスクの開始・終了通知をスケジュール
  Future<void> scheduleTaskNotifications(TaskModels task) async {
    debugPrint("=== タスク通知のスケジュール開始 ===");
    debugPrint("タスク名: ${task.taskName}");
    debugPrint("開始時間: ${task.startAt}");
    debugPrint("終了時間: ${task.endAt}");

    // 開始時間の通知をスケジュール
    await scheduleNotification(
      id: _generateTaskNotificationId(task.taskId),
      title: 'タスク開始',
      body: '「${task.taskName}」が開始されました',
      scheduledTime: task.startAt,
      payload: 'task_start_${task.taskId}',
    );

    // 終了時間の通知をスケジュール
    await scheduleNotification(
      id: _generateTaskNotificationId(task.taskId, isEndNotification: true),
      title: 'タスク終了',
      body: '「${task.taskName}」が終了しました',
      scheduledTime: task.endAt,
      payload: 'task_end_${task.taskId}',
    );

    debugPrint("=== タスク通知のスケジュール完了 ===");
  }

  // タスクの通知をキャンセル
  Future<void> cancelTaskNotifications(String taskId) async {
    await _notifications.cancel(_generateTaskNotificationId(taskId));
    await _notifications.cancel(
      _generateTaskNotificationId(taskId, isEndNotification: true),
    );
    debugPrint("タスク通知をキャンセルしました: $taskId");
  }

  // すべての通知をキャンセル
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    debugPrint("すべての通知をキャンセルしました");
  }

  // 保留中の通知を取得
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // 通知システムの診断メソッド
  Future<void> diagnoseNotificationSystem() async {
    debugPrint("=== 通知システム診断開始 ===");

    try {
      // 初期化状態を確認
      debugPrint("初期化状態: $_initialized");

      // 保留中の通知を確認
      final pending = await getPendingNotifications();
      debugPrint("保留中の通知数: ${pending.length}");
      for (final notification in pending) {
        debugPrint("  - ID: ${notification.id}, Title: ${notification.title}");
      }

      // プラットフォーム固有の確認
      if (Platform.isAndroid) {
        final androidImplementation = _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        if (androidImplementation != null) {
          final granted = await androidImplementation.areNotificationsEnabled();
          debugPrint("Android通知権限: ${granted == true ? '許可' : '拒否'}");
        }
      }

      debugPrint("=== 通知システム診断完了 ===");
    } catch (e) {
      debugPrint("診断中にエラー: $e");
    }
  }

  // テスト用：5秒後の通知
  Future<void> scheduleTestNotificationIn5Seconds() async {
    final now = DateTime.now();
    final fiveSecondsLater = now.add(const Duration(seconds: 5));

    await scheduleNotification(
      id: 99999,
      title: 'テスト通知（5秒後）',
      body: '5秒後の通知テストです',
      scheduledTime: fiveSecondsLater,
      payload: 'test_5sec',
    );

    debugPrint('5秒後の通知をスケジュールしました: $fiveSecondsLater');
  }

  // テスト用：1分後の通知
  Future<void> scheduleTestNotificationIn1Minute() async {
    final now = DateTime.now();
    final oneMinuteLater = now.add(const Duration(minutes: 1));

    await scheduleNotification(
      id: 99998,
      title: 'テスト通知（1分後）',
      body: '1分後の通知テストです',
      scheduledTime: oneMinuteLater,
      payload: 'test_1min',
    );

    debugPrint('1分後の通知をスケジュールしました: $oneMinuteLater');
  }
}
