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
    final ocyakeDocs = (await ocyakesCollection.get()).docs;

    return ocyakeDocs
        .map((ocyakeDoc) => Ocyake.fromFirestore(ocyakeDoc.data()))
        .toList();
  }
}
