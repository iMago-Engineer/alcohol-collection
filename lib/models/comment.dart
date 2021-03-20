import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String docId;
  DateTime postedAt;
  String content;

  Comment({this.docId, this.postedAt, this.content});

  factory Comment.fromFirestore(QueryDocumentSnapshot doc) {
    final docData = doc.data();

    return Comment(
      docId: doc.id ?? '',
      postedAt: (docData['postedAt'] as Timestamp).toDate() ?? DateTime.now(),
      content: docData['content'] as String ?? '',
    );
  }

  Map<String, dynamic> toFirestoreDocData() {
    return {
      'postedAt': Timestamp.fromDate(postedAt),
      'content': content,
    };
  }

  @override
  String toString() =>
      '{ Comment; docId: $docId, postedAt: $postedAt, content: $content }';
}

List<Comment> parseIntoComments(List<QueryDocumentSnapshot> firestoreDocList) {
  if (firestoreDocList.length <= 0) return [];

  return firestoreDocList
      .map((firestoreDoc) => Comment.fromFirestore(firestoreDoc))
      .toList();
}
