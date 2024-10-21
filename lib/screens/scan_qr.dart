import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrian/global/widgets/theme_switcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> with WidgetsBindingObserver {
  int index = 1;
  String? mapName;
  String? uid;
  String? event;
  String? status;
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
    } else {
      return ListTile(
        title: Text(
          mapName ?? 'No display value.',
          overflow: TextOverflow.fade,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          status ?? 'No display value.',
          overflow: TextOverflow.fade,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: ElevatedButton(
            onPressed: () {
              launchUrlString(value.displayValue!);
            },
            style: approved
                ? const ButtonStyle(
                    overlayColor: WidgetStatePropertyAll(Colors.transparent))
                : Theme.of(context).elevatedButtonTheme.style,
            child: approved ? const Icon(Icons.check) : const Text('Approve')),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.lightGreen.shade50,
      backgroundColor: const Color.fromARGB(255, 244, 251, 255),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 1.75,
        // toolbarHeight: 75,
        backgroundColor: Colors.blue.shade100,
        // shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(
        //     // bottomLeft: Radius.circular(20),
        //     // bottomRight:
        //     Radius.circular(20))),
        // leading: const DrawerButton(),
        title: Text('QRIAN',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold)),
        shadowColor: Colors.blue.shade900,
        // surfaceTintColor: Colors.blueGrey,
        // foregroundColor: Colors.white,
        actions: const [
          ThemeSwitcher()
          // IconButton(
          //     onPressed: () {
          //       Navigator.pushNamed(context, '/scan-qr');
          //     },
          //     icon: const Icon(Icons.qr_code_scanner_rounded))
        ],
        // backgroundColor: Colors.blue.shade300,
      ),

      // appBar: AppBar(
      //   toolbarHeight: 75,
      //   shape: const ContinuousRectangleBorder(
      //       borderRadius: BorderRadius.only(
      //           bottomLeft: Radius.circular(25),
      //           bottomRight: Radius.circular(25))),
      //   elevation: 10,
      //   title: const Text('QRIAN'),
      //   shadowColor: Colors.green,
      //   surfaceTintColor: Colors.blueGrey,
      //   foregroundColor: Colors.white,
      //   backgroundColor: Colors.teal,
      // ),
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
