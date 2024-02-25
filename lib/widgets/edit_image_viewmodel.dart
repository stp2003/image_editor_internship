import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import '../models/requestPermission.dart';
import '../models/text_info.dart';
import '../screens/edit_image_screen.dart';
import 'default_button.dart';

abstract class EditImageViewModel extends State<EditImageScreen> {
  //*** text editing controller ->
  TextEditingController textEditingController = TextEditingController();
  TextEditingController creatorText = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();

  //*** adding new test ->
  List<TextInfo> texts = [];
  int currentIndex = 0;

  //*** for saving image to gallery ->
  saveToGallery(BuildContext context) {
    if (texts.isNotEmpty) {
      screenshotController.capture().then((Uint8List? image) {
        saveImage(image!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image saved to gallery...'),
          ),
        );
      }).catchError((err) => print(err));
    }
  }

  saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = "screenshot_$time";
    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  //*** set current index ->
  setCurrentIndex(BuildContext context, index) {
    setState(
      () {
        currentIndex = index;
      },
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Selected For Styling',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  //?? for changing text color ->
  changeTextColor(Color color) {
    setState(
      () {
        texts[currentIndex].color = color;
      },
    );
  }

  increaseFontSize() {
    setState(
      () {
        texts[currentIndex].fontSize += 1;
      },
    );
  }

  decreaseFontSize() {
    setState(
      () {
        texts[currentIndex].fontSize -= 1;
      },
    );
  }

  alignLeft() {
    setState(
      () {
        texts[currentIndex].textAlign = TextAlign.left;
      },
    );
  }

  alignCenter() {
    setState(
      () {
        texts[currentIndex].textAlign = TextAlign.center;
      },
    );
  }

  alignRight() {
    setState(
      () {
        texts[currentIndex].textAlign = TextAlign.right;
      },
    );
  }

  boldText() {
    setState(
      () {
        //?? if already bolded then un-Bold it ->
        if (texts[currentIndex].fontWeight == FontWeight.bold) {
          texts[currentIndex].fontWeight = FontWeight.normal;
        } else {
          texts[currentIndex].fontWeight = FontWeight.bold;
        }
      },
    );
  }

  italicText() {
    setState(
      () {
        //?? if already italic then un-Italic it ->
        if (texts[currentIndex].fontStyle == FontStyle.italic) {
          texts[currentIndex].fontStyle = FontStyle.normal;
        } else {
          texts[currentIndex].fontStyle = FontStyle.italic;
        }
      },
    );
  }

  addLinesToText() {
    setState(
      () {
        //?? if already have new lines then un-add new lines it ->
        if (texts[currentIndex].text.contains('\n')) {
          texts[currentIndex].text =
              texts[currentIndex].text.replaceAll('\n', ' ');
        } else {
          texts[currentIndex].text =
              texts[currentIndex].text.replaceAll(' ', '\n');
        }
      },
    );
  }

  //?? deleting a text ->
  removeText(BuildContext context) {
    setState(() {
      texts.removeAt(currentIndex);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Deleted the text',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  //*** for adding new text ->
  addNewText(BuildContext context) {
    setState(
      () {
        texts.add(
          TextInfo(
            text: textEditingController.text,
            left: 0,
            top: 0,
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            fontSize: 20,
            textAlign: TextAlign.left,
          ),
        );
        Navigator.of(context).pop();
      },
    );
  }

  addNewDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Add new text..',
        ),
        content: TextField(
          controller: textEditingController,
          maxLines: 5,
          decoration: const InputDecoration(
            suffixIcon: Icon(
              Icons.edit,
              color: Colors.greenAccent,
            ),
            filled: true,
            hintText: 'Your Text here..',
          ),
        ),
        actions: <Widget>[
          DefaultButton(
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.black26,
            textColor: Colors.white,
            child: const Text('Back'),
          ),
          DefaultButton(
            onPressed: () => addNewText(context),
            color: Colors.red,
            textColor: Colors.white,
            child: const Text('Add Text'),
          ),
        ],
      ),
    );
  }
}
