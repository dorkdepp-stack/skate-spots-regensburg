import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/spot.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/pill_chip.dart';
import '../widgets/spot_image.dart';

/// Ports the `onSpots` block — the scrolling spot list with its filter
/// chip row (replaces the old map-first "what'cha want" bar per the
/// second chat's instructions).
class SpotsScreen extends StatelessWidget {
  const SpotsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final visible = state.visibleSpots;

    return Container(
      color: kK,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('spots', style: fugaz(28, color: kWhite))),
              Text('${visible.length} spots', style: meta(10, color: kMid)),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final f in ['all', ...allTags])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: PillChip(
                      label: f,
                      height: 40,
                      hPad: 16,
                      fontSize: 16,
                      bg: state.chip(state.filter == f).bg,
                      fg: state.chip(state.filter == f).fg,
                      border: state.chip(state.filter == f).br,
                      onTap: () => state.pickFilter(f),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemCount: visible.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _SpotRow(spot: visible[i], state: state),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpotRow extends StatelessWidget {
  const _SpotRow({required this.spot, required this.state});
  final Spot spot;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    return SkTap(
      onTap: () => state.openSpot(spot.id),
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(color: kG, borderRadius: BorderRadius.circular(20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 94,
                height: 94,
                child: SpotImage(path: state.photoFor(spot)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(spot.name, style: freeman(19, color: kK, height: 1.1)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      for (final tg in spot.tags)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            border: Border.all(color: kK, width: 1.5),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text(
                            tg,
                            style: const TextStyle(fontSize: 9, letterSpacing: 0.81, color: kK),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${state.distanceLabel(spot)} · ${spot.edits} edits',
                          style: meta(10, color: kK),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: kK, borderRadius: BorderRadius.circular(9)),
                        child: Text(statusLabels[spot.status]!, style: meta(10, color: kG)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
