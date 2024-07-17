import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'package:socialapp/const/color.dart';
import 'package:socialapp/controllor/basic_controllor.dart';
import 'package:socialapp/model/feed_model.dart';
import 'package:socialapp/view/post_view.dart';
import 'package:socialapp/widgets/app_text.dart';

import '../controllor/user_controllor.dart';

class UserProfile extends StatelessWidget {
  UserProfile({super.key});
  List images = [
    'assets/men1.jpg',
    'assets/girl.jpg',
    'assets/men1.jpg',
    'assets/girl.jpg',
    'assets/men1.jpg',
    'assets/girl.jpg'
  ];
  List post = [];
  List followers = [];
  List following = [];
  GetuserData userData = Get.find();
  BasicControllors basicControllors = Get.find();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    userData.getUservalue();

    return Scaffold(
      backgroundColor: customBlack2,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: customBlack2,
        title: const AppText(
          name: 'Profile',
          size: 18,
        ),
        actions: [BottomSettings(context)],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('user_registrtion')
              .doc(userData.id.value)
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

            if (!snapshot.hasData) {
              return const Center(
                  child: Text(
                'No posts found',
                style: TextStyle(color: Colors.grey),
              ));
            }

            final user = snapshot.data;
            followers = user!['followers'];
            following = user!['following'];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(user['user_image']),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const AppText(name: 'Posts'),
                              Obx(
                                () => AppText(
                                    name: basicControllors.postCount.value
                                        .toString()),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, 'followers');
                                  },
                                  child: const AppText(name: 'Followers')),
                              AppText(name: followers.length.toString())
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, 'following');
                                  },
                                  child: const AppText(name: 'Following')),
                              AppText(name: following.length.toString())
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.width * 0.03,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.03,
                          ),
                          AppText(name: user['user_name'].toString()),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.02),
                  child: const AppText(
                    name: 'Photos',
                    size: 18,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Expanded(
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where(
                          'user_id',
                          isEqualTo: userData.id.value,
                        )
                        .orderBy('time_stamps', descending: true)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: customPurple,
                        ));
                      }

                      if (snapshot.hasError) {
                        log('${snapshot.error}');
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text(
                          'No posts found',
                          style: TextStyle(color: white),
                        ));
                      }

                      final userPosts = snapshot.data!.docs;

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        basicControllors.chnageCount(userPosts.length);
                      });
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                        ),
                        itemCount: userPosts.length,
                        itemBuilder: (context, index) {
                          List likedBy = userPosts[index]['likes'];
                          int likeCount = likedBy.length + 1;
                          bool like = false;
                          if (likedBy.contains(userData.id.value)) {
                            like = true;
                          } else {
                            like = false;
                          }
                          FeedModel newPost = FeedModel(
                              postid: userPosts[index].id,
                              profileimage: userPosts[index]['user_image'],
                              postimage: userPosts[index]['url'],
                              caption: userPosts[index]['caption'],
                              likecount: likeCount.toString(),
                              commentcount: '2',
                              timestamp: userPosts[index]['time_stamp'],
                              username: userPosts[index]['user_name'],
                              isLike: like,
                              isSaved: false);

                          // Check if the post already exists in the list
                          bool postExists = basicControllors.postList
                              .any((post) => post.postid == newPost.postid);

                          // If the post does not exist, add it to the list
                          if (!postExists) {
                            basicControllors.postList.add(newPost);
                          }

                          var postData = userPosts[index];
                          var imageUrlList = postData['url'] as List<dynamic>?;

                          // Check if the imageUrlList exists and has elements
                          if (imageUrlList != null && imageUrlList.isNotEmpty) {
                            var imageUrl = imageUrlList[0]
                                .toString(); // Safely access the first URL
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PostView(
                                        index: index,
                                      ),
                                    ));
                              },
                              child: Container(
                                color: whiteone,
                                child: CachedNetworkImage(
                                  fit: BoxFit.fitHeight,
                                  imageUrl: imageUrl,
                                  placeholder: (context, url) => Container(
                                    color: customBlack1,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              color: whiteone,
                              child: const Center(
                                  child: Text('No image available')),
                            );
                          }
                        },
                      );
                    },
                  ),
                )
              ],
            );
          }),
    );
  }

  IconButton BottomSettings(BuildContext context) {
    return IconButton(
        onPressed: () {
          showModalBottomSheet<void>(
            backgroundColor: customBlack1,
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: const AppText(name: 'Edit Profile'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const AppText(name: 'Saved'),
                        onTap: () {
                          Navigator.pushNamed(context, 'saved');
                        },
                      ),
                      ListTile(
                        title: const AppText(name: 'Settings'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const AppText(name: 'LogOut'),
                        onTap: () {},
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        icon: const Icon(
          Icons.menu,
          color: whiteone,
        ));
  }
}


 