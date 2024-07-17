

import 'package:flutter/material.dart';

import '../const/color.dart';
import 'app_text.dart';

class StorySection extends StatelessWidget {
  const StorySection({
    super.key,
    required this.size,
    required this.name,
    required this.image,
    required this.onview,
  });

  final Size size;
  final String image;
  final String name;
  final void Function() onview;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: size.width * 0.03),
          child: InkWell(
            onTap: onview,
            child: CircleAvatar(
              radius: 32,
              backgroundColor: customPurple,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: customBlack1,
                backgroundImage: NetworkImage(image),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: size.height * 0.01),
          child: AppText(
            name: name,
            size: 12,
          ),
        ),
      ],
    );
  }
}
