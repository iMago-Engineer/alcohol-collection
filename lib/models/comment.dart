class Comment {
  DateTime postedAt;
  String content;

  Comment({this.postedAt, this.content});

  @override
  String toString() => '{ Comment; postedAt: $postedAt, content: $content }';
}
