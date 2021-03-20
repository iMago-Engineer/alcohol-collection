import 'package:alcohol_collection/models/ocyake.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final ocyakesCollection = FirebaseFirestore.instance.collection('ocyakes');

  Future<void> test() async {
    final ocyakesQuerySnapshot = await ocyakesCollection.get();
    final ocyakesQueryDocumentSnapshot = ocyakesQuerySnapshot.docs;

    for (var ocyakeQueryDocumentSnapshot in ocyakesQueryDocumentSnapshot) {
      print(Ocyake.fromFirestore(ocyakeQueryDocumentSnapshot.data()));
    }
  }

  Future<List<Ocyake>> fetchOcyakes() async {
    var ocyakes = <Ocyake>[];

    final ocyakeDocs = (await ocyakesCollection.get()).docs;
    for (var ocyakeDoc in ocyakeDocs) {
      // 今の ocyake の comments を取得する
      final commentsCollection = ocyakeDoc.reference.collection('comments');
      final commentDocs = (await commentsCollection.get()).docs;
      final comments =
          commentDocs.map((commentDoc) => commentDoc.data()).toList();

      // comments のデータを ocyake のデータと統合させる
      var ocyakeDocData = ocyakeDoc.data();
      ocyakeDocData.addAll({'comments': comments});

      ocyakes.add(Ocyake.fromFirestore(ocyakeDocData));
    }

    return ocyakes;
  }
}
