class ForumThread {
  ForumThread({
    required this.id,
    required this.tag,
    required this.title,
    required this.by,
    required this.when,
    required this.replies,
    required this.likes,
  });

  final String id;
  final String tag;
  final String title;
  final String by;
  final String when;
  final int replies;
  final int likes;
}

class Post {
  Post({
    required this.who,
    required this.when,
    this.op = false,
    required this.likes,
    required this.text,
    this.spot,
  });

  final String who;
  final String when;
  final bool op;
  final int likes;
  final String text;
  final String? spot;
}
