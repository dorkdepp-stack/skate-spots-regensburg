import 'package:flutter/material.dart';

import '../theme.dart';

/// The `.sk-tap` pill used throughout for filters, tags, and boards:
/// a rounded rect with Freeman label text, optional 2px border, and a
/// pressed-state opacity dip (`.sk-tap:active{opacity:.65}`).
class PillChip extends StatefulWidget {
  const PillChip({
    super.key,
    required this.label,
    required this.bg,
    required this.fg,
    this.border,
    this.height = 40,
    this.hPad = 16,
    this.fontSize = 16,
    this.onTap,
  });

  final String label;
  final Color bg;
  final Color fg;
  final Color? border;
  final double height;
  final double hPad;
  final double fontSize;
  final VoidCallback? onTap;

  @override
  State<PillChip> createState() => _PillChipState();
}

class _PillChipState extends State<PillChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      child: Opacity(
        opacity: _pressed ? 0.65 : 1,
        child: Container(
          height: widget.height,
          padding: EdgeInsets.symmetric(horizontal: widget.hPad),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.bg,
            borderRadius: BorderRadius.circular(widget.height / 2),
            border: widget.border != null
                ? Border.all(color: widget.border!, width: 2)
                : null,
          ),
          child: Text(
            widget.label,
            style: freeman(widget.fontSize, color: widget.fg),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

/// Generic tap-shrink wrapper for non-pill elements (`sk-tap` on its own).
class SkTap extends StatefulWidget {
  const SkTap({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<SkTap> createState() => _SkTapState();
}

class _SkTapState extends State<SkTap> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      child: Opacity(opacity: _pressed ? 0.65 : 1, child: widget.child),
    );
  }
}
