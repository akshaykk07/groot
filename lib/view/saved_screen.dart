import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/widgets/feed_widgets.dart';

import '../const/color.dart';
import '../controllor/user_controllor.dart';
import '../widgets/app_text.dart';

class SavedScreen extends StatelessWidget {
  SavedScreen({super.key});
  GetuserData getuserData = Get.find();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    getuserData.getUservalue();
    return Scaffold(
      backgroundColor: customBlack2,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: whiteone),
        surfaceTintColor: Colors.transparent,
        backgroundColor: customBlack2,
        title: const AppText(
          name: 'Saved',
          size: 18,
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .where('saved', arrayContains: getuserData.id.value)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 2,
                color: customPurple,
              ));
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                  child: AppText(
                name: 'No posts found',
                colors: whiteone,
              ));
            }
            final posts = snapshot.data!.docs;
            return ListView.builder(
              itemBuilder: (context, index) {
                List saved = posts[index]['saved'];
                List likedBy = posts[index]['likes'];
                int likeCount = likedBy.length + 1;
                bool like = false;
                if (likedBy.contains(getuserData.id.value)) {
                  like = true;
                } else {
                  like = false;
                }
                bool isSave = false;
                if (saved.contains(getuserData.id.value)) {
                  isSave = true;
                } else {
                  isSave = false;
                }
                return FeedWidget(
                  size: size,
                  username: posts[index]['user_name'],
                  profileimage: posts[index]['user_image'],
                  postimage: posts[index]['url'],
                  caption: posts[index]['caption'],
                  commentcount: '2',
                  likecount: likeCount.toString(),
                  timestamp: posts[index]['time_stamp'],
                  click: () {
                    Navigator.pushNamed(context, 'friend',
                        arguments: {'friend_id': posts[index]['user_id']});
                  },
                  isLike: like,
                  postid: posts[index].id,
                  isSaved: isSave,
                );
              },
              itemCount: posts.length,
            );
          }),
    );
  }
}
