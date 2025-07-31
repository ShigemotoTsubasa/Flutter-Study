import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:first_app/models/task_models.dart';
import 'dart:io' show Platform;

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  // 通知の初期化
  static Future<void> initialize() async {
    if (_initialized) return;

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
        // 通知タップ時の処理
        print('Notification tapped: ${response.payload}');
      },
    );

    // Android 13以降では通知権限をリクエスト
    if (Platform.isAndroid) {
      await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }

    _initialized = true;
  }

  // 即座に通知を表示（テスト用）
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Task Notifications',
      channelDescription: 'タスクの開始・終了時間の通知',
      importance: Importance.high,
      priority: Priority.high,
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
  }

  // スケジュール通知を設定
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Task Notifications',
      channelDescription: 'タスクの開始・終了時間の通知',
      importance: Importance.high,
      priority: Priority.high,
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

    // 現在時刻より未来の場合のみスケジュール
    if (scheduledTime.isAfter(DateTime.now())) {
      // 即座に通知を表示（デモ用）
      await showNotification(
        id: id,
        title: title,
        body: body,
        payload: payload,
      );
    }
  }

  // タスクの開始・終了通知をスケジュール
  Future<void> scheduleTaskNotifications(TaskModels task) async {
    // タスクIDを数値に変換（ハッシュコードを使用）
    final int taskIdHash = task.taskId.hashCode.abs();

    // 開始時間の通知をスケジュール
    await scheduleNotification(
      id: taskIdHash, // 開始通知のID
      title: 'タスク開始',
      body: '「${task.taskName}」が開始されました',
      scheduledTime: task.startAt,
      payload: 'task_start_${task.taskId}',
    );

    // 終了時間の通知をスケジュール
    await scheduleNotification(
      id: taskIdHash + 1, // 終了通知のID
      title: 'タスク終了',
      body: '「${task.taskName}」が終了しました',
      scheduledTime: task.endAt,
      payload: 'task_end_${task.taskId}',
    );
  }

  // タスクの通知をキャンセル
  Future<void> cancelTaskNotifications(String taskId) async {
    final int taskIdHash = taskId.hashCode.abs();
    await _notifications.cancel(taskIdHash); // 開始通知をキャンセル
    await _notifications.cancel(taskIdHash + 1); // 終了通知をキャンセル
  }

  // すべての通知をキャンセル
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // 保留中の通知を取得
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}
