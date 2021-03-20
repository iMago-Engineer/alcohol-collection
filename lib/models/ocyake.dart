import 'package:alcohol_collection/models/comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ocyake {
  String docId;
  String name;
  String type;
  int alcohol;
  String madeIn;
  int likes;
  List<Comment> comments;
  String imageUrl;

  Ocyake({
    this.docId,
    this.name,
    this.type,
    this.alcohol,
    this.madeIn,
    this.likes,
    this.comments,
    this.imageUrl,
  });

  factory Ocyake.fromFirestore(
      QueryDocumentSnapshot doc, List<QueryDocumentSnapshot> commentDocs) {
    final docData = doc.data();

    return Ocyake(
      docId: doc.id ?? '',
      name: docData['name'] as String ?? '',
      type: docData['type'] as String ?? '',
      alcohol: docData['alcohol'] as int ?? 0,
      madeIn: docData['madeIn'] as String ?? '',
      likes: docData['likes'] as int ?? 1,
      comments: parseIntoComments(commentDocs),
      imageUrl: docData['imageUrl'] as String ?? '',
    );
  }

  Map<String, dynamic> toFirestoreDocData() {
    // TODO: imageUrl いつ追加する?
    // NOTE: おっくんのアルゴリズムと合わせて使う必要があるかも
    return {
      'name': name,
      'type': type,
      'alcohol': alcohol,
      'madeIn': madeIn,
      'likes': likes,
    };
  }

  @override
  String toString() =>
      '{ Ocyake; docId: $docId, name: $name, type: $type, alcohol: $alcohol, madeIn: $madeIn, likes: $likes, comments: $comments, imageUrl: $imageUrl }';
}
