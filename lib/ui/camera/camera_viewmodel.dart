import 'package:stacked/stacked.dart';
import 'package:image_picker/image_picker.dart';

class CameraViewModel extends BaseViewModel {
  final picker = ImagePicker();

  Future getImageFromGalleryOrCamera(source) async {
    // 画像が重すぎるため圧縮
    return await picker.getImage(source: source, imageQuality: 30);
  }

  Future imageFunction(String type) async {
    setBusy(true);

    var file;
    if (type == "gallery") {
      file = await getImageFromGalleryOrCamera(ImageSource.gallery);
    } else {
      file = await getImageFromGalleryOrCamera(ImageSource.camera);
    }

    setBusy(false);
    // final imageUrl = await uploadImageToFirebase(file);
    // if (imageUrl != null) {
    //   await _api.createImage(wish.id, imageUrl);
    //   wish.imageUrl = imageUrl;
    // } else {
    //   _navigator.pushNamedAndRemoveUntil(routeName: '/error');
    // }
    // _navigator.pushNamedAndRemoveUntil(routeName: '/root');
  }
}
