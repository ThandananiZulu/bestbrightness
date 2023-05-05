import 'dart:io';

import 'package:bestbrightness/controller/capture_controller.dart';

import 'package:bestbrightness/services/noti.dart';
import 'package:bestbrightness/view/NavBar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';
import 'package:exif/exif.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:socket_io_client/socket_io_client.dart' as IO;

// import 'package:file_picker/file_picker.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({Key? key}) : super(key: key);

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  final TextEditingController _deliveredBy = TextEditingController();
  final TextEditingController _stockAmount = TextEditingController();
  final TextEditingController _stockPrice = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isRecording = false;
  bool _isPriceRecording = false;
  bool _isDelRecording = false;
  late File? _imageFile = File('');
  IfdTag? _timestamp;
  bool imageLabelChecking = false;

  XFile? imageFile;

  String imageLabel = "";
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _stockName = TextEditingController();
  final TextEditingController _imgTimestamp = TextEditingController();
  final TextEditingController _geotag = TextEditingController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final _formKey = GlobalKey<FormState>();
  Map captureData = {
    "imgTimestamp": "",
    "stockName": "",
    "scanCode": "",
    "stockAmount": "",
    "stockPrice": "",
  };
  String? scanResult;
  String? barcodeScanRes;
  CaptureController controller = Get.put(CaptureController());

  Future<void> scanBarcodes() async {
    String scanResult;

    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancel",
        true,
        ScanMode.BARCODE,
      );
    } on PlatformException {
      scanResult = "Failed to scan";
    }
    if (!mounted) return;

    setState(() {
      this.scanResult = scanResult;
      if (this.scanResult != null) {
        _controller.value = _controller.value.copyWith(
          text: "",
        );
        String newText = scanResult;
        final updatedText = _controller.text + newText;
        _controller.value = _controller.value.copyWith(
          text: updatedText,
          selection: TextSelection.collapsed(offset: updatedText.length),
        );
      }
    });
  }

  setImageName(imageLabel) {
    _stockName.value = _stockName.value.copyWith(
      text: "",
    );
    String newText = this.imageLabel.trim();
    final updatedText = _stockName.text + newText;
    _stockName.value = _stockName.value.copyWith(
      text: updatedText.trim(),
      selection: TextSelection.collapsed(offset: updatedText.length),
    );
  }

  void _onSpeechButtonPressed() {
    if (!_isRecording) {
      _startRecording();
    } else {
      _stopRecording();
    }
  }

  void _startRecording() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isRecording = true;
      });
      _speech.listen(onResult: (result) {
        setState(() {
          _stockAmount.text = result.recognizedWords;
        });
      });
    } else {
      setState(() {
        _isRecording = false;
      });
      _speech.stop();
    }
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
    _speech.stop();
  }

  void _onPriceSpeechButtonPressed() {
    if (!_isPriceRecording) {
      _priceStartRecording();
    } else {
      _priceStopRecording();
    }
  }

  void _priceStartRecording() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isPriceRecording = true;
      });
      _speech.listen(onResult: (result) {
        setState(() {
          _stockPrice.text = result.recognizedWords;
        });
      });
    } else {
      setState(() {
        _isPriceRecording = false;
      });
      _speech.stop();
    }
  }

  void _priceStopRecording() {
    setState(() {
      _isPriceRecording = false;
    });
    _speech.stop();
  }

  //
  void _onDelSpeechButtonPressed() {
    if (!_isDelRecording) {
      _delStartRecording();
    } else {
      _delStopRecording();
    }
  }

  void _delStartRecording() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isDelRecording = true;
      });
      _speech.listen(onResult: (result) {
        setState(() {
          _deliveredBy.text = result.recognizedWords;
        });
      });
    } else {
      setState(() {
        _isDelRecording = false;
      });
      _speech.stop();
    }
  }

  void _delStopRecording() {
    setState(() {
      _isDelRecording = false;
    });
    _speech.stop();
  }

  Future<void> scanQR() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get QR Code.';
    }

    if (!mounted) return;

    setState(() {
      this.barcodeScanRes = barcodeScanRes;
      if (this.barcodeScanRes != null) {
        _controller.value = _controller.value.copyWith(
          text: "",
        );
        String newText = barcodeScanRes;
        final updatedText = _controller.text + newText;
        _controller.value = _controller.value.copyWith(
          text: updatedText,
          selection: TextSelection.collapsed(offset: updatedText.length),
        );
      }
    });
  }

  captureItems() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      controller.captureItems(captureData);
    }
  }

  captureItemss() async {
     Noti.showBigTextNotification(title:'Title', body:'Message', fln: flutterLocalNotificationsPlugin);
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        imageLabelChecking = true;
        imageFile = pickedImage;

        setState(() {});
        await getImageLabels(pickedImage);
        _imageFile = File(pickedImage.path);
        _getTimestamp(_imageFile!);
      }
      setImageName(imageLabel);
    } catch (e) {
      imageLabelChecking = false;
      imageFile = null;
      imageLabel = "Error occurred while getting image Label";
      setState(() {});
    }
  }

  Future<void> getImageLabels(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    ImageLabeler imageLabeler =
        ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.75));
    List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    StringBuffer sb = StringBuffer();
    for (ImageLabel imgLabel in labels) {
      String lblText = imgLabel.label;
      double confidence = imgLabel.confidence;
      sb.write(lblText);
      sb.write("  ");
    }
    imageLabeler.close();
    imageLabel = sb.toString();
    imageLabelChecking = false;
    setState(() {});
  }

  Future _getTimestamp(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final exifData = await readExifFromBytes(bytes);
    final dateTime = await exifData['Image DateTime'];
    _imgTimestamp.value = await _imgTimestamp.value.copyWith(
      text: "",
    );
    IfdTag? newText = dateTime;
    final updatedText = _imgTimestamp.text + newText.toString();
    _imgTimestamp.value = await _imgTimestamp.value.copyWith(
      text: updatedText,
      selection: TextSelection.collapsed(offset: updatedText.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    Noti.initialize(flutterLocalNotificationsPlugin);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Inventory'),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const NavBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (imageLabelChecking) const CircularProgressIndicator(),
                if (!imageLabelChecking && imageFile == null)
                  SizedBox(
                    height: 10,
                  ),
                if (imageFile != null)
                  GestureDetector(
                    child: InteractiveViewer(
                      child: Image.file(_imageFile!),
                      boundaryMargin: EdgeInsets.all(20.0),
                      minScale: 0.1,
                      maxScale: 3.0,
                    ),
                    onDoubleTap: () {
                      setState(() {
                        _imageFile = File(_imageFile!.path);
                      });
                    },
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SignInButtonBuilder(
                        text: 'Upload Image',
                        textColor: Colors.black,
                        icon: Icons.image,
                        iconColor: Colors.black,
                        innerPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        },
                        // fontSize: 40.0,
                        backgroundColor: Color.fromARGB(255, 214, 255, 244),
                      ),
                    ),
                    Center(
                      child: SignInButtonBuilder(
                        text: 'Take Photo',
                        textColor: Colors.black,
                        icon: Icons.camera_alt,
                        iconColor: Colors.black,
                        innerPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        onPressed: () async {
                          getImage(ImageSource.camera);
                        },
                        // fontSize: 40.0,
                        backgroundColor: Color.fromARGB(255, 214, 255, 244),
                      ),
                    ),
                  ],
                ),

                Center(
                  child: SignInButtonBuilder(
                    text: 'Scan Barcode',
                    textColor: Colors.black,
                    icon: CupertinoIcons.barcode,
                    iconColor: Colors.black,
                    innerPadding: EdgeInsets.symmetric(horizontal: 20.0),
                    onPressed: () {
                      scanBarcodes();
                    },
                    // fontSize: 40.0,
                    backgroundColor: const Color.fromARGB(255, 224, 232, 236)!,
                  ),
                ),
                Center(
                  child: SignInButtonBuilder(
                    text: 'Scan QR Code',
                    textColor: Colors.black,
                    icon: CupertinoIcons.qrcode,
                    iconColor: Colors.black,
                    innerPadding: EdgeInsets.symmetric(horizontal: 20.0),
                    onPressed: () {
                      scanQR();
                    },
                    // fontSize: 40.0,
                    backgroundColor: const Color.fromARGB(255, 224, 232, 236),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _imgTimestamp,
                  decoration: InputDecoration(
                    label: Text('Time Stamp Info:'),
                  ),
                  onSaved: (value) {
                    captureData['imgTimestamp'] = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Timestamp required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _stockName,
                  decoration: InputDecoration(
                    label: Text('Stock Name:'),
                  ),
                  onSaved: (value) {
                    captureData['stockName'] = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Stock name required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: InputDecoration(
                    label: Text(
                      'Stock Code / BarCode:',
                    ),
                  ),
                  onSaved: (value) {
                    captureData['scanCode'] = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Code required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _stockAmount,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                      ),
                      color: Color.fromRGBO(44, 113, 190, 1),
                      hoverColor: Color.fromRGBO(44, 113, 190, 1),
                      onPressed: _onSpeechButtonPressed,
                    ),
                    label: Text('Stock Amount:'),
                  ),
                  onSaved: (value) {
                    captureData['stockAmount'] = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Amount required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _stockPrice,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPriceRecording ? Icons.stop : Icons.mic,
                      ),
                      color: Color.fromRGBO(44, 113, 190, 1),
                      hoverColor: Color.fromRGBO(44, 113, 190, 1),
                      onPressed: _onPriceSpeechButtonPressed,
                    ),
                    label: Text('Stock Price: (R)'),
                  ),
                  onSaved: (value) {
                    captureData['stockPrice'] = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Price required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),

                ElevatedButton(
                    onPressed: captureItems, child: const Text("SUBMIT")),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: captureItemss, child: const Text("SUBMIjjT")),
                const SizedBox(
                  height: 15,
                ),
                // Add TextFormFields and ElevatedButton here.
              ],
            ),
          ),
        ),
      ),
    );
  }
}
