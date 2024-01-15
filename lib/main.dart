// import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rose/rosescreen.dart';
import 'package:tflite_v2/tflite_v2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ImagePickerDemo(),
    );
  }
}

class ImagePickerDemo extends StatefulWidget {
  @override
  _ImagePickerDemoState createState() => _ImagePickerDemoState();
}

class _ImagePickerDemoState extends State<ImagePickerDemo> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  File? file;
  var _recognitions;
  var firstRecognition;
  // var dataList = [];
  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  loadmodel() async {
    await Tflite.loadModel(
      model: "assets/model/model22.tflite",
      labels: "assets/label/labels.txt",
    );
  }

  changescr(index){
    
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => RoseScreen(idx: index),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutQuart;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        file = File(image!.path);
      });
      detectimage(file!);
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future detectimage(File image) async {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 1,
      threshold: 0.01,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _recognitions = recognitions;
      firstRecognition = _recognitions?[0];
      int index = firstRecognition['index'];
      // changescr(index);
    });
    // print("//////////////////////////////////////////////////");
    // print(_recognitions);
    // var firstRecognition = _recognitions?[0];
    // var confidence = firstRecognition['confidence'];
    // var index = firstRecognition['index'];
    // var label = firstRecognition['label'];
    // print(confidence);
    // print(index);
    // print(label);
    // // print(v);
    // print("//////////////////////////////////////////////////");
    // int endTime = new DateTime.now().millisecondsSinceEpoch;
    // print("Inference took ${endTime - startTime}ms");
  }

  @override
  Widget build(BuildContext context) {
    List<Color> textcols=[
      Color.fromARGB(255, 83, 179, 38),
      Color.fromARGB(255, 59, 125, 21),
      Color.fromARGB(255, 151, 46, 46),
      Color.fromARGB(255, 178, 153, 25),
      Color.fromARGB(255, 170, 76, 120),
    ];
    double containerWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Flutter TFlite'),
      // ),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Transform.scale(
              scale: 1.5,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg.jpg'),
                    fit: BoxFit.none,
                  ),
                  color: Color(0xFFE3F3F0),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(300.0), 
                    bottomRight: Radius.circular(300.0), 
                    )
                ),  
                child: 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        child: Text('CHỌN ẢNH HOA BẠN MUỐN NHẬN DẠNG',
                          style: TextStyle(
                            color:Color.fromARGB(255, 19, 152, 83),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 40,),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: _image != null
                        ? GestureDetector(
                          onTap:()=>{
                            if(firstRecognition!=null)
                            {
                              changescr(firstRecognition['index'])
                            }
                            else(print('dfsdfs'))
                          },
                          child: Container(
                              margin: EdgeInsets.only(bottom: 40),
                              // padding: EdgeInsets.only(top:10,bottom: 10),
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(115, 239, 253, 255),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [                           
                                  Image.file(
                                    File(_image!.path),
                                    width: 150,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(height: 5,),
                                  Text(firstRecognition == null ? "" : firstRecognition['label'].toString(),
                                    style: TextStyle(
                                      color:textcols[firstRecognition['index']],
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                        )
                        : Container(
                          margin: EdgeInsets.only(bottom: 40),
                          // padding: EdgeInsets.only(top:10,bottom: 10),
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(115, 239, 253, 255),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ),
                    ],
                  ),       
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                // color: Color.fromARGB(125, 246, 253, 255),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Chọn ảnh từ thư viện'),
                    ),
                    SizedBox(height: 20),
                    // Text(v),
                  ],
                ),
              ),
                ),
          ),
        ],
      ),
    );
  }
}