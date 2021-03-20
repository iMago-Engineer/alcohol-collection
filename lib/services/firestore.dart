import 'package:alcohol_collection/models/ocyake.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final ocyakesCollection = FirebaseFirestore.instance.collection('ocyakes');

  Future<List<Ocyake>> fetchOcyakes() async {
    var ocyakes = <Ocyake>[];

    final ocyakeDocs = (await ocyakesCollection.get()).docs;
    for (var ocyakeDoc in ocyakeDocs) {
      // 今の ocyake の comments を取得する
      final commentsCollection = ocyakeDoc.reference.collection('comments');
      final commentDocs = (await commentsCollection.get()).docs;

      ocyakes.add(Ocyake.fromFirestore(ocyakeDoc, commentDocs));
    }

    return ocyakes;
  }
}
