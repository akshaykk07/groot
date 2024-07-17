class StoryModel {
  final String user_id;
  final String user_name;
  final String user_image;
  final String type;
  final String? title;
  final String? urls;
  StoryModel({
    required this.user_id,
    required this.user_name,
    this.urls,
    this.title,
    required this.user_image,
    required this.type,
  });
}
