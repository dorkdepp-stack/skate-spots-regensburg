import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme.dart';
import 'mask_icon.dart';
import 'pill_chip.dart';

class _TabSpec {
  const _TabSpec(this.tab, this.screen, this.label, this.icon, this.w, this.h);
  final AppTab tab;
  final AppScreen screen;
  final String label;
  final String icon;
  final double w;
  final double h;
}

/// Ported from `tabs: [...]` — note `you` (skull) targets the `map`
/// screen too: profile is a stub in the source prototype.
const _tabs = [
  _TabSpec(AppTab.you, AppScreen.map, 'you', 'assets/icons/icon-skull.svg', 39, 39),
  _TabSpec(AppTab.inbox, AppScreen.messages, 'dm', 'assets/icons/icon-spray.svg', 16.325, 39),
  _TabSpec(AppTab.spots, AppScreen.spots, 'spots', 'assets/icons/icon-board.svg', 69.668, 10.816),
  _TabSpec(AppTab.map, AppScreen.map, 'map', 'assets/icons/icon-pin.svg', 15, 39),
  _TabSpec(AppTab.forum, AppScreen.forum, 'yard', 'assets/icons/icon-bubble.svg', 41.143, 39),
];

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Container(
      color: kK,
      padding: const EdgeInsets.fromLTRB(26, 14, 26, 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final t in _tabs)
            SkTap(
              onTap: () => state.selectTab(t.tab, t.screen),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 39,
                    child: Center(
                      child: MaskIcon(
                        asset: t.icon,
                        width: t.w,
                        height: t.h,
                        color: state.tab == t.tab ? kWhite : kMid,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    t.label.toUpperCase(),
                    style: meta(9, color: state.tab == t.tab ? kWhite : kMid, letterSpacingEm: 0.11),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
