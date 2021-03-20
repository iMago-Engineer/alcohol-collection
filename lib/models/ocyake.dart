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

  factory Ocyake.fromFirestore(Map<String, dynamic> docData) {
    return Ocyake(
      name: docData['name'] as String,
      type: docData['type'] as String,
      alcohol: docData['alcohol'] as int,
      madeIn: docData['madeIn'] as String,
      likes: docData['likes'] as int,
      comments: parseIntoComments(docData['comments'] as List<dynamic>),
      imageUrl: docData['imageUrl'] as String,
    );
  }

  @override
  String toString() =>
      '{ Ocyake; name: $name, type: $type, alcohol: $alcohol, madeIn: $madeIn, likes: $likes, comments: $comments, imageUrl: $imageUrl }';
}
