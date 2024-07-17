import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/model/story_model.dart';

import 'package:socialapp/widgets/app_text.dart';

import '../const/color.dart';
import '../controllor/user_controllor.dart';
import '../model/feed_model.dart';

import '../widgets/feed_widgets.dart';
import '../widgets/story_section.dart';
import '../widgets/story_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  List name = ['Arjun', 'Akshay kk', 'Amal', '_joythi'];
  GetuserData userData = Get.find();
  @override
  Widget build(BuildContext context) {
    log('${DateTime.now()}');
    userData.getUservalue();
    log('${userData.id}');
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: customBlack2,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: customBlack2,
        title: const AppText(
          name: 'DuggOut',
          size: 18,
        ),
        actions: [
          const Icon(
            Icons.favorite_border_outlined,
            color: whiteone,
          ),
          SizedBox(
            width: size.width * .04,
          ),
          const Icon(
            Icons.message_outlined,
            color: whiteone,
          ),
          SizedBox(
            width: size.width * .04,
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: size.height * 0.13,
            //   child: Row(
            //     children: [
            //       // UserStory(size: size),
            //       Expanded(
            //         child: StreamBuilder(
            //             stream: FirebaseFirestore.instance
            //                 .collection('stories')
            //                 .snapshots(),
            //             builder: (context, snapshot) {
            //               if (snapshot.connectionState ==
            //                   ConnectionState.waiting) {
            //                 return const Center(
            //                     child: CircularProgressIndicator(
            //                   strokeWidth: 2,
            //                   color: customPurple,
            //                 ));
            //               }

            //               if (snapshot.hasError) {
            //                 return Center(
            //                     child: Text('Error: ${snapshot.error}'));
            //               }

            //               if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            //                 return const Center(child: Text('No posts found'));
            //               }

            //               final story = snapshot.data!.docs;
            //               var data;
            //               return ListView.builder(
            //                 scrollDirection: Axis.horizontal,
            //                 itemBuilder: (context, index) {
            //                   if (story[index]['type'] == 'text') {
            //                     data = StoryModel(
            //                         user_id: story[index]['user_id'],
            //                         user_name: story[index]['user_name'],
            //                         title: story[index]['title'],
            //                         user_image: story[index]['user_image'],
            //                         type: story[index]['type']);
            //                   } else {
            //                     data = StoryModel(
            //                         user_id: story[index]['user_id'],
            //                         user_name: story[index]['user_name'],
            //                         urls: story[index]['url'],
            //                         user_image: story[index]['user_image'],
            //                         type: story[index]['type']);
            //                   }
            //                   return StorySection(
            //                     size: size,
            //                     name: story[index]['user_name'],
            //                     image: story[index]['user_image'],
            //                     onview: () {
            //                       Navigator.pushNamed(context, 'viewstory',
            //                           arguments: {'story': data});
            //                     },
            //                   );
            //                 },
            //                 itemCount: story.length,
            //               );
            //             }),
            //       ),
            //     ],
            //   ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('time_stamp', descending: true)
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
                  return const Center(child: Text('No posts found'));
                }

                final posts = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    List likedBy = posts[index]['likes'];
                    int likeCount = likedBy.length + 1;
                    bool like = false;
                    if (likedBy.contains(userData.id.value)) {
                      like = true;
                    } else {
                      like = false;
                    }
                    List saved = posts[index]['saved'];
                    bool isSave = false;
                    if (saved.contains(userData.id.value)) {
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
              })
        ],
      ),
    );
  }
}
