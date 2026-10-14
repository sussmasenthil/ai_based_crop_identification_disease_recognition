import 'package:flutter/material.dart';
import 'classificationPage.dart';
import 'main.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ChooseImagePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Crop Identification', style: TextStyle(color: Colors.white)),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Choose an Image to Get Started", style: title),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  // buttons allowing user to choose between selecting an image on their phone or taking an image
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ImageButton(icon: Icons.camera_alt, label: 'Camera', imageSource: ImageSource.camera),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ImageButton(icon: Icons.image, label: 'Gallery', imageSource: ImageSource.gallery),
                      )
                    ],
                  ),
                )
              ],
            )
        )
    );
  }
}

// custom button that lets user select/take image using imagepicker plugin
class ImageButton extends StatefulWidget {

  // pass in the icon, label, and source so the widget can be reused for both camera and gallery
  final icon;
  final label;
  final imageSource;

  const ImageButton({Key key, this.icon, this.label, this.imageSource}) : super(key: key);

  @override
  _ImageButtonState createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {

  File imageFile;

  // select/take image depending on source using imagepicker plugin
  Future _selectImage(ImageSource source) async {
    var selected = await ImagePicker.pickImage(source: source);

    setState(() {
      imageFile = selected;
    });

  }

  @override
  Widget build(BuildContext context) {
    // button ui
    return RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(widget.icon, size: 70.0, color: Colors.white,),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(widget.label, style: buttonSmall),
            )
          ],
        ),
        onPressed: () async {
          // select the image when the button is pressed, then when that is completed, navigate to the classification page
          await _selectImage(widget.imageSource);
          if (imageFile != null)
            Navigator.push(context, MaterialPageRoute(builder: (context) => Classification(imageFile: imageFile)));
        }
    );
  }
}