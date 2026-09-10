import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/mask_icon.dart';
import '../widgets/pill_chip.dart';
import '../widgets/spot_image.dart';

/// Ports the `onThread` block.
class ThreadScreen extends StatefulWidget {
  const ThreadScreen({super.key});

  @override
  State<ThreadScreen> createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  late final TextEditingController _replyCtrl;

  @override
  void initState() {
    super.initState();
    _replyCtrl = TextEditingController(text: context.read<AppState>().reply);
  }

  @override
  void dispose() {
    _replyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final thread = state.currentThread;

    return Container(
      color: kK,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
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
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        thread.title,
                        style: freeman(18, color: kWhite, height: 1.1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('${thread.tag} · ${thread.replies} replies', style: meta(10, color: kMid)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              itemCount: state.posts.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final p = state.posts[i];
                final bg = p.op ? kG : kK;
                final fg = p.op ? kK : kG;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                  decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: SizedBox(
                          width: 43,
                          height: 43,
                          child: SpotImage(path: state.avatarFor(i)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(p.who, style: freeman(16, color: fg)),
                                const SizedBox(width: 8),
                                Text(p.when, style: stint(17, color: fg)),
                                if (p.op) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(color: kK, borderRadius: BorderRadius.circular(8)),
                                    child: Text('op', style: meta(9, color: kG)),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(p.text, style: inter(13, color: fg, height: 1.5)),
                            if (p.spot != null) ...[
                              const SizedBox(height: 8),
                              SkTap(
                                onTap: () {
                                  final m = state.spots.where((x) => x.name == p.spot).toList();
                                  if (m.isNotEmpty) state.openSpot(m.first.id);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                  decoration: BoxDecoration(color: kK, borderRadius: BorderRadius.circular(16)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const MaskIcon(asset: 'assets/icons/icon-pin.svg', width: 11, height: 28, color: kG),
                                      const SizedBox(width: 8),
                                      Text(p.spot!, style: freeman(14, color: kG)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 9),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    MaskIcon(asset: 'assets/icons/icon-like.svg', width: 22, height: 22, color: fg),
                                    const SizedBox(width: 6),
                                    Text('${p.likes}', style: TextStyle(fontSize: 10, letterSpacing: 1, color: fg)),
                                  ],
                                ),
                                const SizedBox(width: 14),
                                MaskIcon(asset: 'assets/icons/icon-comment.svg', width: 22.857, height: 20, color: fg),
                                const SizedBox(width: 14),
                                MaskIcon(asset: 'assets/icons/icon-share.svg', width: 27.04, height: 10.509, color: fg),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyCtrl,
                    onChanged: state.setReply,
                    style: freeman(17, color: kK),
                    decoration: InputDecoration(
                      hintText: 'say something',
                      hintStyle: freeman(17, color: kK.withValues(alpha: 0.45)),
                      filled: true,
                      fillColor: kG,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(26), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                SkTap(
                  onTap: () {
                    state.sendReply();
                    _replyCtrl.clear();
                  },
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: kG, width: 2),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Text('post', style: fugaz(17, color: kG)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
