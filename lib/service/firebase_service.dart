import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/post_nodel.dart';

class FirebaseServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addPost(String userId, PostModel postData) async {
    try {
      Map<String, dynamic> postdata = {
        'user_id': postData.userId,
        'user_name': postData.username,
        'user_image': postData.userimage,
        'time_stamp': postData.timestamp,
        'url': postData.urlList,
        'likes': [],
        'caption': postData.caption,
        'location': postData.location,
        'time_stamps': FieldValue.serverTimestamp(),
        'saved': [],
      };

      await _db.collection('posts').add(postdata);
      log('uploaded');
    } catch (e) {
      log('$e');
    }
  }

  getFeed() async {
    final respose = await _db.collection('posts').snapshots();
    return respose;
  }
}
