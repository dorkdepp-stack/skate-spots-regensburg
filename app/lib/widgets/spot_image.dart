import 'dart:io';

import 'package:flutter/material.dart';

import '../theme.dart';

/// A photo that may either be a bundled mock asset (`assets/images/...`)
/// or a real file captured through the camera screen. `MID` (#7c7c7c) is
/// the placeholder background used everywhere behind photos in the
/// prototype (`background:#7c7c7c url(...) center / cover no-repeat`).
class SpotImage extends StatelessWidget {
  const SpotImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
  });

  final String path;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kMid,
      child: path.startsWith('assets/')
          ? Image.asset(path, fit: fit, width: double.infinity, height: double.infinity)
          : Image.file(File(path), fit: fit, width: double.infinity, height: double.infinity),
    );
  }
}
