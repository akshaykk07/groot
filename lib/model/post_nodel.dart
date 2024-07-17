import 'package:get/get_connect/http/src/request/request.dart';

class PostModel {
  final String userId;
  final List urlList;
  final String timestamp;
  final String caption;
  final String location;
  final String username;
  final String userimage;
  final List<String> likedList;

  PostModel({
    required this.userId,
    required this.urlList,
    required this.timestamp,
    required this.caption,
    required this.location,
    required this.likedList,
    required this.username,
    required this.userimage,
  });
}
