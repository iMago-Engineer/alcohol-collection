import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:alcohol_collection/models/ocyake.dart';
import 'package:alcohol_collection/service_locator.dart';
import 'package:alcohol_collection/services/firebase_api.dart';
import 'package:alcohol_collection/services/line_ocr_api.dart';
import 'package:alcohol_collection/services/process_api_response.dart';
import 'package:alcohol_collection/services/style.dart';
import 'package:alcohol_collection/services/firestore.dart';
import 'package:alcohol_collection/services/navigation.dart';
import 'package:alcohol_collection/services/api.dart';
import 'package:alcohol_collection/ui/root/root_view.dart';
import 'alcohol_list_viewmodel.dart';
import '../../models/ocyake.dart';

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
            onPressed: () async {
              Ocyake new_ocyake =
                  await getOcyakeBySendImage("gallery", context, model);

              /// 確認画面
              confirmDialog(model, new_ocyake);
            },
          ),
          CupertinoDialogAction(
              child: Text("カメラ"),
              onPressed: () async {
                Ocyake new_ocyake =
                    await getOcyakeBySendImage("camera", context, model);

                /// 確認画面
                confirmDialog(model, new_ocyake);
              }),
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

/// 画像送信から Ocyake取得
Future<Ocyake> getOcyakeBySendImage(
    String type, context, AlcoholListViewModel model) async {
  final _navigator = servicesLocator<NavigationService>();

  final file = (type == 'gallery')
      ? await getImageFromGalleryOrCamera(ImageSource.gallery)
      : await getImageFromGalleryOrCamera(ImageSource.camera);

  // to Loading Screen
  _navigator.pop();
  model.setBusyToAlcoholListViewModel();

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

  String alcoholInString = ocyakeDetails[1];

  // Ocyake型に変換
  final newOcyake = new Ocyake(
    name: ocyakeDetails[3],
    type: ocyakeDetails[0],
    alcohol:
        int.parse(alcoholInString.substring(0, alcoholInString.length - 1)),
    madeIn: ocyakeDetails[2],
    likes: 0,
  );
  print(newOcyake);

  // set NotBusy
  print("setNotBusyToRootViewModel");
  model.setNotBusyToAlcoholListViewModel();

  return newOcyake;
}

/// 確認画面 -> 戻る or データ保存
Future confirmDialog(model, newOcyake) {
  final _navigator = servicesLocator<NavigationService>();
  final style = StyleService();

  print("confirmDialog");

  return showDialog(
    context: _navigator.currentContext,
    builder: (_) {
      return AlertDialog(
        title: Text('登録しますか？'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text('名前', style: style.cardSubTitle),
              Text(newOcyake.name, style: style.cardSubText),
              SizedBox(height: 8),
              Text('品目', style: style.cardSubTitle),
              Text(newOcyake.type, style: style.cardSubText),
              SizedBox(height: 8),
              Text('度数', style: style.cardSubTitle),
              Text('${newOcyake.alcohol}度', style: style.cardSubText),
              SizedBox(height: 8),
              Text('原産国', style: style.cardSubTitle),
              Text(newOcyake.madeIn, style: style.cardSubText),
            ],
          ),
        ),

        /// 確認アクション
        actions: <Widget>[
          FlatButton(
            child: Text("CANCEL"),
            onPressed: () {
              /// キャンセルなら戻る
              _navigator.pushNamedAndRemoveUntil(routeName: RootView.routeName);
            },
          ),
          FlatButton(
            child: Text("OK"),
            onPressed: () => {
              /// セーブする
              saveOcyake(model, newOcyake)
            },
          ),
        ],
      );
    },
  );
}

/// 詳細保存
Future saveOcyake(model, newOcyake) async {
  final _navigator = servicesLocator<NavigationService>();
  final _api = servicesLocator<APIService>();
  final _firestore = servicesLocator<FirestoreService>();

  // to Loading Screen
  _navigator.pop();
  model.setBusyToAlcoholListViewModel();

  // firestore に保存されているかどうかを確認する
  final photoTakenBefore = await _firestore.ocyatePhotoTakenBefore(newOcyake);
  if (photoTakenBefore) {
    print("numberOfOcyakePhotosTaken");
    // numberOfOcyakePhotosTaken を増やす
    await _firestore.incrementNumberOfOcyakePhotosTaken(newOcyake);
  } else {
    // おちゃけの画像を検索 / URL をセット
    newOcyake.imageUrl = await _api.getImageFromGoogle(newOcyake.name);

    // firestore に保存
    _firestore.postOcyake(newOcyake);
  }

  // Navigation to Root
  // データ取得しなおすために？？
  _navigator.pushNamedAndRemoveUntil(routeName: RootView.routeName);
}
