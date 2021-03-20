import 'dart:io';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

/// API Service
class FirebaseAPIService {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  /// storage に保存
  /// return : imageUrl or null?
  Future<String> uploadImage(String path, File file) async {
    await _initialization;

    final FirebaseStorage storage = FirebaseStorage.instance;

    Reference ref = storage.ref('${path}');

    final metadata = SettableMetadata(contentType: 'image/jpeg');
    UploadTask uploadTask = ref.putFile(File(file.path), metadata);

    final imageUrl = await (await uploadTask).ref.getDownloadURL();
    return imageUrl;
  }
}
