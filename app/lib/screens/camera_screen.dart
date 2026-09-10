import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/pill_chip.dart';
import '../widgets/spot_image.dart';

/// `filter: grayscale(1) contrast(1.15)` as a 4x5 color matrix — CSS
/// grayscale (luminance weights) folded into a contrast pivot around
/// mid-gray, applied to both the live preview and the no-camera
/// fallback frame so they read identically to the design.
const _kGrayscaleContrastMatrix = <double>[
  0.2445, 0.8225, 0.0830, 0, -19.125,
  0.2445, 0.8225, 0.0830, 0, -19.125,
  0.2445, 0.8225, 0.0830, 0, -19.125,
  0, 0, 0, 1, 0,
];

/// Ports the `onCamera` block. Uses the real `camera` plugin for a
/// live viewfinder; if no camera is available (denied permission,
/// desktop/emulator with none attached) it falls back to the same
/// `camError` demo-frame state the source design already accounted
/// for, with the same fallback still image (`ph-8.png`).
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final cameras = await availableCameras();
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(back, ResolutionPreset.high, enableAudio: false);
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
      context.read<AppState>().setCamError(false);
    } catch (_) {
      if (!mounted) return;
      context.read<AppState>().setCamError(true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _shutter(AppState state) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      if (state.camError || _controller == null || !_controller!.value.isInitialized) {
        state.addShot('assets/images/ph-8.png');
        return;
      }
      final shot = await _controller!.takePicture();
      final processed = await _bakeFilter(shot.path);
      state.addShot(processed);
    } catch (_) {
      state.addShot('assets/images/ph-8.png');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Bakes `grayscale(1) contrast(1.15)` into the captured file, the
  /// same way the source's `grab()` draws through a filtered 2D canvas
  /// context before exporting the dataURL.
  Future<String> _bakeFilter(String sourcePath) async {
    final bytes = await File(sourcePath).readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return sourcePath;
    final gray = img.grayscale(decoded);
    final contrasted = img.contrast(gray, contrast: 115);
    final dir = await getTemporaryDirectory();
    final outPath = p.join(dir.path, 'spot_${DateTime.now().microsecondsSinceEpoch}.jpg');
    await File(outPath).writeAsBytes(img.encodeJpg(contrasted, quality: 82));
    return outPath;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final targetSpot = state.camTarget != null
        ? state.spots.where((s) => s.id == state.camTarget).map((s) => s.name).firstOrNull
        : null;
    final camLabel = state.camError
        ? 'camera blocked — demo frame'
        : (targetSpot != null ? 'adding to $targetSpot' : 'new spot');

    return Container(
      color: kK,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: kMid,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ColorFiltered(
                        colorFilter: const ColorFilter.matrix(_kGrayscaleContrastMatrix),
                        child: state.camError || _controller == null || !_controller!.value.isInitialized
                            ? const SpotImage(path: 'assets/images/ph-8.png')
                            : Center(
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width: _controller!.value.previewSize?.height ?? 1,
                                    height: _controller!.value.previewSize?.width ?? 1,
                                    child: CameraPreview(_controller!),
                                  ),
                                ),
                              ),
                      ),
                      const IgnorePointer(
                        child: _CornerBrackets(),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        top: 16,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(color: kK, borderRadius: BorderRadius.circular(11)),
                                child: Text(camLabel, style: meta(10, color: kG, letterSpacingEm: 0.11)),
                              ),
                            ),
                            SkTap(
                              onTap: state.closeCamera,
                              child: Container(
                                width: 38,
                                height: 38,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(color: kK, shape: BoxShape.circle),
                                child: Text('×', style: fugaz(18, color: kG)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (final src in state.shots)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(width: 54, height: 54, child: SpotImage(path: src)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                SkTap(
                  onTap: _busy ? null : () => _shutter(state),
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: kG,
                      shape: BoxShape.circle,
                      border: Border.all(color: kK, width: 4),
                      boxShadow: const [BoxShadow(color: kG, blurRadius: 0, spreadRadius: 3)],
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SkTap(
                      onTap: state.doneCamera,
                      child: Text('done', style: freeman(17, color: kG)),
                    ),
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

class _CornerBrackets extends StatelessWidget {
  const _CornerBrackets();

  @override
  Widget build(BuildContext context) {
    Widget corner({required bool left, required bool top}) {
      return Positioned(
        left: left ? 16 : null,
        right: left ? null : 16,
        top: top ? 16 : null,
        bottom: top ? null : 16,
        child: Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            border: Border(
              left: left ? const BorderSide(color: kG, width: 3) : BorderSide.none,
              right: !left ? const BorderSide(color: kG, width: 3) : BorderSide.none,
              top: top ? const BorderSide(color: kG, width: 3) : BorderSide.none,
              bottom: !top ? const BorderSide(color: kG, width: 3) : BorderSide.none,
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        corner(left: true, top: true),
        corner(left: false, top: true),
        corner(left: true, top: false),
        corner(left: false, top: false),
      ],
    );
  }
}
