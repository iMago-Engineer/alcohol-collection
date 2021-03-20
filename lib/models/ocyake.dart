import 'package:alcohol_correction/models/comment.dart';

class Ocyake {
  String name;
  String type;
  int alcohol;
  String madeIn;
  int likes;
  List<Comment> comments;
  String imageUrl;

  Ocyake(
      {this.name,
      this.type,
      this.alcohol,
      this.madeIn,
      this.likes,
      this.comments,
      this.imageUrl});

  @override
  String toString() =>
      '{ Ocyake; name: $name, type: $type, alcohol: $alcohol, madeIn: $madeIn, likes: $likes, comments: $comments, imageUrl: $imageUrl }';
}
