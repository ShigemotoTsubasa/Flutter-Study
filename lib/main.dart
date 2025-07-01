import 'package:first_app/Page/BarcodeReader.dart';
import 'package:first_app/Page/WebViewPage.dart';
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
  List<String> barcodeList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QRコードリーダー')),
      body: Container(
        child: ListView(
          children: [
            barcodeList.isEmpty
                ? const Center(child: Text('バーコードをスキャンしてください'))
                : Column(
                    children: [
                      for (var barcode in barcodeList)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    WebViewPage(ISBN: barcode),
                              ),
                            );
                          },
                          child: Text(barcode),
                        ),
                    ],
                  ),
          ],
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
                barcodeList.add(result as String);
              });
            }
          }
        },
      ),
    );
  }
}
