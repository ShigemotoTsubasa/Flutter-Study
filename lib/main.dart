import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("ストップウォッチ")),
        body: Column(children: [StopWatch()]),
      ),
    );
  }
}

class StopWatch extends StatefulWidget {
  const StopWatch({super.key});

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  Duration duration = Duration.zero;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    if (timer?.isActive ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("すでにタイマーが動いています。"), backgroundColor: Colors.red),
      );
      return;
    }
    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        duration += const Duration(milliseconds: 10);
      });
    });
  }

  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("タイマーは動いていません。"), backgroundColor: Colors.red),
      );
    }
  }

  void resetTimer() {
    if (timer?.isActive ?? false) {
      // エラーメッセージを表示する
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("リセットする前にタイマーを停止してください。"),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      setState(() {
        duration = Duration.zero;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(duration.toString(), style: TextStyle(fontSize: 48)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                startTimer();
              },
              child: Text("Start"),
            ),
            ElevatedButton(
              onPressed: () {
                stopTimer();
              },
              child: Text("Stop"),
            ),
            ElevatedButton(
              onPressed: () {
                resetTimer();
              },
              child: Text("Reset"),
            ),
          ],
        ),
      ],
    );
  }
}
