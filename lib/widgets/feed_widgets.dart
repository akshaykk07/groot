import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:readmore/readmore.dart';

import '../const/color.dart';
import '../controllor/user_controllor.dart';
import 'app_text.dart';

class FeedWidget extends StatelessWidget {
  FeedWidget({
    super.key,
    required this.size,
    required this.profileimage,
    required this.postimage,
    required this.caption,
    required this.likecount,
    required this.commentcount,
    required this.timestamp,
    required this.username,
    required this.click,
    required this.isLike,
    required this.postid,
    required this.isSaved,
    this.isHome = false,
  });
  final String postid;
  final Size size;
  final String username;
  final String profileimage;
  final List postimage;
  final String caption;
  final String likecount;
  final String commentcount;
  final String timestamp;
  final void Function() click;

  final bool isLike;
  final bool isSaved;
  final bool isHome;
  final commentControllor = TextEditingController();
  GetuserData userData = Get.find();

  @override
  Widget build(BuildContext context) {
    DateTime timestamps = DateTime.parse(timestamp);
    String formattedTime = timeago.format(timestamps);
    log('feed ${userData.id}');
    final sizes = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
          top: size.height * 0.03,
          left: size.width * 0.02,
          right: size.width * 0.02),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: customBlack1),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(profileimage),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      name: username,
                      size: 14,
                    ),
                    AppText(
                      name: formattedTime,
                      colors: Colors.grey,
                      size: 9,
                    ),
                  ],
                ),
                trailing: const Icon(
                  Icons.more_vert_outlined,
                  color: whiteone,
                ),
                onTap: click,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              SizedBox(
                height: size.height * 0.005,
              ),
              SizedBox(
                height: size.height *
                    .4, // Adjust this to your preferred default height
                width: size.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.01),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              color: whiteone,
                              width: sizes.width - 40,
                              child: InkWell(
                                splashColor: Colors.transparent,
                                onDoubleTap: () {
                                  if (isLike == true) {
                                    FirebaseFirestore.instance
                                        .collection('posts')
                                        .doc(postid)
                                        .update({
                                      'likes': FieldValue.arrayRemove(
                                          [userData.id.value]),
                                    });
                                  } else {
                                    FirebaseFirestore.instance
                                        .collection('posts')
                                        .doc(postid)
                                        .update({
                                      'likes': FieldValue.arrayUnion(
                                          [userData.id.value]),
                                    });
                                  }
                                },
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return CachedNetworkImage(
                                      fit: BoxFit.contain,
                                      imageUrl: postimage[index],
                                      placeholder: (context, url) => Container(
                                        color: customBlack1,
                                        height: sizes.height,
                                        width: sizes.width,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: customPurple,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                              child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.error),
                                          AppText(
                                            name: "Something Wrong Try Again",
                                            colors: customBlack1,
                                          )
                                        ],
                                      )),
                                      imageBuilder: (context, imageProvider) {
                                        return Image(
                                          image: imageProvider,
                                          fit: BoxFit.fitHeight,
                                          height: constraints.maxHeight,
                                          width: constraints.maxWidth,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          postimage.length > 1
                              ? Positioned(
                                  right: 10,
                                  top: 10,
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.copy,
                                        color: customBlack1,
                                        size: 14,
                                      ),
                                      Row(
                                        children: [
                                          AppText(
                                            name: '${index + 1}/',
                                            size: 10,
                                            colors: customBlack1,
                                          ),
                                          AppText(
                                            name: postimage.length.toString(),
                                            size: 10,
                                            colors: customBlack1,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    );
                  },
                  itemCount: postimage.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                AppText(
                                  name: likecount,
                                  size: 10,
                                ),
                                InkWell(
                                    onTap: () {
                                      if (isLike == true) {
                                        FirebaseFirestore.instance
                                            .collection('posts')
                                            .doc(postid)
                                            .update({
                                          'likes': FieldValue.arrayRemove(
                                              [userData.id.value]),
                                        });
                                      } else {
                                        FirebaseFirestore.instance
                                            .collection('posts')
                                            .doc(postid)
                                            .update({
                                          'likes': FieldValue.arrayUnion(
                                              [userData.id.value]),
                                        });
                                      }
                                    },
                                    child: isLike
                                        ? const Icon(
                                            Icons.favorite,
                                            color: customRed,
                                          )
                                        : const Icon(
                                            Icons.favorite_border,
                                            color: whiteone,
                                          )),
                              ],
                            ),
                            SizedBox(
                              width: size.width * 0.04,
                            ),
                            Column(
                              children: [
                                AppText(
                                  name: commentcount,
                                  size: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      backgroundColor: customBlack1,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          width: size.width,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      AppText(name: 'Comments'),
                                                      Icon(
                                                        Icons
                                                            .info_outline_rounded,
                                                        color: whiteone,
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(
                                                    color: whiteone,
                                                  ),
                                                  Expanded(
                                                    child: SizedBox(
                                                      child: StreamBuilder(
                                                        stream: FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'comments')
                                                            .where('post_id',
                                                                isEqualTo:
                                                                    postid)
                                                            .orderBy(
                                                                'time_stamp',
                                                                descending:
                                                                    true)
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const Center(
                                                                child:
                                                                    CircularProgressIndicator());
                                                          }
                                                          if (snapshot
                                                              .hasError) {
                                                            return AppText(
                                                                name: snapshot
                                                                    .error
                                                                    .toString());
                                                          }
                                                          if (!snapshot
                                                                  .hasData ||
                                                              snapshot
                                                                  .data!
                                                                  .docs
                                                                  .isEmpty) {
                                                            return const Center(
                                                                child: Text(
                                                              'No comments found.',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ));
                                                          }
                                                          final comments =
                                                              snapshot
                                                                  .data!.docs;
                                                          return ListView
                                                              .builder(
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return ListTile(
                                                                leading:
                                                                    CircleAvatar(
                                                                  radius: 10,
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          comments[index]
                                                                              [
                                                                              'user_image']),
                                                                ),
                                                                title: AppText(
                                                                  name: comments[
                                                                          index]
                                                                      [
                                                                      'user_name'],
                                                                  size: 10,
                                                                ),
                                                                subtitle:
                                                                    AppText(
                                                                  name: comments[
                                                                          index]
                                                                      [
                                                                      'comment'],
                                                                  size: 12,
                                                                ),
                                                                trailing:
                                                                    IconButton(
                                                                  onPressed:
                                                                      () {},
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .favorite_border),
                                                                ),
                                                                onTap: () {
                                                                  Navigator
                                                                      .pushNamed(
                                                                    context,
                                                                    'friend',
                                                                    arguments: {
                                                                      'friend_id':
                                                                          comments[index]
                                                                              [
                                                                              'user_id']
                                                                    },
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            itemCount:
                                                                comments.length,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: TextFormField(
                                                        controller:
                                                            commentControllor,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                        decoration: InputDecoration(
                                                            hintText:
                                                                'Comment here..',
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                fontSize: 12)),
                                                      )),
                                                      IconButton(
                                                          onPressed: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'comments')
                                                                .add({
                                                              'post_id': postid,
                                                              'user_name':
                                                                  userData
                                                                      .user_name
                                                                      .value,
                                                              'user_image':
                                                                  userData
                                                                      .user_image
                                                                      .value,
                                                              'user_id':
                                                                  userData
                                                                      .id.value,
                                                              'comment':
                                                                  commentControllor
                                                                      .text,
                                                              'time_stamp':
                                                                  FieldValue
                                                                      .serverTimestamp(),
                                                            });
                                                            commentControllor
                                                                .clear();
                                                          },
                                                          icon: const Icon(
                                                            Icons.send,
                                                            color: whiteone,
                                                          ))
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: const Icon(
                                    Icons.mode_comment_outlined,
                                    color: whiteone,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: size.width * 0.05,
                            ),
                            Column(
                              children: [
                                const AppText(
                                  name: '',
                                  size: 10,
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: const Icon(
                                    Icons.send_rounded,
                                    color: whiteone,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        isHome
                            ? const SizedBox()
                            : InkWell(
                                onTap: () {
                                  if (isSaved == true) {
                                    FirebaseFirestore.instance
                                        .collection('posts')
                                        .doc(postid)
                                        .update({
                                      'saved': FieldValue.arrayRemove(
                                          [userData.id.value]),
                                    });
                                  } else {
                                    FirebaseFirestore.instance
                                        .collection('posts')
                                        .doc(postid)
                                        .update({
                                      'saved': FieldValue.arrayUnion(
                                          [userData.id.value]),
                                    });
                                  }
                                },
                                child: isSaved
                                    ? const Icon(
                                        Icons.bookmark_outlined,
                                        color: whiteone,
                                      )
                                    : const Icon(
                                        Icons.bookmark_border_outlined,
                                        color: whiteone,
                                      ),
                              ),
                      ],
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: size.height * 0.02),
                    //   child: Row(
                    //     children: [
                    //       const CircleAvatar(
                    //         radius: 10,
                    //         backgroundImage: AssetImage('assets/girl.jpg'),
                    //       ),
                    //       Padding(
                    //         padding: EdgeInsets.only(left: size.width * 0.01),
                    //         child: AppText(
                    //           name: 'Liked by _jothi,$likecount others',
                    //           size: 13,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: size.width * 0.01,
                    ),
                    ReadMoreText(
                      "${username.toLowerCase()}, $caption",
                      style: const TextStyle(color: whiteone, fontSize: 12),
                      trimMode: TrimMode.Line,
                      trimLines: 2,
                      colorClickableText: Colors.grey,
                      trimCollapsedText: 'Show more',
                      trimExpandedText: 'Show less',
                      moreStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),

                    // AppText(
                    //   name: '$commentcount Comment',
                    //   colors: Colors.grey,
                    //   size: 12,
                    // ),
                    // const SizedBox(height: 3),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
