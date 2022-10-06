import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_tts/flutter_tts.dart';

bool isProcessing = false;

class BarcodeScannerWithController extends StatefulWidget {
  const BarcodeScannerWithController({Key? key}) : super(key: key);

  @override
  _BarcodeScannerWithControllerState createState() => _BarcodeScannerWithControllerState();
}

class _BarcodeScannerWithControllerState extends State<BarcodeScannerWithController>
    with SingleTickerProviderStateMixin {
  String? barcode;

  FlutterTts flutterTts = FlutterTts();

  MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
    formats: [BarcodeFormat.qrCode],
    //facing: CameraFacing.front,
  );

  bool isStarted = true;

  @override
  Widget build(BuildContext context) {
    print("-----------------------------      build      -------------------------------------------");
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
            return Stack(
              children: [
                if(isProcessing)
                  Container(color: Colors.green),

                MobileScanner(
                  controller: controller,
                  fit: BoxFit.contain,
                  allowDuplicates: true,
                  // controller: MobileScannerController(
                  //   torchEnabled: true,
                  //   facing: CameraFacing.front,
                  // ),
                  onDetect: (barcode, args) async {

                    // if(!isProcessing) {
                    //   isProcessing = true;
                    //   print("already processed - returned");
                    //   Future.delayed(Duration(seconds: 3), () {
                    //     isProcessing = false;
                    //   });
                    // }


                    if (isProcessing) {
                      print("already processed - returned");
                      return;
                    }
                    isProcessing = true;

                    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ${barcode.rawValue}");
                    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ${args.toString()}");
                    if (barcode.rawValue != null) {

                      // if(controller.isStarting) {
                      //   controller.isStarting = false;
                      //   print("camera stop");
                      //
                      // }

                      if (this.barcode == barcode.rawValue) {
                        await flutterTts.speak("이미 처리된 티켓입니다.");
                      } else {
                        await flutterTts.speak("인증되었습니다");
                      }
                      this.barcode = barcode.rawValue;
                      await Future.delayed(Duration(seconds: 2));
                      isProcessing = false;
                      // if(!controller.isStarting) {
                      //   controller.isStarting = true;
                      //   print("camera start");
                      //
                      //   await controller.start();
                      //  }
                    }
                  },
                ),
              ],
            );
          }
      ),
    );
  }
}
