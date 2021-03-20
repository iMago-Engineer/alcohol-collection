import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/cupertino.dart';

import 'camera_viewmodel.dart';

class CameraView extends StatelessWidget {
  static const routeName = '/camera';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CameraViewModel>.reactive(
        builder: (context, model, child) => Scaffold(body: _CameraScreen()),
        viewModelBuilder: () => CameraViewModel());
  }
}

class _CameraScreen extends ViewModelWidget<CameraViewModel> {
  @override
  Widget build(BuildContext context, CameraViewModel model) {
    return Container(
      child: Scaffold(
        body: Text('camera'),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showImagePickerDialog(context, model);
          },
          child: Icon(Icons.camera),
        ),
      ),
    );
  }
}

Future showImagePickerDialog(context, CameraViewModel model) {
  return showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text("おちゃけ PIC"),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text("画像選択"),
            onPressed: () => model.imageFunction("gallery"),
          ),
          CupertinoDialogAction(
              child: Text("カメラ"),
              onPressed: () => model.imageFunction("camera")),
        ],
      );
    },
  );
}
