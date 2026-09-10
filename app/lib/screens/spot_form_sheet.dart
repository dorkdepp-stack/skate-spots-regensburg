import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/spot.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/dashed_border_box.dart';
import '../widgets/mask_icon.dart';
import '../widgets/pill_chip.dart';
import '../widgets/spot_image.dart';

/// Ports the `onForm` block — the add/edit bottom sheet. Note that in
/// the source template `onForm` is a sibling of `onMap`, and `onMap`'s
/// condition is `screen === 'map' || screen === 'form'`, so the map
/// stays mounted (and visible through the scrim) behind this sheet —
/// [AppShell] reproduces that by stacking both when `screen == form`.
class SpotFormSheet extends StatefulWidget {
  const SpotFormSheet({super.key});

  @override
  State<SpotFormSheet> createState() => _SpotFormSheetState();
}

class _SpotFormSheetState extends State<SpotFormSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _betaCtrl;

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    _nameCtrl = TextEditingController(text: state.fName);
    _betaCtrl = TextEditingController(text: state.fBeta);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _betaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final spot = state.selectedSpot;
    final formCoords = state.draft != null
        ? state.coordStr(state.draft!.$1, state.draft!.$2)
        : spot.coords;

    return Container(
      color: const Color(0xB8000000), // rgba(0,0,0,.72)
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Container(
          decoration: const BoxDecoration(
            color: kK,
            border: Border(top: BorderSide(color: kG, width: 2)),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(state.editing ? 'fix it up' : 'new spot', style: fugaz(24, color: kWhite)),
                    Text(formCoords, style: meta(10, color: kMid)),
                  ],
                ),
                const SizedBox(height: 13),
                TextField(
                  controller: _nameCtrl,
                  onChanged: state.setName,
                  style: freeman(19, color: kK),
                  decoration: InputDecoration(
                    hintText: 'name it',
                    hintStyle: freeman(19, color: kK.withValues(alpha: 0.45)),
                    filled: true,
                    fillColor: kG,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(27.5), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 13),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final k in allTags)
                      PillChip(
                        label: k,
                        height: 42,
                        hPad: 16,
                        fontSize: 16,
                        bg: state.chip(state.fTags.contains(k)).bg,
                        fg: state.chip(state.fTags.contains(k)).fg,
                        border: state.chip(state.fTags.contains(k)).br,
                        onTap: () => state.toggleTag(k),
                      ),
                  ],
                ),
                const SizedBox(height: 13),
                SizedBox(
                  height: 86,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var i = 0; i < state.shots.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(right: 9),
                          child: SizedBox(
                            width: 86,
                            height: 86,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: SpotImage(path: state.shots[i]),
                                ),
                                Positioned(
                                  top: -6,
                                  right: -6,
                                  child: SkTap(
                                    onTap: () => state.removeShot(i),
                                    child: Container(
                                      width: 26,
                                      height: 26,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(color: kK, shape: BoxShape.circle),
                                      child: Text('×', style: fugaz(14, color: kG)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      SkTap(
                        onTap: state.openCamera,
                        child: DashedBorderBox(
                          width: 86,
                          height: 86,
                          radius: 18,
                          color: kMid,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const MaskIcon(asset: 'assets/icons/icon-bubble.svg', width: 26, height: 25, color: kG),
                              const SizedBox(height: 5),
                              Text('shoot it', style: meta(9, color: kG)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 13),
                TextField(
                  controller: _betaCtrl,
                  onChanged: state.setBeta,
                  maxLines: 4,
                  minLines: 3,
                  style: inter(13, color: kK, height: 1.5),
                  decoration: InputDecoration(
                    hintText: 'surface, run-up, bust risk, best hours',
                    hintStyle: inter(13, color: kK.withValues(alpha: 0.45), height: 1.5),
                    filled: true,
                    fillColor: kG,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 13),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: kG, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('crew only', style: freeman(17, color: kG)),
                          Text('hidden from the map', style: meta(10, color: kMid)),
                        ],
                      ),
                      SkTap(
                        onTap: state.togglePrivate,
                        child: Container(
                          width: 56,
                          height: 32,
                          padding: const EdgeInsets.all(3),
                          alignment: state.fPriv ? Alignment.centerRight : Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: state.fPriv ? kG : kK,
                            border: Border.all(color: kG, width: 2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: state.fPriv ? kK : kMid,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 13),
                Row(
                  children: [
                    SkTap(
                      onTap: state.cancelForm,
                      child: Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: kG, width: 2),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Text('nah', style: freeman(17, color: kG)),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: SkTap(
                        onTap: state.saveSpot,
                        child: Container(
                          height: 52,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: kG, borderRadius: BorderRadius.circular(26)),
                          child: Text(state.editing ? 'save it' : 'put it up', style: fugaz(19, color: kK)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
