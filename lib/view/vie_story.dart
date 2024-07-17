
import 'package:flutter/material.dart';

import '../const/color.dart';
import '../widgets/app_text.dart';

class ViewStory extends StatelessWidget {
  const ViewStory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: customBlack2,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage('assets/girl.jpg'),
          ),
        ),
        title: const AppText(
          name: 'Amal Raj',
          size: 15,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: whiteone,
              ))
        ],
      ),
      body: Center(child: Image.asset('assets/girl.jpg')),
    );
  }
}