import 'package:first_app/BarcodeReader.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String scannedValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QRコードリーダー')),
      body: Center(
        child: Text(
          scannedValue.isEmpty ? 'バーコードをスキャンしてください' : scannedValue,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'QRコードリーダー',
          ),
        ],
        currentIndex: 0,
        onTap: (index) async {
          if (index == 1) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BarcodeReaderPage(),
              ),
            );
            if (result != null) {
              setState(() {
                scannedValue = result;
              });
            }
          }
        },
      ),
    );
  }
}
