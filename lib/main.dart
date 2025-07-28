import 'package:first_app/screen/setting_screen.dart';
import 'package:first_app/screen/task_screen.dart';
import 'package:first_app/screen/widgets/add_task_dialog.dart';
// import 'package:first_app/screen/widgets/task_tabs.dart'; // この行は不要になる可能性があります
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 選択中のタブのインデックスを管理するProvider
final bottomNavIndexProvider = StateProvider((ref) => 0);

void main() {
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
    // TODO: 完了画面を実際のウィジェットに置き換えてください
    final screens = [
      const TaskScreen(),
      const Center(child: Text('完了タスク画面')), // 仮の完了画面
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
