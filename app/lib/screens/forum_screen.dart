import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/pill_chip.dart';

/// Ports the `onForum` block — "the yard".
class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final threads = state.visibleThreads;

    return Container(
      color: kK,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('the yard', style: fugaz(28, color: kWhite))),
              Text('2,431 heads', style: meta(10, color: kMid)),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final b in boardNames)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: PillChip(
                      label: b.toLowerCase(),
                      height: 40,
                      hPad: 16,
                      fontSize: 16,
                      bg: state.chip(state.board == b).bg,
                      fg: state.chip(state.board == b).fg,
                      border: state.chip(state.board == b).br,
                      onTap: () => state.pickBoard(b),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemCount: threads.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final t = threads[i];
                return SkTap(
                  onTap: () => state.openThread(t.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(color: kG, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(t.tag, style: meta(10, color: kK)),
                            const SizedBox(width: 8),
                            Text(t.when, style: meta(10, color: kMid)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(t.title, style: freeman(19, color: kK, height: 1.15)),
                        const SizedBox(height: 6),
                        Text('${t.by} · ${t.replies} replies · ${t.likes} up', style: meta(10, color: kK)),
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
