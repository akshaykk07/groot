class FeedModel {
  FeedModel({
    required this.profileimage,
    required this.postimage,
    required this.caption,
    required this.likecount,
    required this.commentcount,
    required this.timestamp,
    required this.username,
    required this.isLike,
    required this.isSaved,
    this.postid = '0',
  });
  final String postid;
  final String username;
  final String profileimage;
  final List postimage;
  final String caption;
  final String likecount;
  final String commentcount;
  final String timestamp;
  final bool isLike;
  final bool isSaved;
}
