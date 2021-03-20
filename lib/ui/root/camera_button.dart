import 'package:flutter/material.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:alcohol_collection/models/ocyake.dart';
import 'package:alcohol_collection/service_locator.dart';
import 'package:alcohol_collection/services/firebase_api.dart';
import 'package:alcohol_collection/services/line_ocr_api.dart';
import 'package:alcohol_collection/services/process_api_response.dart';
import 'package:alcohol_collection/services/firestore.dart';
import 'package:flutter/cupertino.dart';

class CameraButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      margin: EdgeInsets.only(bottom: 12),
      child: FittedBox(
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            showImagePickerDialog(context);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.camera_outlined, size: 30)],
          ),
        ),
      ),
    );
  }
}

Future showImagePickerDialog(context) {
  return showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text("おちゃけ PIC"),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text("画像選択"),
            onPressed: () => imageFunction("gallery"),
          ),
          CupertinoDialogAction(
              child: Text("カメラ"), onPressed: () => imageFunction("camera")),
        ],
      );
    },
  );
}

//  画像取得
Future getImageFromGalleryOrCamera(source) async {
  final picker = ImagePicker();
  // 画像が重すぎるため圧縮
  return await picker.getImage(source: source, imageQuality: 30);
}

Future imageFunction(String type) async {
  final _line_ocr_api = servicesLocator<LINEOCRService>();
  final _process_api = servicesLocator<ProcessAPIService>();
  final _firebase_api = servicesLocator<FirebaseAPIService>();

  var file;
  if (type == "gallery") {
    file = await getImageFromGalleryOrCamera(ImageSource.gallery);
  } else {
    file = await getImageFromGalleryOrCamera(ImageSource.camera);
  }

  // Firebase に送る処理
  // TODO: FixPATH
  final imageUrl = await _firebase_api.uploadImage("path/", File(file.path));
  print(imageUrl);

  // LINEOCR に送る処理
  // return response from LINEOCR
  final line_ocr_response = await _line_ocr_api.requestToLINEOcr(imageUrl);

  // LINEOCR の response を処理する
  // return (type, alcohol, madeIn, serch_term);
  final ocyake_details = _process_api.inferBasicData(line_ocr_response.body);
  print(ocyake_details);

  int alcohol_length = ocyake_details[1].length;
  ocyake_details[1] = ocyake_details[1].substring(0, alcohol_length - 1);
  int alcohol_int = int.parse(ocyake_details[1]);

  // Ocyake型に変換
  final new_ocyake = new Ocyake(
    docId: "",
    name: ocyake_details[3],
    type: ocyake_details[0],
    alcohol: alcohol_int,
    madeIn: ocyake_details[2],
    likes: 0,
    comments: [],
    imageUrl: "",
  );
  print(new_ocyake);

  // firestore に保存
  await servicesLocator<FirestoreService>().postOcyake(new_ocyake);
}
