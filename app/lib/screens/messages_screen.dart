import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/pill_chip.dart';
import '../widgets/spot_image.dart';

/// Ports the `onMessages` block. Note: in the source template neither
/// the convo rows nor the "+" button have an `onClick` — chat threads
/// are a stub per the design chat ("Chat threads and profile are
/// stubs") — so this stays a static list with tap-feedback only.
class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Container(
      color: kK,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text("dm's", style: fugaz(28, color: kWhite))),
              SkTap(
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: kG, borderRadius: BorderRadius.circular(22)),
                  child: Text('+', style: fugaz(22, color: kK)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Expanded(
            child: ListView.separated(
              itemCount: state.convos.length,
              separatorBuilder: (_, _) => const SizedBox(height: 9),
              itemBuilder: (_, i) {
                final m = state.convos[i];
                final bg = m.unread ? kG : kK;
                final fg = m.unread ? kK : kG;
                return SkTap(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        ClipOval(
                          child: SizedBox(width: 44, height: 44, child: SpotImage(path: state.avatarFor(i + 1))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Expanded(
                                    child: Text(
                                      m.who,
                                      style: freeman(17, color: fg),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(m.when, style: meta(10, color: fg.withValues(alpha: 0.6), letterSpacingEm: 0.09)),
                                ],
                              ),
                              Text(
                                m.last,
                                style: inter(12, color: fg.withValues(alpha: 0.85)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (m.unread) ...[
                          const SizedBox(width: 8),
                          Container(width: 10, height: 10, decoration: const BoxDecoration(color: kK, shape: BoxShape.circle)),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
