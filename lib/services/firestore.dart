import 'package:alcohol_collection/models/comment.dart';
import 'package:alcohol_collection/models/ocyake.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const _ocyakesCollectionName = 'ocyakes';
const _commentsCollectionName = 'comments';

class FirestoreService {
  final ocyakesCollection =
      FirebaseFirestore.instance.collection(_ocyakesCollectionName);

  Future<List<Ocyake>> fetchOcyakes() async {
    var ocyakes = <Ocyake>[];

    final ocyakeDocs = (await ocyakesCollection.get()).docs;
    for (var ocyakeDoc in ocyakeDocs) {
      // 今の ocyake の comments を取得する
      final commentsCollection =
          ocyakeDoc.reference.collection(_commentsCollectionName);
      final commentDocs = (await commentsCollection.get()).docs;

      ocyakes.add(Ocyake.fromFirestore(ocyakeDoc, commentDocs));
    }

    return ocyakes;
  }

  Future<void> postOcyake(Ocyake ocyake) async {
    print("start: postOcyake");
    await ocyakesCollection.add(ocyake.toFirestoreDocData());
  }

  Future<void> postOcyakeComment(Ocyake ocyake, Comment commentToAdd) async {
    final ocyakeDoc = ocyakesCollection.doc(ocyake.docId);
    final commentsCollection = ocyakeDoc.collection(_commentsCollectionName);

    await commentsCollection.add(commentToAdd.toFirestoreDocData());
  }

  Future<void> updateRate(Ocyake ocyake, int newRate) async {
    final dataToUpdate = {'likes': newRate};
    final likesDoc = ocyakesCollection.doc(ocyake.docId);

    await likesDoc.update(dataToUpdate);
  }

  Future<bool> ocyatePhotoTakenBefore(Ocyake ocyake) async {
    final ocyakeDocs =
        (await ocyakesCollection.where('name', isEqualTo: ocyake.name).get())
            .docs;

    return ocyakeDocs.length >= 1;
  }

  Future<void> incrementNumberOfOcyakePhotosTaken(Ocyake ocyake) async {
    final ocyakeDoc = ocyakesCollection.doc(ocyake.docId);

    await ocyakeDoc.update({'numberOfPhotoTaken': FieldValue.increment(1)});
  }
}
