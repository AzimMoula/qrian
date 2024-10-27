import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrian/global/widgets/theme_switcher.dart';
import 'package:qrian/screens/map_details.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> with WidgetsBindingObserver {
  int index = 1;
  String? mapName;
  String? nodeName;
  Barcode? _barcode;
  bool approved = false;
  late MobileScannerController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = MobileScannerController();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      controller.stop();
    } else if (state == AppLifecycleState.resumed) {
      controller.start();
    }
  }

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan the Map QR',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    } else if (value.displayValue!.split("\n").length != 2) {
      return const Text(
        'Invalid QR',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    } else {
      setState(() {
        mapName = value.displayValue!.split("\n").first;
        nodeName = value.displayValue!.split("\n")[1];
      });

      return ListTile(
        title: Text(
          mapName ?? 'No display value.',
          overflow: TextOverflow.fade,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          nodeName ?? 'No display value.',
          overflow: TextOverflow.fade,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (!mounted) {
      return;
    }
    setState(() {
      _barcode = barcodes.barcodes.firstOrNull;
    });
    controller.stop();
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return MapDetails(
          name: _barcode!.displayValue!.split('\n').first,
          currentNode: _barcode!.displayValue!.split('\n')[1],
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 251, 255),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 1.75,
        backgroundColor: Colors.blue.shade100,
        title: Text('QRIAN',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold)),
        shadowColor: Colors.blue.shade900,
        actions: const [ThemeSwitcher()],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _handleBarcode,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Center(child: _buildBarcode(_barcode))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
