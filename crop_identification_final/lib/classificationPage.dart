import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'chooseImagePage.dart';
import 'main.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';

class Classification extends StatefulWidget {

  final File imageFile;

  const Classification({Key key, this.imageFile}) : super(key: key);

  @override
  _ClassificationState createState() => _ClassificationState();
}

class _ClassificationState extends State<Classification> {

  File _image;
  List _recognitions;
  double _imageHeight;
  double _imageWidth;
  bool _busy = false;
  String _cropname = null;
  var _cropdesc = new List(6);

  String c_model = 'assets/model.tflite';
  String d_model = 'assets/diseasemodel.tflite';
  String _model = null;
  var _ddesc = new List(3);
  var desc = new List.generate(10,(_) => new List(6));
  var _desc = new List.generate(5, (_) => new List(3));
  String _disease = null;
  String display = null;
  String _result = null;




  @override
  void initState() {
    super.initState();
    _busy = true;
    _model = c_model;
    desc[0][0] = 'Vegetable Crop';
    desc[0][1] = 'July - January';
    desc[0][2] = 'Medium black soils, Alluvial soil along the river beds ';
    desc[0][3] = '24°c - 27°c';
    desc[0][4] = '65-75 cm';
    desc[0][5] = 'Tropical and Sub-tropical regions';
    desc[1][0] = 'Beverage Crop';
    desc[1][1] = 'October-March';
    desc[1][2] = 'Heavy Clay soil';
    desc[1][3] = '12°c- 25°c';
    desc[1][4] = '1500-2500 mm';
    desc[1][5] = 'Hilly regions';
    desc[2][0] = 'Cash Crop';
    desc[2][1] = 'April-May';
    desc[2][2] = 'medium to deep black clayey soil ';
    desc[2][3] = '18°c- 30°c';
    desc[2][4] = '60-100 cm';
    desc[2][5] = 'Sub-tropical and tropical regions';
    desc[3][0] = 'Fibre and cash crop';
    desc[3][1] = 'Jan-Feb';
    desc[3][2] = 'clay loam soil, sand loamy soil';
    desc[3][3] = '25°c- 35°c';
    desc[3][4] = '160-200 cm';
    desc[3][5] = 'Sub-tropical regions';
    desc[4][0] = 'Food crop';
    desc[4][1] = 'June to September';
    desc[4][2] = 'loamy';
    desc[4][3] = '21°c to 27°c ';
    desc[4][4] = '50 cm to 75 cm';
    desc[4][5] = 'Andhra Pradesh and Karnataka';
    desc[5][0] = 'Food crop';
    desc[5][1] = 'June to November';
    desc[5][2] = 'clayey loam';
    desc[5][3] = '25°c';
    desc[5][4] = '100cm';
    desc[5][5] = 'Northeast plains and coastal areas';
    desc[7][0] = 'Cash crop';
    desc[7][1] = 'January to December';
    desc[7][2] = 'sandy, loamy, and clay soils';
    desc[7][3] = '150cm';
    desc[7][4] = '20° to 26°C';
    desc[7][5] = 'Uttar Pradhesh';
    desc[6][0] = 'Food crop';
    desc[6][1] = 'June to September';
    desc[6][2] = 'Sandy loam ';
    desc[6][3] = '15°c to 32°c';
    desc[6][4] = '60-65 cm';
    desc[6][5] = 'Maharashtra and central India\'s Madhya Pradesh';
    desc[8][0] = 'Cash Crops';
    desc[8][1] = 'June to September';
    desc[8][2] = 'Loam';
    desc[8][3] = '21°C';
    desc[8][4] = '150cm';
    desc[8][5] = 'Assam';
    desc[9][0] = 'Food Crop';
    desc[9][1] = 'November-March';
    desc[9][2] = 'Loamy soil';
    desc[9][3] = '25°C';
    desc[9][4] = '30cm – 100cm';
    desc[9][5] = 'Uttar Pradhesh';
    _desc[0][0] = 'Appears on different parts of cotton plant, both in seedling and mature plant stage, enlarge into angular reddish spots about 1 mm in diameter.Dry and hot weather retards disease development.';
    _desc[0][1] = 'Xanthomonas axonopodis pv malvacearum';
    _desc[0][2] = ' 1.Use of healthy seed from healthy plants.\n\t\t\t\t'
        '2.Delinting seeds with concentrated sulphuric acid then floating the delinted seeds in water and removal of the floating seeds.\n\t\t\t\t'
        '3.Disinfections of seeds with 1000 ppm streptomycin sulphate solution overnight.';
    _desc[2][0] = 'Gray leaf spot lesions begin as small necrotic pinpoints with chlorotic halos, these are more visible when leaves are backlit.';
    _desc[2][1] = 'Cercospora zeae-maydis';
    _desc[2][2] = '1.During the growing season, foliar fungicides can be used to manage gray leaf spot outbreaks.\n\t\t\t\t'
        '2.Cercospora zeae-maydis overwinters in corn debris, so production practices such as tillage and crop rotation that reduce the amount corn residue on the surface will decrease the amount of primary inoculum';
    _desc[1][0] = '1.Lesions begin as flecks on leaves that develop into small tan spots\n\t\t\t\t'
        '2.Spots turn into elongated brick-red to cinnamon-brown pustules with jagged appearance\n\t\t\t\t'
        '3.Found on both upper AND lower leaf surfaces (unlike southern rust)';
    _desc[1][1] = 'Puccinia sorghi';
    _desc[1][2] = 'Apply a foliar fungicide if:\n\t\t\t\t\t\t\t\t'
        '1.Rust is spreading rapidly or likely to spread and yield may be affected\n\t\t\t\t\t\t\t\t'
        ''
        '2.Disease exceeds threshold established by your state extension plant pathologist';
    _desc[3][0] = 'The tan lesions of northern corn leaf blight are slender and oblong tapering at the ends ranging in size between 1 to 6 inches.';
    _desc[3][1] = 'Exerohilum turcicum ';
    _desc[3][2] = '1.It can be managed through the use of resistant hybrids.\n\t\t\t\t'
        '2.Additionally, timely planting can be useful for avoiding conditions that favor the disease.';
    _desc[4][0] = 'Water-soaked lesions that dry out and turn brown forming on the underside of the leaves; raised brown cankers on stems; cracked brown lesions on fruit.';
    _desc[4][1] = 'Ralstonia solanacearum';
    _desc[4][2] = 'Use disease free planting material; remove and destroy all crop debris after harvest, or plow material deeply under soil.';

        loadModel().then((val) {
      setState(() {
        _busy = false;
      });
    });
  }



