import 'package:flutter/material.dart';

import '../const/color.dart';
import 'app_text.dart';

class UserStory extends StatelessWidget {
  const UserStory({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.03),
              child: const InkWell(
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: customPurple,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: customBlack1,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.01),
              child: const AppText(
                name: 'Your Story',
                size: 10,
              ),
            ),
          ],
        ),
        Positioned(
            left: size.width * 0.1,
            bottom: size.width * 0.03,
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.add,
                  color: whiteone,
                )))
      ],
    );
  }
}
