import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/bottom_nav.dart';
import 'camera_screen.dart';
import 'forum_screen.dart';
import 'map_screen.dart';
import 'messages_screen.dart';
import 'spot_detail_screen.dart';
import 'spot_form_sheet.dart';
import 'spots_screen.dart';
import 'thread_screen.dart';

/// Root layout — ports the outer `<div style="display:flex;flex-direction:
/// column;...">` with a `flex:1` screen area on top and the fixed-height
/// nav bar underneath. Screens are DOM siblings in the source, each an
/// absolutely-positioned `sc-if`, painted in source order — a [Stack]
/// reproduces that exactly, including `onMap` staying mounted (and
/// visible) underneath the `form` bottom sheet, and the camera overlay
/// floating above everything regardless of `screen`.
class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final onMap = state.screen == AppScreen.map || state.screen == AppScreen.form;

    return Scaffold(
      backgroundColor: kK,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (onMap) const MapScreen(),
                  if (state.screen == AppScreen.spots) const SpotsScreen(),
                  if (state.screen == AppScreen.spot) const SpotDetailScreen(),
                  if (state.screen == AppScreen.form) const SpotFormSheet(),
                  if (state.screen == AppScreen.forum) const ForumScreen(),
                  if (state.screen == AppScreen.thread) const ThreadScreen(),
                  if (state.screen == AppScreen.messages) const MessagesScreen(),
                  if (state.camera) const CameraScreen(),
                ],
              ),
            ),
            const BottomNav(),
          ],
        ),
      ),
    );
  }
}
