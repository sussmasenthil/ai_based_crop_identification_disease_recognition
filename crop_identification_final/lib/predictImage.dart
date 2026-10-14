import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';



class predictPage extends StatefulWidget {
  final File imageFile;

  const predictPage({Key key, this.imageFile}) : super(key: key);
  @override
  State<StatefulWidget> createState() => new _predictState();
}

class _predictState extends State<predictPage> {
  File _image;
  List _recognitions;
  double _imageHeight;
  double _imageWidth;
  bool _busy = false;
  String _cropname = null;
  String _cropdesc = "Crop Description";

  @override
  void initState(){
    super.initState();
    _busy = true;

    loadModel().then((val){
      setState(() {
        _busy = false;
      });
    });
  }

  loadModel() async {
    Tflite.close();
    try {
      String res = await Tflite.loadModel(
          model: "assets/model.tflite",
          labels: "assets/labels.txt",
          numThreads: 1);
      print(res);
    }on PlatformException{
      print("Failed to load Model");
    }
  }

  Future predictImage(File image) async {
    if (image == null) return;

    await recognizeImage(image);

    setState(() {
      _image = image;
      _busy = false;
    });

    _cropname =  _recognitions.map((res) {
      return "${res["label"]}";
    }).toString();
    _cropname =_cropname.replaceAll("("," ");
    _cropname =_cropname.replaceAll(")"," ");
  }

  Future recognizeImage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 1,
      threshold: 0.05,
      imageMean: 0.0,
      imageStd: 255.0,
    );
    setState(() {
      _recognitions = recognitions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          fontFamily: 'Oxygen',
          brightness: Brightness.light
      ),
      title: 'Crop Identification', debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Crop Identification'),
          backgroundColor: Colors.lightGreen[900],
        ), //appBar
        body: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: _image == null && _recognitions == null
                        ? Container(child: Text(''), alignment: Alignment.bottomCenter,padding: EdgeInsets.only(top: 35.0))
                        : Container(
                        child: Text('$_cropname',style: TextStyle(fontSize: 40.0) ,), alignment: Alignment.center)),
                Expanded(
                  flex: 3,
                  child: _image == null
                      ? Container(
                      child: Text('No image selected'),
                      alignment: Alignment.center)
                      : Container(child: Image.file(_image,width: 350.0,height: 300.0,)),
                ),
                Expanded(
                    flex: 2,
                    child: _image == null
                        ? Container(child: Text(''), alignment: Alignment.center)
                        : Container(
                        child: Text(_cropdesc), alignment: Alignment.center))
              ],
            )), //Container
      ), //Scaffold
    ); //MaterialApp
  }
}