  loadModel() async {
    Tflite.close();
    try {
      String res;
      if(_model == c_model ){
        res = await Tflite.loadModel(
          model: "assets/model.tflite",
          labels: "assets/labels.txt",
          numThreads: 1);}
      else{
        res = await Tflite.loadModel(
            model: "assets/diseasemodel.tflite",
            labels: "assets/diseaselabels.txt",
            numThreads: 1);}
      print(res);
    } on PlatformException {
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
    String ind;
    ind = _recognitions.map((res){
      return "${res["index"]}";
    }).toString();

    ind = ind.replaceAll("(", " ");
    ind = ind.replaceAll(")", " ");

    int index = int.parse(ind);

    _cropname = _recognitions.map((res) {
      return "${res["label"]}";
    }).toString();
    _cropdesc = desc[index];
    _cropname = _cropname.replaceAll("(", " ");
    _cropname = _cropname.replaceAll(")", " ");
  }

  Future disease_find(File image) async {
    if (image == null) return;

    await recognizeImage(image);

    setState(() {
      _image = image;
      _busy = false;
    });
    String ind;
    ind = _recognitions.map((res){
      return "${res["index"]}";
    }).toString();

    ind = ind.replaceAll("(", " ");
    ind = ind.replaceAll(")", " ");

    int index = int.parse(ind);

    _disease = _recognitions.map((res) {
      return "${res["label"]}";
    }).toString();
    _ddesc = _desc[index];
    _disease = _disease.replaceAll("(", " ");
    _disease = _disease.replaceAll(")", " ");
  }

  Future recognizeImage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 1,
      threshold: 0.5,
      imageMean: 0.0,
      imageStd: 255.0,
    );
    setState(() {
      _recognitions = recognitions;
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    // creat a list of widgets that will contain the render boxes and image to display to user


    // add the image to the list of widgets to be displayed


    // add the render boxes to the list of widgets to be displayed
    // make it so the button that classifies the image can only be seen when the image hasn't been classified yet

    //_cropname==null?
    Widget _classifyButton() {
      if (_recognitions == null) {
        return RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          color: Theme
              .of(context)
              .primaryColor,
          child: Text("   Identify Crop    ", style: buttonBig),
          onPressed: () async {
            await predictImage(widget.imageFile);
            setState(() {
              display = '\nType of crop :${_cropdesc[0]}\n\nPlantation Duration :${_cropdesc[1]}'
                  '\n\nSoil Type : ${_cropdesc[2]}\n\nTemperature : ${_cropdesc[3]}'
                  '\n\nRainfall: ${_cropdesc[4]}\n\nLocation : ${_cropdesc[5]}';
              _result = _cropname;
            });
          },
        );
      } else {
        return Container();
      }
    }
    Widget identify_disease() {
      if (_recognitions == null) {

        return RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          color: Theme
              .of(context)
              .primaryColor,
          child: Text(" Identify Disease ", style: buttonBig),
          onPressed: ()
          async {
            _model = 'assets/diseasemodel.tflite';
            loadModel().then((val) {
              setState(() {
                _busy = false;
              });
            });
            await disease_find(widget.imageFile);
            setState(() {
              display = '\nSymptoms :\n\t\t\t\t${_ddesc[0]}\n\nCausal organism : ${_ddesc[1]}'
                  '\n\nControl : \n\t\t\t\t${_ddesc[2]}';
              _result = _disease;
            });
          },
        );
      } else {
        return Container();
      }
    }

