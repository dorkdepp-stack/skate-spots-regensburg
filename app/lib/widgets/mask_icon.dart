import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Ports the prototype's `.sk-ico` CSS mask trick — a flat-color SVG used as
/// an alpha mask, tinted with `currentColor`, `mask-size:contain`,
/// `mask-position:center` — to Flutter via [SvgPicture] + a `srcIn`
/// [ColorFilter], which is the exact same recolor-by-alpha-shape behavior.
class MaskIcon extends StatelessWidget {
  const MaskIcon({
    super.key,
    required this.asset,
    required this.width,
    required this.height,
    required this.color,
  });

  final String asset;
  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: width,
      height: height,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
