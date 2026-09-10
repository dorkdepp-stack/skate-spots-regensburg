import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/spot.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/mask_icon.dart';
import '../widgets/pill_chip.dart';
import '../widgets/spot_image.dart';

/// Ports the `onSpot` block. Note: the top "save" button has no
/// `onClick` in the source template either — it's decorative, saving
/// happens through the status picker and the edit form — so it's kept
/// visually present but inert here too.
class SpotDetailScreen extends StatelessWidget {
  const SpotDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final spot = state.selectedSpot;
    final photo = state.photoFor(spot);
    final uploads = spot.photos.length + 3;

    return Container(
      color: kK,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
      child: ListView(
        children: [
          Row(
            children: [
              SkTap(
                onTap: state.back,
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: kG, borderRadius: BorderRadius.circular(22)),
                  child: Text('‹', style: fugaz(20, color: kK)),
                ),
              ),
              const Spacer(),
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kK,
                  border: Border.all(color: kG, width: 2),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text('save', style: freeman(16, color: kG)),
              ),
              const SizedBox(width: 8),
              SkTap(
                onTap: state.openEdit,
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: kG, borderRadius: BorderRadius.circular(22)),
                  child: Text('edit', style: freeman(16, color: kK)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(19),
            child: SizedBox(
              height: 220,
              width: double.infinity,
              child: Stack(
                children: [
                  SpotImage(path: photo),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(color: kK, borderRadius: BorderRadius.circular(10)),
                          child: Text('$uploads uploads', style: meta(10, color: kG)),
                        ),
                        SkTap(
                          onTap: () => state.openSpotCamera(spot.id),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: kG, borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const MaskIcon(
                                  asset: 'assets/icons/icon-bubble.svg',
                                  width: 18,
                                  height: 17,
                                  color: kK,
                                ),
                                const SizedBox(width: 7),
                                Text('add photo', style: freeman(14, color: kK)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(spot.name, style: fugaz(30, color: kWhite, height: 1.05)),
          const SizedBox(height: 4),
          Text('${spot.coords} · ${spot.by} · ${spot.edits} edits', style: meta(10, color: kMid)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final tg in spot.tags)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: kG, width: 2),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Text(tg, style: meta(10, color: kG, letterSpacingEm: 0.09)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final entry in statusLabels.entries) ...[
                Expanded(child: _StatusButton(state: state, statusKey: entry.key, label: entry.value)),
                if (entry.key != statusLabels.keys.last) const SizedBox(width: 8),
              ],
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.6,
            children: [
              for (final sp in spot.specs)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                  decoration: BoxDecoration(color: kG, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(sp.$1, style: meta(9, color: kK, letterSpacingEm: 0.11)),
                      const SizedBox(height: 3),
                      Text(sp.$2, style: freeman(16, color: kK, height: 1.15)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(color: kG, borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('the beta', style: meta(9, color: kK, letterSpacingEm: 0.11)),
                const SizedBox(height: 6),
                Text(spot.beta, style: inter(13, color: kK, height: 1.5)),
                const SizedBox(height: 8),
                Text('edited 4d ago by ${spot.lastEditor}', style: meta(9, color: kK, letterSpacingEm: 0.09)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SkTap(
            onTap: state.goThread,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: kK,
                border: Border.all(color: kG, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const MaskIcon(asset: 'assets/icons/icon-bubble.svg', width: 26, height: 25, color: kG),
                  const SizedBox(width: 12),
                  Expanded(child: Text('spot thread', style: freeman(17, color: kG))),
                  Text('${state.posts.length} posts', style: meta(10, color: kMid)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  const _StatusButton({required this.state, required this.statusKey, required this.label});
  final AppState state;
  final String statusKey;
  final String label;

  @override
  Widget build(BuildContext context) {
    final on = state.selectedSpot.status == statusKey;
    final colors = on
        ? (bg: kG, fg: kK, br: kG)
        : (bg: kK, fg: kG, br: kMid);
    return SkTap(
      onTap: () => state.setStatus(statusKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
        decoration: BoxDecoration(
          color: colors.bg,
          border: Border.all(color: colors.br, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(label, style: freeman(16, color: colors.fg), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(on ? 'confirmed by you' : 'tap to switch', style: meta(9, color: colors.fg, letterSpacingEm: 0.09)),
          ],
        ),
      ),
    );
  }
}
