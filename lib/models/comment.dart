import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  DateTime postedAt;
  String content;

  Comment({this.postedAt, this.content});

  factory Comment.fromFirestore(Map<String, dynamic> docData) {
    return Comment(
      postedAt: (docData['postedAt'] as Timestamp).toDate(),
      content: docData['content'] as String,
    );
  }

  @override
  String toString() => '{ Comment; postedAt: $postedAt, content: $content }';
}

List<Comment> parseIntoComments(List<dynamic> firestoreDocList) {
  return firestoreDocList
      .map((firestoreDoc) =>
          Comment.fromFirestore(firestoreDoc as Map<String, dynamic>))
      .toList();
}
