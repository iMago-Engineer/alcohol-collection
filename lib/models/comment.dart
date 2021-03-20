class Comment {
  DateTime postedAt;
  String content;

  Comment({this.postedAt, this.content});

  factory Comment.fromFirestore(Map<String, dynamic> firestoreDoc) {
    return Comment(
      postedAt: firestoreDoc['postedAt'] as DateTime,
      content: firestoreDoc['content'] as String,
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
