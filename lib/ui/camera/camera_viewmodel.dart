import 'dart:io';
import 'package:stacked/stacked.dart';
import 'package:image_picker/image_picker.dart';
import 'package:alcohol_collection/service_locator.dart';
import 'package:alcohol_collection/services/firebase_api.dart';

class CameraViewModel extends BaseViewModel {
  final _firebase_api = servicesLocator<FirebaseAPIService>();
  final picker = ImagePicker();

  //  画像取得
  Future getImageFromGalleryOrCamera(source) async {
    // 画像が重すぎるため圧縮
    return await picker.getImage(source: source, imageQuality: 30);
  }

  // Firebase に送る処理
  Future uploadImageToFirebase(path, file) async {
    return await _firebase_api.uploadImage(path, File(file.path));
  }

  // 画像選択 & Firebase 送信
  Future imageFunction(String type) async {
    setBusy(true);

    var file;
    if (type == "gallery") {
      file = await getImageFromGalleryOrCamera(ImageSource.gallery);
    } else {
      file = await getImageFromGalleryOrCamera(ImageSource.camera);
    }

    final imageUrl = await uploadImageToFirebase("path/", file);
    if (imageUrl != null) {
      // pass
    } else {
      // pass
    }

    setBusy(false);
  }
}