    // make it so the screen can only be seen if no logic is being performed, otherwise it might throw an error
    if (!_busy)
      return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            title: Text(
              'Crop Identification', style: TextStyle(color: Colors.white),),
            backgroundColor: Theme
                .of(context)
                .primaryColor,
          ),
          body: Column(
            children: <Widget>[
              // if the image has not been stored in the local file yet it has not been classified, so display the passed in image
              (_image == null)
                  ?
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: _imageHeight,
                    width: _imageWidth,
                    child: Image.file(widget.imageFile, fit: BoxFit.fitWidth),
                  ),
                ),
              )
              // otherwise display the stack containing the classified image and render boxes
                  :
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height - 200,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                          flex: 3,
                          child: _image == null
                              ? Text('No image selected.')
                              : Image.file(_image)
                      ),
                      Expanded(
                          flex: 1,
                          child: _image == null
                              ? Container(
                              child: Text(''), alignment: Alignment.center)
                              : Container(
                              child: Text(
                                _result, style: TextStyle(fontSize: 25.0),),
                              alignment: Alignment.center)),
                      Expanded(
                          flex: 5,
                          child: _image == null
                              ? Container(
                              child: Text(''), alignment: Alignment.center)
                              : Container(
                              child:
                              Text(display, style: TextStyle(fontSize: 15.0),),
                              ))
                    ],
                  ),
                ),
              ),
              // display the classify button
              Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _classifyButton(),
                      identify_disease()
                    ],
                  )
              ),

            ],
          )
      );
    // show a circular progress indicator if logic is being performed
    else
      return CircularProgressIndicator();
  }
}

// button that returns user to initial page so they can selected/take another picture
class NextImage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
      color: Theme
          .of(context)
          .primaryColor,
      child: Text("Next Image", style: buttonBig),
      onPressed: () {
        Navigator.pop(
          context,
          MaterialPageRoute(builder: (context) => ChooseImagePage()),
        );
      },
    );
  }
}
