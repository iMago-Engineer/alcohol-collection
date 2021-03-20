import 'package:alcohol_collection/models/comment.dart';

class Ocyake {
  String name;
  String type;
  int alcohol;
  String madeIn;
  int likes;
  List<Comment> comments;
  String imageUrl;

  Ocyake({
    this.name,
    this.type,
    this.alcohol,
    this.madeIn,
    this.likes,
    this.comments,
    this.imageUrl,
  });

  factory Ocyake.fromFirestore(Map<String, dynamic> firestoreDoc) {
    return Ocyake(
      name: firestoreDoc['name'] as String,
      type: firestoreDoc['type'] as String,
      alcohol: firestoreDoc['alcohol'] as int,
      madeIn: firestoreDoc['madeIn'] as String,
      likes: firestoreDoc['likes'] as int,
      comments: parseIntoComments(firestoreDoc['comments'] as List<dynamic>),
      imageUrl: firestoreDoc['imageUrl'] as String,
    );
  }

  @override
  String toString() =>
      '{ Ocyake; name: $name, type: $type, alcohol: $alcohol, madeIn: $madeIn, likes: $likes, comments: $comments, imageUrl: $imageUrl }';
}
