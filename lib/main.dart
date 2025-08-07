import 'package:first_app/screen/completed_task_screen.dart';
import 'package:first_app/screen/setting_screen.dart';
import 'package:first_app/screen/task_screen.dart';
import 'package:first_app/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart';

// 選択中のタブのインデックスを管理するProvider
final bottomNavIndexProvider = StateProvider((ref) => 0);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationService.initialize();
  runApp(const ProviderScope(child: TaskApp()));
}

// StatelessWidgetをConsumerWidgetに変更します
class TaskApp extends ConsumerWidget {
  const TaskApp({super.key});

  @override
  // buildメソッドにWidgetRef refを追加します
  Widget build(BuildContext context, WidgetRef ref) {
    // Providerを監視して、現在のインデックスを取得します
    final currentIndex = ref.watch(bottomNavIndexProvider);

    // 各タブに対応する画面のリスト
    final screens = [
      const TaskScreen(),
      const CompletedTaskScreen(),
      const SettingScreen(),
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Task"), centerTitle: true),
        // 選択中のインデックスに応じてbodyを切り替えます
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          // 現在のインデックスを設定します
          currentIndex: currentIndex,
          // タブがタップされたときの処理
          onTap: (index) {
            // Providerの状態を更新して画面を再描画します
            ref.read(bottomNavIndexProvider.notifier).state = index;
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'タスク'),
            BottomNavigationBarItem(icon: Icon(Icons.check), label: '完了'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: '設定'),
          ],
        ),
      ),
    );
  }
}
