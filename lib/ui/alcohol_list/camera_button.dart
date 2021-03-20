import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:alcohol_collection/models/ocyake.dart';
import 'package:alcohol_collection/service_locator.dart';
import 'package:alcohol_collection/services/firebase_api.dart';
import 'package:alcohol_collection/services/line_ocr_api.dart';
import 'package:alcohol_collection/services/process_api_response.dart';
import 'package:alcohol_collection/services/firestore.dart';
import 'package:alcohol_collection/services/navigation.dart';
import 'package:alcohol_collection/ui/root/root_viewmodel.dart';
import 'package:alcohol_collection/ui/root/root_view.dart';

import 'alcohol_list_viewmodel.dart';

class CameraButton extends StatelessWidget {
  final AlcoholListViewModel model;
  CameraButton({this.model});

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
            showImagePickerDialog(context, model);
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

Future showImagePickerDialog(context, AlcoholListViewModel model) {
  return showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text("おちゃけ PIC"),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text("画像選択"),
            onPressed: () => imageFunction("gallery", model),
          ),
          CupertinoDialogAction(
              child: Text("カメラ"),
              onPressed: () => imageFunction("camera", model)),
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

Future imageFunction(String type, AlcoholListViewModel model) async {
  final _navigator = servicesLocator<NavigationService>();

  final file = (type == 'gallery')
      ? await getImageFromGalleryOrCamera(ImageSource.gallery)
      : await getImageFromGalleryOrCamera(ImageSource.camera);

  // to Loading Screen
  _navigator.pop();

  // Firebase に送る処理
  // TODO: FixPATH
  final imageUrl = await servicesLocator<FirebaseAPIService>()
      .uploadImage("path/", File(file.path));
  print(imageUrl);

  // LINEOCR に送る処理
  // return response from LINEOCR
  final lineOcrResponse =
      await servicesLocator<LINEOCRService>().requestToLINEOcr(imageUrl);

  // LINEOCR の response を処理する
  // return [type, alcohol, madeIn, serch_term];
  final ocyakeDetails =
      servicesLocator<ProcessAPIService>().inferBasicData(lineOcrResponse.body);
  print(ocyakeDetails);

  int alcoholLength = ocyakeDetails[1].length;
  ocyakeDetails[1] = ocyakeDetails[1].substring(0, alcoholLength - 1);
  int alcoholInt = int.parse(ocyakeDetails[1]);

  // Ocyake型に変換
  final newOcyake = new Ocyake(
    docId: "",
    name: ocyakeDetails[3],
    type: ocyakeDetails[0],
    alcohol: alcoholInt,
    madeIn: ocyakeDetails[2],
    likes: 0,
    comments: [],
    imageUrl: "",
  );
  print(newOcyake);

  final _firestore = servicesLocator<FirestoreService>();

  // firestore に保存されているかどうかを確認する
  final photoTakenBefore = await _firestore.ocyatePhotoTakenBefore(newOcyake);
  if (photoTakenBefore) {
    // numberOfOcyakePhotosTaken を増やす
    await _firestore.incrementNumberOfOcyakePhotosTaken(newOcyake);
  } else {
    // firestore に保存
    await _firestore.postOcyake(newOcyake);
  }

  // Navigation to Root
  // データ取得しなおすために？？
  _navigator.pushNamedAndRemoveUntil(routeName: RootView.routeName);
}
