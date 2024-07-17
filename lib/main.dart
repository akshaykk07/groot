import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/controllor/basic_controllor.dart';
import 'package:socialapp/firebase_options.dart';

import 'controllor/image_controllor.dart';

import 'controllor/user_controllor.dart';

import 'view/follwer_list.dart';
import 'view/friend_profile.dart';

import 'view/mainscreen.dart';

import 'view/register_page.dart';
import 'view/saved_screen.dart';
import 'view/share_post.dart';
import 'view/sory.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

  Get.put(BasicControllors());
  Get.put(PickImageController());
  Get.put(GetuserData());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: RegisterPage(),
      routes: {
        'mainscreen': (context) => MainScreen(),
        'viewstory': (context) => StoryViewer(),
        'sharepost': (context) => SharePost(),
        'saved': (context) => SavedScreen(),
        'friend': (context) => FriendProfile(),
        'followers': (context) => FollowersList(),
        'following': (context) => FollowingList(),
      },
    );
  }
}
