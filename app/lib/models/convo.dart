class Convo {
  Convo({
    required this.who,
    required this.when,
    required this.last,
    this.unread = false,
  });

  final String who;
  final String when;
  final String last;
  final bool unread;
}
