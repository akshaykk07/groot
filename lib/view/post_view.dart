import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/controllor/basic_controllor.dart';
import 'package:socialapp/widgets/feed_widgets.dart';

import '../const/color.dart';
import '../widgets/app_text.dart';

class PostView extends StatefulWidget {
  PostView({super.key, required this.index});
  final int index;
  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final ScrollController scrollController = ScrollController();
  BasicControllors basicControllors = Get.find();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToIndex(widget.index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ;

    return Scaffold(
      backgroundColor: customBlack2,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: whiteone),
        backgroundColor: customBlack2,
        title: const AppText(
          name: 'Posts',
          size: 18,
        ),
      ),
      body: ListView.builder(
        controller: scrollController,
        itemBuilder: (context, index) {
          return FeedWidget(
            size: size,
            profileimage: basicControllors.postList[index].profileimage,
            postimage: basicControllors.postList[index].postimage,
            caption: basicControllors.postList[index].caption,
            likecount: basicControllors.postList[index].likecount,
            commentcount: '${index + 1}',
            timestamp: basicControllors.postList[index].timestamp,
            username: basicControllors.postList[index].username,
            click: () {},
            isLike: true,
            postid: basicControllors.postList[index].postid,
            isSaved: false,
            isHome: true,
          );
        },
        itemCount: basicControllors.postList.length,
      ),
    );
  }

  void scrollToIndex(int index) {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        index * 550, // Assuming each item has a height of 100.0
        duration: const Duration(microseconds: 50000),
        curve: Curves.easeInOut,
      );
    }
  }
}

class FrentPostView extends StatefulWidget {
  FrentPostView({super.key, required this.index});
  final int index;
  @override
  State<FrentPostView> createState() => _FrentPostView();
}

class _FrentPostView extends State<FrentPostView> {
  final ScrollController scrollController = ScrollController();
  BasicControllors basicControllors = Get.find();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToIndex(widget.index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ;

    return Scaffold(
      backgroundColor: customBlack2,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: whiteone),
        backgroundColor: customBlack2,
        title: const AppText(
          name: 'Posts',
          size: 18,
        ),
      ),
      body: ListView.builder(
        controller: scrollController,
        itemBuilder: (context, index) {
          return FeedWidget(
            size: size,
            profileimage: basicControllors.fpostList[index].profileimage,
            postimage: basicControllors.fpostList[index].postimage,
            caption: basicControllors.fpostList[index].caption,
            likecount: basicControllors.fpostList[index].likecount,
            commentcount: '${index + 1}',
            timestamp: basicControllors.fpostList[index].timestamp,
            username: basicControllors.fpostList[index].username,
            click: () {},
            isLike: basicControllors.fpostList[index].isLike,
            postid: basicControllors.fpostList[index].postid,
            isSaved: basicControllors.fpostList[index].isSaved,
          );
        },
        itemCount: basicControllors.fpostList.length,
      ),
    );
  }

  void scrollToIndex(int index) {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        index * 550, // Assuming each item has a height of 100.0
        duration: const Duration(microseconds: 50000),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    basicControllors.fpostList.clear();
    super.dispose();
  }
}

class AllPostView extends StatefulWidget {
  AllPostView({super.key, required this.index});
  final int index;
  @override
  State<AllPostView> createState() => _AllPostView();
}

class _AllPostView extends State<AllPostView> {
  final ScrollController scrollController = ScrollController();
  BasicControllors basicControllors = Get.find();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToIndex(widget.index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ;

    return Scaffold(
      backgroundColor: customBlack2,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: whiteone),
        backgroundColor: customBlack2,
        title: const AppText(
          name: 'Posts',
          size: 18,
        ),
      ),
      body: ListView.builder(
        controller: scrollController,
        itemBuilder: (context, index) {
          return FeedWidget(
            size: size,
            profileimage: basicControllors.allpostList[index].profileimage,
            postimage: basicControllors.allpostList[index].postimage,
            caption: basicControllors.allpostList[index].caption,
            likecount: basicControllors.allpostList[index].likecount,
            commentcount: '${index + 1}',
            timestamp: basicControllors.allpostList[index].timestamp,
            username: basicControllors.allpostList[index].username,
            click: () {},
            isLike: true,
            postid: basicControllors.allpostList[index].postid,
            isSaved: false,
          );
        },
        itemCount: basicControllors.allpostList.length,
      ),
    );
  }

  void scrollToIndex(int index) {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        index * 400, // Assuming each item has a height of 100.0
        duration: const Duration(microseconds: 50000),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    basicControllors.fpostList.clear();
    super.dispose();
  }
}
