import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:provider/provider.dart';

import '../models/spot.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/mask_icon.dart';
import '../widgets/pill_chip.dart';
import '../widgets/spot_image.dart';

const _center = ll.LatLng(49.0205, 12.0965);

/// Ports the `onMap` block: the live map (`map.html`, now a native
/// flutter_map instead of a Leaflet iframe), the tag filter row, the
/// layer-toggle + "tag a spot" row, the horizontally-snapping card
/// rail, the placing crosshair, and the "where at?" confirmation bar.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final visible = state.visibleSpots;
    final isSat = state.mapLayer == 'sat';

    return Stack(
      fit: StackFit.expand,
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _center,
            initialZoom: 15,
            onTap: (tapPosition, point) => state.onMapTap(point.latitude, point.longitude),
          ),
          children: [
            if (isSat)
              TileLayer(
                urlTemplate:
                    'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                userAgentPackageName: 'com.spotapp.app',
              )
            else
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.spotapp.app',
              ),
            MarkerLayer(
              markers: [
                for (final s in visible)
                  _pinMarker(state, s, selected: s.id == state.sel),
              ],
            ),
            RichAttributionWidget(
              alignment: AttributionAlignment.bottomLeft,
              popupInitialDisplayDuration: Duration.zero,
              attributions: [
                TextSourceAttribution(
                  isSat ? 'Imagery © Esri, Maxar, Earthstar Geographics' : '© OpenStreetMap contributors',
                  textStyle: const TextStyle(color: kG, fontSize: 9),
                ),
              ],
            ),
          ],
        ),

        if (state.placing) const _PlacingCrosshair(),

        // Filter chip row.
        Positioned(
          left: 12,
          right: 12,
          top: 11,
          child: SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final f in ['all', ...allTags])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: PillChip(
                      label: f,
                      height: 42,
                      hPad: 18,
                      fontSize: 17,
                      bg: state.chip(state.filter == f).bg,
                      fg: state.chip(state.filter == f).fg,
                      onTap: () => state.pickFilter(f),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Layer toggle + tag-a-spot row, and card rail.
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SkTap(
                      onTap: state.toggleLayer,
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: kK,
                          border: Border.all(color: kG, width: 2),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Text(
                          isSat ? 'street' : 'satellite',
                          style: freeman(16, color: kG),
                        ),
                      ),
                    ),
                    SkTap(
                      onTap: state.startPlace,
                      child: Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: kG,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const MaskIcon(
                              asset: 'assets/icons/icon-spray.svg',
                              width: 16,
                              height: 38,
                              color: kK,
                            ),
                            const SizedBox(width: 10),
                            Text('tag a spot', style: fugaz(18, color: kK)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final s in visible) _RailCard(spot: s, state: state),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        if (state.placing)
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: _WhereAtBar(state: state),
          ),
      ],
    );
  }

  Marker _pinMarker(AppState state, Spot s, {required bool selected}) {
    final shortName = s.name.split(' ').first.toLowerCase();
    final badge = (state.spots.indexOf(s) + 1).toString();
    final width = 34.0 + shortName.length * 7;
    return Marker(
      point: ll.LatLng(s.lat, s.lng),
      width: width,
      height: 54,
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () => state.openSpot(s.id),
        child: _PinLabel(badge: badge, name: shortName, selected: selected),
      ),
    );
  }
}

class _PinLabel extends StatelessWidget {
  const _PinLabel({required this.badge, required this.name, required this.selected});
  final String badge;
  final String name;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final pill = Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? kWhite : kG,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(text: badge, style: freeman(14, color: kK)),
          TextSpan(text: ' $name', style: freeman(14, color: kK)),
        ]),
      ),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        selected
            ? Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: Border.all(color: kG, width: 2),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: pill,
              )
            : pill,
        Container(width: 2, height: 14, color: kG),
      ],
    );
  }
}

class _PlacingCrosshair extends StatelessWidget {
  const _PlacingCrosshair();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned(top: 0, bottom: 0, child: VerticalDivider(color: kG, thickness: 2, width: 2)),
          const Positioned(left: 0, right: 0, child: Divider(color: kG, thickness: 2, height: 2)),
          SizedBox(
            width: 56,
            height: 56,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kG, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WhereAtBar extends StatelessWidget {
  const _WhereAtBar({required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: kG, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('where at?', style: fugaz(19, color: kK)),
                const SizedBox(height: 3),
                Text('tap the map · ±5 m', style: meta(10, color: kK)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SkTap(
            onTap: state.cancelPlace,
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: kK, borderRadius: BorderRadius.circular(19)),
              child: Text('nah', style: freeman(15, color: kG)),
            ),
          ),
        ],
      ),
    );
  }
}

class _RailCard extends StatelessWidget {
  const _RailCard({required this.spot, required this.state});
  final Spot spot;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    return SkTap(
      onTap: () => state.openSpot(spot.id),
      child: Container(
        width: 214,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(color: kG, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                height: 96,
                width: double.infinity,
                child: Stack(
                  children: [
                    SpotImage(path: state.photoFor(spot)),
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: kK, borderRadius: BorderRadius.circular(9)),
                        child: Text(
                          spot.tags.join(' · '),
                          style: const TextStyle(fontSize: 10, letterSpacing: 0.4, color: kG),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 9),
            Text(spot.name, style: freeman(18, color: kK, height: 1.05)),
            const SizedBox(height: 7),
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
    );
  }
}
