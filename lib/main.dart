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
  Duration duration = const Duration(seconds: 0);
  Timer? timer;
  bool isRunning = false;

  void startTimer() {
    if (isRunning) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("すでにタイマーが動いています。"), backgroundColor: Colors.red),
      );
      return;
    }
    setState(() {
      isRunning = true;
      timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        setState(() {
          duration += const Duration(milliseconds: 10);
        });
      });
    });
  }

  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
      setState(() {
        isRunning = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("タイマーは動いていません。"), backgroundColor: Colors.red),
      );
    }
  }

  void resetTimer() {
    if (isRunning == false) {
      setState(() {
        duration = const Duration(
          hours: 0,
          minutes: 0,
          seconds: 0,
          milliseconds: 0,
          microseconds: 0,
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("タイマーが動いています。停止させてください"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
      ),
    );
  }
}
