import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:bestbrightness/view/NavBar.dart';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:bestbrightness/controller/delivery_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final TextEditingController _deliveredBy = TextEditingController();
  final TextEditingController _stockName = TextEditingController();
  final TextEditingController _imgTimestamp = TextEditingController();
  late File? _imageFile = File('');
  IfdTag? _timestamp;
  bool imageLabelChecking = false;

  XFile? imageFile;

  String imageLabel = "";
  final _formKey = GlobalKey<FormState>();

  Map deliveredData = {
    "imgName": "",
    "deliveryDate": "",
    "deliveryTime": "",
    "deliveredBy": "",
    "items": "",
  };
  final List<Map<String, dynamic>> _selectedItem = [];
  String? _currentItemSelected;
  DeliveryController controller = Get.put(DeliveryController());
  List<dynamic> _items = [];
  final picker = ImagePicker();
late DateTime _selectedDate = DateTime.now();
  

  File? _theImageFile;
  String? name;
  
  var index = 0;
  
  late DateTime _selectedTime = DateTime.now();
  deliver() {
    deliveredData['items'] = jsonEncode(_selectedItem);
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      controller.deliverItems(deliveredData);
    }
  }

  Future<void> _loadData() async {
    var res = await controller.fetchList();

    _items = await res.map((row) => row['stockName']).toList();
    _items.insert(0, null);
    setState(() {
      _items = _items;
    });
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        final imageFiles = File(pickedImage.path);
        final imagePath = pickedImage.path;
        final imageExtension = imagePath.split('.').last;
        final String randomName = randomAlphaNumeric(20);
        final directory = await getApplicationDocumentsDirectory();
        final savedFile = await imageFiles
            .copy('${directory.path}/$randomName.$imageExtension');
        setState(() {
          _theImageFile = savedFile;
        });
        name = '${directory.path}/$randomName.$imageExtension';
        deliveredData['imgName'] = name;
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

  setImageName(imageLabel) {
    _stockName.value = _stockName.value.copyWith(
      text: "",
    );
    String newText = this.imageLabel;
    final updatedText = _stockName.text + newText;
    _stockName.value = _stockName.value.copyWith(
      text: updatedText,
      selection: TextSelection.collapsed(offset: updatedText.length),
    );
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    _loadData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Slip'),
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
                // if (_theImageFile != null)
                //   Container(
                //     width: 200,
                //     height: 200,
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       image: DecorationImage(
                //         image: FileImage(_theImageFile!),
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                //   ),
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
                const SizedBox(
                  height: 35,
                ),
                Column(
                  children: [
                    TextFormField(
                    onTap: () => _selectDate(context),
                      controller: TextEditingController(
                          text: _selectedDate == null
                              ? ''
                              : DateFormat('yyyy-MM-dd').format(_selectedDate)),
                     
                      decoration: InputDecoration(
                        label: Text('Delivery Date:'),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      
                      onSaved: (value) {
                        deliveredData['deliveryDate'] = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Delivery date required';
                        }
                        return null;
                      },
                    ),
                     const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                     controller: TextEditingController(
                        text: _selectedTime != null
                            ? TimeOfDay.fromDateTime(_selectedTime)
                                .format(context)
                            : '',
                      ),
                      onTap: () async {
                        TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() {
                            _selectedTime = DateTime.now()
                                .subtract(
                                    Duration(minutes: DateTime.now().minute))
                                .add(Duration(
                                    hours: time.hour, minutes: time.minute));
                          });
                        }
                      },
                      decoration: InputDecoration(
                        label: Text('Delivery Time:'),
                      ),
                      onSaved: (value) {
                        deliveredData['deliveryTime'] = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Delivery time required';
                        }
                        return null;
                      },
                    ),
                     const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _deliveredBy,
                      decoration: InputDecoration(
                        label: Text('Delivered By:'),
                      ),
                      onSaved: (value) {
                        deliveredData['deliveredBy'] = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Select an item:',
                      ),
                      child: DropdownButton<String>(
                        underline: const SizedBox(),
                        value: _currentItemSelected,
                        onChanged: (String? newValue) {
                          if (newValue != null ) {
                            setState(() {
                              _selectedItem.add({
                                'stockName': newValue,
                                'stockAmount': '',
                              });
                            });
                          }
                        },

                        //  _currentItemSelected = newValue!;

                        items: _items
                            .map<DropdownMenuItem<String>>((dynamic value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: value == null
                                ? const Text('Click to add item')
                                : Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Column(
                      children: _selectedItem.map((item) {
                     
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                           onChanged: (value) {
                              // Update the corresponding quantity in the _selectedItem list
                              int index = _selectedItem.indexOf(item);
                              _selectedItem[index]['stockAmount'] = value;
                            },
                            decoration: InputDecoration(
                            labelText: ' ${item['stockName']} (quantity):',
                              isCollapsed: false,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.delete),
                                color: const Color.fromRGBO(209, 20, 20, 1),
                                onPressed: () {
                                  setState(() {
                                    _selectedItem.remove(item);
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                ElevatedButton(onPressed: deliver, child: const Text("SUBMIT")),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
