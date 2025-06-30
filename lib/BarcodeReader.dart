import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeReaderPage extends StatefulWidget {
  const BarcodeReaderPage({Key? key}) : super(key: key);

  @override
  State<BarcodeReaderPage> createState() => _BarcodeReaderPageState();
}

class _BarcodeReaderPageState extends State<BarcodeReaderPage> {
  String scannedValue = '';
  late MobileScannerController controller;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRコードリーダー'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 600,
              child: MobileScanner(
                controller: controller,
                onDetect: (capture) async {
                  // QR コード検出時の処理
                  final List<Barcode> barcodes = capture.barcodes;
                  final value = barcodes[0].rawValue;
                  if (value != null) {
                    // 検出した QR コードの値でデータを更新
                    setState(() {
                      scannedValue = value;
                    });

                    // カメラを停止してから画面を閉じる
                    await controller.stop();
                    if (mounted) {
                      Navigator.pop(context, scannedValue);
                    }
                    debugPrint(value);
                  }
                },
              ),
            ),
            Text(
              scannedValue == '' ? 'QR コードをスキャンしてください。' : 'QRコードを検知しました。',
              style: const TextStyle(fontSize: 15),
            ),
            // QR コードの値を表示
            Text(scannedValue == '' ? "" : "value: $scannedValue"),
          ],
        ),
      ),
    );
  }
}
