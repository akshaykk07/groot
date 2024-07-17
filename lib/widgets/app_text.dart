
import 'package:flutter/material.dart';

import '../const/color.dart';

class AppText extends StatelessWidget {
  const AppText( {
    super.key,
    required this.name,
    this.colors = whiteone,
    this.size,
  });

  final String name;
  final Color colors;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style:
          TextStyle(color: colors, overflow: TextOverflow.fade, fontSize: size),
    );
  }
}

